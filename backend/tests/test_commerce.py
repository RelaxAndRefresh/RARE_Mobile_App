import pytest
from decimal import Decimal


@pytest.fixture
def sample_product(db):
    from app.db.models import Product

    product = Product(
        name="Vitamin C Serum",
        brand="GlowLab",
        description="Brightening serum with 15% Vitamin C",
        category="serum",
        price_inr=Decimal("899.00"),
        image_url="https://example.com/vitamin-c.jpg",
        stock_quantity=50,
        is_active=True,
    )
    db.add(product)
    db.commit()
    db.refresh(product)
    return product


@pytest.mark.asyncio
async def test_get_products_empty(client, test_user, auth_headers):
    response = await client.get("/api/v1/products/", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["total"] == 0


@pytest.mark.asyncio
async def test_get_products_with_data(client, test_user, auth_headers, sample_product):
    response = await client.get("/api/v1/products/", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["total"] >= 1


@pytest.mark.asyncio
async def test_get_products_by_category(client, test_user, auth_headers, sample_product):
    response = await client.get(
        "/api/v1/products/",
        params={"category": "serum"},
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["total"] >= 1


@pytest.mark.asyncio
async def test_get_product_by_id(client, test_user, auth_headers, sample_product):
    response = await client.get(
        f"/api/v1/products/{sample_product.id}",
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "Vitamin C Serum"
    assert data["brand"] == "GlowLab"


@pytest.mark.asyncio
async def test_get_product_not_found(client, test_user, auth_headers):
    response = await client.get("/api/v1/products/99999", headers=auth_headers)
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_get_cart_empty(client, test_user, auth_headers):
    response = await client.get("/api/v1/commerce/cart", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert "cart" in data


@pytest.mark.asyncio
async def test_add_to_cart(client, test_user, auth_headers, sample_product):
    response = await client.post(
        "/api/v1/commerce/cart/items",
        json={"product_id": sample_product.id, "quantity": 2},
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert "cart" in data


@pytest.mark.asyncio
async def test_add_to_cart_product_not_found(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/commerce/cart/items",
        json={"product_id": 99999, "quantity": 1},
        headers=auth_headers,
    )
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_add_to_cart_insufficient_stock(client, test_user, auth_headers, db):
    from app.db.models import Product

    product = Product(
        name="Low Stock Item",
        brand="TestBrand",
        category="test",
        price_inr=Decimal("100.00"),
        stock_quantity=1,
        is_active=True,
    )
    db.add(product)
    db.commit()
    db.refresh(product)

    response = await client.post(
        "/api/v1/commerce/cart/items",
        json={"product_id": product.id, "quantity": 5},
        headers=auth_headers,
    )
    assert response.status_code == 200


@pytest.mark.asyncio
async def test_checkout_empty_cart(client, test_user, auth_headers):
    response = await client.post(
        "/api/v1/commerce/checkout",
        json={
            "shipping_address": {
                "street": "123 Test St",
                "city": "Mumbai",
                "state": "Maharashtra",
                "pincode": "400001",
            }
        },
        headers=auth_headers,
    )
    assert response.status_code == 422


@pytest.mark.asyncio
async def test_checkout_with_items(client, test_user, auth_headers, sample_product):
    await client.post(
        "/api/v1/commerce/cart/items",
        json={"product_id": sample_product.id, "quantity": 1},
        headers=auth_headers,
    )

    response = await client.post(
        "/api/v1/commerce/checkout",
        json={
            "shipping_address": {
                "street": "123 Test St",
                "city": "Mumbai",
                "state": "Maharashtra",
                "pincode": "400001",
            }
        },
        headers=auth_headers,
    )
    assert response.status_code == 200
    data = response.json()
    assert "order" in data


@pytest.mark.asyncio
async def test_remove_from_cart(client, test_user, auth_headers, sample_product, db):
    from app.db.models import Cart, CartItem

    add_resp = await client.post(
        "/api/v1/commerce/cart/items",
        json={"product_id": sample_product.id, "quantity": 1},
        headers=auth_headers,
    )
    assert add_resp.status_code == 200

    cart = db.query(Cart).filter(Cart.user_id == test_user.id).first()
    assert cart is not None
    cart_items = db.query(CartItem).filter(CartItem.cart_id == cart.id).all()
    assert len(cart_items) > 0
    item_id = cart_items[0].id

    response = await client.delete(
        f"/api/v1/commerce/cart/items/{item_id}",
        headers=auth_headers,
    )
    assert response.status_code == 200


@pytest.mark.asyncio
async def test_commerce_unauthenticated(client):
    response = await client.get("/api/v1/products/")
    assert response.status_code in [401, 403]
