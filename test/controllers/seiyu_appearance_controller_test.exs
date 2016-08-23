defmodule SeiyuWatch.SeiyuAppearanceControllerTest do
  use SeiyuWatch.ConnCase

  alias SeiyuWatch.SeiyuAppearance
  @valid_attrs %{revision: "some content", wiki_appearances: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, seiyu_appearance_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing seiyu appearances"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, seiyu_appearance_path(conn, :new)
    assert html_response(conn, 200) =~ "New seiyu appearance"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, seiyu_appearance_path(conn, :create), seiyu_appearance: @valid_attrs
    assert redirected_to(conn) == seiyu_appearance_path(conn, :index)
    assert Repo.get_by(SeiyuAppearance, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, seiyu_appearance_path(conn, :create), seiyu_appearance: @invalid_attrs
    assert html_response(conn, 200) =~ "New seiyu appearance"
  end

  test "shows chosen resource", %{conn: conn} do
    seiyu_appearance = Repo.insert! %SeiyuAppearance{}
    conn = get conn, seiyu_appearance_path(conn, :show, seiyu_appearance)
    assert html_response(conn, 200) =~ "Show seiyu appearance"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, seiyu_appearance_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    seiyu_appearance = Repo.insert! %SeiyuAppearance{}
    conn = get conn, seiyu_appearance_path(conn, :edit, seiyu_appearance)
    assert html_response(conn, 200) =~ "Edit seiyu appearance"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    seiyu_appearance = Repo.insert! %SeiyuAppearance{}
    conn = put conn, seiyu_appearance_path(conn, :update, seiyu_appearance), seiyu_appearance: @valid_attrs
    assert redirected_to(conn) == seiyu_appearance_path(conn, :show, seiyu_appearance)
    assert Repo.get_by(SeiyuAppearance, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    seiyu_appearance = Repo.insert! %SeiyuAppearance{}
    conn = put conn, seiyu_appearance_path(conn, :update, seiyu_appearance), seiyu_appearance: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit seiyu appearance"
  end

  test "deletes chosen resource", %{conn: conn} do
    seiyu_appearance = Repo.insert! %SeiyuAppearance{}
    conn = delete conn, seiyu_appearance_path(conn, :delete, seiyu_appearance)
    assert redirected_to(conn) == seiyu_appearance_path(conn, :index)
    refute Repo.get(SeiyuAppearance, seiyu_appearance.id)
  end
end
