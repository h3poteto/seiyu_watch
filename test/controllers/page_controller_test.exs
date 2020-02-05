defmodule SeiyuWatchWeb.PageControllerTest do
  use SeiyuWatchWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "SeiyuWatch"
  end
end
