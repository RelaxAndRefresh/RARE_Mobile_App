import pytest


@pytest.mark.asyncio
async def test_create_am_checkin(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/checkins/am",
        json={
            "checkin_type": "am",
            "sleep_hours": 7.5,
            "mood": 8,
            "energy": 7,
            "stress": 3,
            "skin_feel": "hydrated",
            "tags": ["well_rested"],
            "notes": "Great morning",
        },
        headers=auth_headers,
    )
    assert response.status_code == 201
    data = response.json()
    assert data["checkin_type"] == "am"
    assert data["sleep_hours"] == 7.5
    assert data["mood"] == 8
    assert "well_rested" in data["tags"]


@pytest.mark.asyncio
async def test_create_pm_checkin(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/checkins/pm",
        json={
            "checkin_type": "pm",
            "sleep_hours": 0,
            "mood": 6,
            "energy": 5,
            "stress": 5,
            "skin_feel": "oily",
            "tags": ["end_of_day"],
        },
        headers=auth_headers,
    )
    assert response.status_code == 201
    data = response.json()
    assert data["checkin_type"] == "pm"


@pytest.mark.asyncio
async def test_create_am_checkin_duplicate(client, test_user, auth_headers):
    checkin_data = {
        "checkin_type": "am",
        "sleep_hours": 7,
        "mood": 7,
        "energy": 7,
        "stress": 3,
    }
    resp1 = await client.post("/api/v1/checkins/am", json=checkin_data, headers=auth_headers)
    assert resp1.status_code == 201

    resp2 = await client.post("/api/v1/checkins/am", json=checkin_data, headers=auth_headers)
    assert resp2.status_code == 201


@pytest.mark.asyncio
async def test_get_today_checkins(client, test_user, auth_headers):
    await client.post(
        "/api/v1/checkins/am",
        json={
            "checkin_type": "am",
            "sleep_hours": 8,
            "mood": 9,
            "energy": 8,
            "stress": 2,
        },
        headers=auth_headers,
    )

    response = await client.get("/api/v1/checkins/today", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert "checkins" in data
    assert len(data["checkins"]) >= 1


@pytest.mark.asyncio
async def test_get_today_checkins_empty(client, test_user, auth_headers):
    response = await client.get("/api/v1/checkins/today", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["checkins"] == []


@pytest.mark.asyncio
async def test_update_checkin_success(client, test_user, auth_headers):
    create_resp = await client.post(
        "/api/v1/checkins/am",
        json={
            "checkin_type": "am",
            "sleep_hours": 6,
            "mood": 5,
            "energy": 5,
            "stress": 5,
        },
        headers=auth_headers,
    )
    checkin_id = create_resp.json()["id"]

    response = await client.put(
        f"/api/v1/checkins/{checkin_id}",
        json={
            "checkin_type": "am",
            "sleep_hours": 8,
            "mood": 8,
            "energy": 8,
            "stress": 2,
            "notes": "Updated notes",
        },
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["sleep_hours"] == 8
    assert data["notes"] == "Updated notes"


@pytest.mark.asyncio
async def test_update_checkin_not_found(client, test_user, auth_headers):
    response = await client.put(
        "/api/v1/checkins/99999",
        json={
            "checkin_type": "am",
            "sleep_hours": 8,
        },
        headers=auth_headers,
    )
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_update_checkin_not_owner(client, test_user, auth_headers, db):
    from app.db.models import User, DailyCheckin, CheckinType, CreditBalance
    from datetime import date
    from app.core.security import get_password_hash

    other_user = User(
        email="other@example.com",
        name="Other",
        password_hash=get_password_hash("Pass123!"),
        role="user",
        is_active=True,
    )
    db.add(other_user)
    db.flush()
    db.add(CreditBalance(user_id=other_user.id, balance=0))
    db.commit()
    db.refresh(other_user)

    other_checkin = DailyCheckin(
        user_id=other_user.id,
        checkin_type=CheckinType.am,
        date=date.today(),
        sleep_hours=5,
    )
    db.add(other_checkin)
    db.commit()
    db.refresh(other_checkin)

    response = await client.put(
        f"/api/v1/checkins/{other_checkin.id}",
        json={
            "checkin_type": "am",
            "sleep_hours": 9,
        },
        headers=auth_headers,
    )
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_checkins_unauthenticated(client):
    response = await client.get("/api/v1/checkins/today")
    assert response.status_code in [401, 403]
