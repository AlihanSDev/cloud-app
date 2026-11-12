from app import app


def test_index_status_code():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200


def test_index_contains_required_text():
    client = app.test_client()
    response = client.get("/")
    text = response.get_data(as_text=True)
    assert "Cloud Technologies Laboratory" in text


def test_about_and_contact_pages():
    client = app.test_client()
    assert client.get("/about").status_code == 200
    assert client.get("/contact").status_code == 200
