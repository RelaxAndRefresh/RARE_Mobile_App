import pytest


@pytest.mark.asyncio
async def test_get_balance(client, test_user, auth_headers):
    response = await client.get("/api/v1/credits/balance", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert "balance" in data
    assert data["balance"] == 0


@pytest.mark.asyncio
async def test_get_balance_creates_if_missing(client, test_user, auth_headers, db):
    from app.db.models import CreditBalance

    balance = db.query(CreditBalance).filter(CreditBalance.user_id == test_user.id).first()
    if balance:
        db.delete(balance)
        db.commit()

    response = await client.get("/api/v1/credits/balance", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["balance"] == 0


@pytest.mark.asyncio
async def test_get_transactions_empty(client, test_user, auth_headers):
    response = await client.get("/api/v1/credits/transactions", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["transactions"] == []


@pytest.mark.asyncio
async def test_get_transactions(client, test_user, auth_headers, db):
    from app.db.models import CreditBalance, CreditTransaction, CreditTransactionType

    tx = CreditTransaction(
        user_id=test_user.id,
        amount=100,
        transaction_type=CreditTransactionType.credit,
        reason="Welcome bonus",
        balance_after=100,
    )
    db.add(tx)

    balance = db.query(CreditBalance).filter(CreditBalance.user_id == test_user.id).first()
    balance.balance = 100
    db.commit()

    response = await client.get("/api/v1/credits/transactions", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert len(data["transactions"]) >= 1


@pytest.mark.asyncio
async def test_credits_unauthenticated(client):
    response = await client.get("/api/v1/credits/balance")
    assert response.status_code in [401, 403]
