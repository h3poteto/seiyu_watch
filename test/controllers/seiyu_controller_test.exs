defmodule SeiyuWatchWeb.SeiyuControllerTest do
  use SeiyuWatchWeb.ConnCase

  alias SeiyuWatch.Seiyu
  @valid_attrs %{name: "阿澄佳奈"}
  @invalid_attrs %{}

  def seiyu(),
    do: Repo.insert!(%Seiyu{name: "阿澄佳奈", wiki_page_id: 123_456, wiki_url: "hhtp://example.com"})

  describe "#index" do
    test "lists all entries on index", %{conn: conn} do
      seiyu()
      conn = get(conn, seiyu_path(conn, :index))
      assert html_response(conn, 200) =~ "阿澄佳奈"
    end
  end

  describe "#new" do
    test "renders form for new resources", %{conn: conn} do
      conn = get(conn, seiyu_path(conn, :new))
      assert html_response(conn, 200) =~ "声優追加"
    end
  end

  describe "#create" do
    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = post(conn, seiyu_path(conn, :create), seiyu: @valid_attrs)
      assert redirected_to(conn) == seiyu_path(conn, :index)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, seiyu_path(conn, :create), seiyu: @invalid_attrs)
      assert html_response(conn, 200) =~ "声優追加"
    end

    test "does not create resource and renders errors when name is white space", %{conn: conn} do
      conn = post(conn, seiyu_path(conn, :create), seiyu: %{name: " "})
      assert html_response(conn, 200) =~ "声優追加"
    end
  end

  describe "#show" do
    test "shows chosen resource", %{conn: conn} do
      seiyu = seiyu()
      conn = get(conn, seiyu_path(conn, :show, seiyu))
      assert html_response(conn, 200) =~ seiyu.name
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent(404, fn ->
        get(conn, seiyu_path(conn, :show, -1))
      end)
    end
  end
end
