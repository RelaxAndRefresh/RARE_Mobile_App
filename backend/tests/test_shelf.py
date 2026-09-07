import pytest


@pytest.mark.asyncio
async def test_get_shelf_items_empty(client, test_user, auth_headers):
    response = await client.get("/api/v1/shelf/items", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["items"] == []


@pytest.mark.asyncio
async def test_get_shelf_items(client, test_user, auth_headers, db):
    from app.db.models import Product, ShelfItem
    from decimal import Decimal

    product = Product(
        name="Test Cleanser",
        brand="TestBrand",
        category="cleanser",
        price_inr=Decimal("299.00"),
        stock_quantity=10,
    )
    db.add(product)
    db.flush()

    shelf_item = ShelfItem(user_id=test_user.id, product_id=product.id)
    db.add(shelf_item)
    db.commit()

    response = await client.get("/api/v1/shelf/items", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert len(data["items"]) >= 1


@pytest.mark.asyncio
async def test_confirm_depletion(client, test_user, auth_headers, db):
    from app.db.models import Product, ShelfItem
    from decimal import Decimal

    product = Product(
        name="Depleting Serum",
        brand="TestBrand",
        category="serum",
        price_inr=Decimal("599.00"),
        stock_quantity=5,
    )
    db.add(product)
    db.flush()

    shelf_item = ShelfItem(user_id=test_user.id, product_id=product.id)
    db.add(shelf_item)
    db.commit()
    db.refresh(shelf_item)

    response = await client.post(
        "/api/v1/shelf/depletion-confirm",
        json={"item_id": shelf_item.id, "is_depleted": True},
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "depleted"


@pytest.mark.asyncio
async def test_confirm_depletion_not_found(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/shelf/depletion-confirm",
        json={"item_id": 99999, "is_depleted": True},
        headers=auth_headers,
    )
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_toggle_auto_swap(client, test_user, auth_headers, db):
    from app.db.models import Product, ShelfItem
    from decimal import Decimal

    product = Product(
        name="Auto Swap Product",
        brand="TestBrand",
        category="moisturizer",
        price_inr=Decimal("399.00"),
        stock_quantity=3,
    )
    db.add(product)
    db.flush()

    shelf_item = ShelfItem(user_id=test_user.id, product_id=product.id)
    db.add(shelf_item)
    db.commit()
    db.refresh(shelf_item)

    response = await client.put(
        "/api/v1/shelf/auto-swap",
        params={"item_id": shelf_item.id, "enabled": True},
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["auto_swap_enabled"] is True


@pytest.mark.asyncio
async def test_toggle_auto_swap_not_found(client, test_user, auth_headers):
    response = await client.put(
        "/api/v1/shelf/auto-swap",
        params={"item_id": 99999, "enabled": True},
        headers=auth_headers,
    )
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_shelf_unauthenticated(client):
    response = await client.get("/api/v1/shelf/items")
    assert response.status_code in [401, 403]
