defmodule SeiyuWatch.PageController do
  use SeiyuWatch.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
