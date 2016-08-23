defmodule SeiyuWatch.SeiyuControllerTest do
  use SeiyuWatch.ConnCase

  alias SeiyuWatch.Seiyu
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, seiyu_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing seiyus"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, seiyu_path(conn, :new)
    assert html_response(conn, 200) =~ "New seiyu"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, seiyu_path(conn, :create), seiyu: @valid_attrs
    assert redirected_to(conn) == seiyu_path(conn, :index)
    assert Repo.get_by(Seiyu, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, seiyu_path(conn, :create), seiyu: @invalid_attrs
    assert html_response(conn, 200) =~ "New seiyu"
  end

  test "shows chosen resource", %{conn: conn} do
    seiyu = Repo.insert! %Seiyu{}
    conn = get conn, seiyu_path(conn, :show, seiyu)
    assert html_response(conn, 200) =~ "Show seiyu"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, seiyu_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    seiyu = Repo.insert! %Seiyu{}
    conn = get conn, seiyu_path(conn, :edit, seiyu)
    assert html_response(conn, 200) =~ "Edit seiyu"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    seiyu = Repo.insert! %Seiyu{}
    conn = put conn, seiyu_path(conn, :update, seiyu), seiyu: @valid_attrs
    assert redirected_to(conn) == seiyu_path(conn, :show, seiyu)
    assert Repo.get_by(Seiyu, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    seiyu = Repo.insert! %Seiyu{}
    conn = put conn, seiyu_path(conn, :update, seiyu), seiyu: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit seiyu"
  end

  test "deletes chosen resource", %{conn: conn} do
    seiyu = Repo.insert! %Seiyu{}
    conn = delete conn, seiyu_path(conn, :delete, seiyu)
    assert redirected_to(conn) == seiyu_path(conn, :index)
    refute Repo.get(Seiyu, seiyu.id)
  end
end
