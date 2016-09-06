defmodule SeiyuWatch.SeiyuAppearanceController do
  use SeiyuWatch.Web, :controller

  alias SeiyuWatch.SeiyuAppearance

  def index(conn, _params) do
    seiyu_appearances = Repo.all(SeiyuAppearance)
    render(conn, "index.html", seiyu_appearances: seiyu_appearances)
  end
end
