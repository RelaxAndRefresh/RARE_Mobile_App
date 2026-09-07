import pytest


@pytest.mark.asyncio
async def test_get_progress_new_user(client, test_user, auth_headers):
    response = await client.get("/api/v1/onboarding/progress", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["current_step"] == "welcome"
    assert data["is_complete"] is False


@pytest.mark.asyncio
async def test_update_step_success(client, test_user, auth_headers):
    response = await client.put(
        "/api/v1/onboarding/step",
        params={"step": "skin_scan"},
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert "skin_scan" in data["completed_steps"]


@pytest.mark.asyncio
async def test_update_step_complete(client, test_user, auth_headers):
    await client.put(
        "/api/v1/onboarding/step",
        params={"step": "complete"},
        headers=auth_headers,
    )
    response = await client.get("/api/v1/onboarding/progress", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["is_complete"] is True


@pytest.mark.asyncio
async def test_submit_soft_scan(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/onboarding/soft-scan",
        json={
            "skin_type": "combination",
            "barrier_status": "healthy",
            "adaptive_tags": ["oily_t_zone", "dry_cheeks"],
            "confidence": 0.85,
        },
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["skin_type"] == "combination"
    assert data["barrier_status"] == "healthy"
    assert "oily_t_zone" in data["adaptive_tags"]


@pytest.mark.asyncio
async def test_submit_soft_scan_manual_fallback(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/onboarding/soft-scan",
        json={
            "skin_type": "dry",
            "barrier_status": "compromised",
            "is_manual_fallback": True,
            "confidence": 0.0,
        },
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["skin_type"] == "dry"
    assert data["barrier_status"] == "compromised"


@pytest.mark.asyncio
async def test_save_privacy_consent(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/onboarding/privacy-consent",
        json={"category": "skin_photos", "consented": True},
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["category"] == "skin_photos"
    assert data["consented"] is True


@pytest.mark.asyncio
async def test_save_multiple_privacy_consents(client, test_user, auth_headers):
    categories = ["phone_activity", "cycle_tracking", "skin_photos"]
    for cat in categories:
        response = await client.post(
            "/api/v1/onboarding/privacy-consent",
            json={"category": cat, "consented": True},
            headers=auth_headers,
        )
        assert response.status_code == 200
        assert response.json()["category"] == cat

    response = await client.get("/api/v1/privacy/consents", headers=auth_headers)
    assert response.status_code == 200
    consents = response.json()["consents"]
    consented_cats = [c["category"] for c in consents if c["consented"]]
    for cat in categories:
        assert cat in consented_cats


@pytest.mark.asyncio
async def test_save_cycle_baseline(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/onboarding/cycle-baseline",
        json={
            "cycle_length": 28,
            "last_period_start": "2025-01-01",
        },
        headers=auth_headers,
    )
    assert response.status_code == 200


@pytest.mark.asyncio
async def test_save_wearable(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/onboarding/wearable",
        json={"provider": "fitbit", "device_id": "FB-12345"},
        headers=auth_headers,
    )
    assert response.status_code == 200


@pytest.mark.asyncio
async def test_save_wearable_skip(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/onboarding/wearable",
        json={"provider": "none", "device_id": ""},
        headers=auth_headers,
    )
    assert response.status_code == 200


@pytest.mark.asyncio
async def test_onboarding_unauthenticated(client):
    response = await client.get("/api/v1/onboarding/progress")
    assert response.status_code in [401, 403]
