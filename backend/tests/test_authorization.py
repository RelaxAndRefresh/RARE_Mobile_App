import pytest


@pytest.mark.asyncio
async def test_user_cannot_access_practitioner_endpoint(client, test_user, auth_headers):
    response = await client.get(
        "/api/v1/practitioner/clients/1",
        headers=auth_headers,
    )
    assert response.status_code in [401, 403, 404]


@pytest.mark.asyncio
async def test_user_cannot_access_admin_dashboard(client, test_user, auth_headers):
    response = await client.get(
        "/api/v1/admin/dashboard",
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert "error" in data
    assert "Admin access required" in data["error"]


@pytest.mark.asyncio
async def test_user_cannot_access_admin_users(client, test_user, auth_headers):
    response = await client.get(
        "/api/v1/admin/users",
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert "error" in data


@pytest.mark.asyncio
async def test_practitioner_can_access_practitioner_endpoints(
    client, test_practitioner, practitioner_headers, db
):
    from app.db.models import User, PractitionerClient, CreditBalance
    from app.core.security import get_password_hash

    client_user = User(
        email="client_for_prac@example.com",
        name="Client User",
        password_hash=get_password_hash("Pass123!"),
        role="user",
        is_active=True,
    )
    db.add(client_user)
    db.flush()
    db.add(CreditBalance(user_id=client_user.id, balance=0))
    db.commit()
    db.refresh(client_user)

    pc = PractitionerClient(
        practitioner_id=test_practitioner.id,
        client_id=client_user.id,
    )
    db.add(pc)
    db.commit()

    response = await client.get(
        f"/api/v1/practitioner/clients/{client_user.id}",
        headers=practitioner_headers,
    )
    assert response.status_code == 200


@pytest.mark.asyncio
async def test_user_only_sees_own_resources(client, test_user, auth_headers, db):
    from app.db.models import SkinLog, CreditBalance, User
    from app.core.security import get_password_hash

    other = User(
        email="other_owner@example.com",
        name="Owner",
        password_hash=get_password_hash("Pass123!"),
        role="user",
        is_active=True,
    )
    db.add(other)
    db.flush()
    db.add(CreditBalance(user_id=other.id, balance=0))
    db.commit()
    db.refresh(other)

    other_log = SkinLog(user_id=other.id, tags=["secret"], rating=1)
    db.add(other_log)
    db.commit()

    my_log = SkinLog(user_id=test_user.id, tags=["mine"], rating=8)
    db.add(my_log)
    db.commit()

    response = await client.get("/api/v1/skin/timeline", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    for log in data["logs"]:
        assert "secret" not in (log.get("tags") or [])


@pytest.mark.asyncio
async def test_user_cannot_update_others_checkin(client, test_user, auth_headers, db):
    from app.db.models import User, DailyCheckin, CheckinType, CreditBalance
    from datetime import date
    from app.core.security import get_password_hash

    other = User(
        email="other_checkin@example.com",
        name="Other Checkin",
        password_hash=get_password_hash("Pass123!"),
        role="user",
        is_active=True,
    )
    db.add(other)
    db.flush()
    db.add(CreditBalance(user_id=other.id, balance=0))
    db.commit()
    db.refresh(other)

    other_checkin = DailyCheckin(
        user_id=other.id,
        checkin_type=CheckinType.am,
        date=date.today(),
        sleep_hours=4,
    )
    db.add(other_checkin)
    db.commit()
    db.refresh(other_checkin)

    response = await client.put(
        f"/api/v1/checkins/{other_checkin.id}",
        json={
            "checkin_type": "am",
            "sleep_hours": 10,
        },
        headers=auth_headers,
    )
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_unauthenticated_cannot_access_protected_endpoints(client):
    endpoints = [
        "/api/v1/auth/me",
        "/api/v1/onboarding/progress",
        "/api/v1/checkins/today",
        "/api/v1/skin/timeline",
        "/api/v1/shelf/items",
        "/api/v1/products/",
        "/api/v1/commerce/cart",
        "/api/v1/credits/balance",
        "/api/v1/privacy/consents",
        "/api/v1/inbox/",
    ]
    for endpoint in endpoints:
        response = await client.get(endpoint)
        assert response.status_code in [401, 403], f"Endpoint {endpoint} returned {response.status_code}"


@pytest.mark.asyncio
async def test_invalid_token_rejected(client):
    response = await client.get(
        "/api/v1/auth/me",
        headers={"Authorization": "Bearer invalid.token.here"},
    )
    assert response.status_code in [401, 403]


@pytest.mark.asyncio
async def test_expired_token_rejected(client, test_user):
    from datetime import timedelta
    from app.core.security import create_access_token

    expired_token = create_access_token(
        data={"sub": str(test_user.id), "role": "user"},
        expires_delta=timedelta(seconds=-1),
    )
    response = await client.get(
        "/api/v1/auth/me",
        headers={"Authorization": f"Bearer {expired_token}"},
    )
    assert response.status_code in [401, 403]


@pytest.mark.asyncio
async def test_refresh_token_cannot_be_used_as_access(client, test_user):
    from app.core.security import create_refresh_token

    refresh = create_refresh_token(
        data={"sub": str(test_user.id), "role": "user"},
    )
    response = await client.get(
        "/api/v1/auth/me",
        headers={"Authorization": f"Bearer {refresh}"},
    )
    assert response.status_code in [401, 403]
