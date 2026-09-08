import pytest


@pytest.mark.asyncio
async def test_get_consents_empty(client, test_user, auth_headers):
    response = await client.get("/api/v1/privacy/consents", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["consents"] == []


@pytest.mark.asyncio
async def test_get_consents(client, test_user, auth_headers):
    await client.post(
        "/api/v1/onboarding/privacy-consent",
        json={"category": "skin_photos", "consented": True},
        headers=auth_headers,
    )

    response = await client.get("/api/v1/privacy/consents", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert len(data["consents"]) >= 1


@pytest.mark.asyncio
async def test_update_consent(client, test_user, auth_headers):
    await client.post(
        "/api/v1/onboarding/privacy-consent",
        json={"category": "cycle_tracking", "consented": True},
        headers=auth_headers,
    )

    response = await client.put(
        "/api/v1/privacy/consents",
        json={"category": "cycle_tracking", "consented": False},
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "updated"


@pytest.mark.asyncio
async def test_update_consent_creates_audit_log(client, test_user, auth_headers, db):
    from app.db.models import PrivacyAuditLog

    await client.put(
        "/api/v1/privacy/consents",
        json={"category": "wearable_data", "consented": True},
        headers=auth_headers,
    )

    audit = db.query(PrivacyAuditLog).filter(
        PrivacyAuditLog.user_id == test_user.id,
        PrivacyAuditLog.action == "consent_update",
    ).first()
    assert audit is not None
    assert audit.details["category"] == "wearable_data"


@pytest.mark.asyncio
async def test_request_export(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/privacy/export",
        json={"export_type": "full", "email": "test@example.com"},
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "export_requested"


@pytest.mark.asyncio
async def test_request_deletion_success(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/privacy/delete",
        json={"confirmation": "DELETE_MY_ACCOUNT", "reason": "No longer using the app"},
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "deletion_requested"


@pytest.mark.asyncio
async def test_request_deletion_wrong_confirmation(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/privacy/delete",
        json={"confirmation": "WRONG_TEXT", "reason": "Testing"},
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert "error" in data


@pytest.mark.asyncio
async def test_privacy_unauthenticated(client):
    response = await client.get("/api/v1/privacy/consents")
    assert response.status_code in [401, 403]
