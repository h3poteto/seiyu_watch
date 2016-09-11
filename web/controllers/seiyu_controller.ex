defmodule SeiyuWatch.SeiyuController do
  use SeiyuWatch.Web, :controller

  alias SeiyuWatch.Seiyu

  def index(conn, _params) do
    seiyus = Repo.all(Seiyu)
    render(conn, "index.html", seiyus: seiyus)
  end

  def new(conn, _params) do
    changeset = Seiyu.changeset(%Seiyu{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"seiyu" => seiyu_params}) do
    Task.start_link(fn -> SeiyuWatch.SeiyuParser.save(seiyu_params["name"]) end)
    conn
    |> put_flash(:info, "声優登録リクエストを受け付けました")
    |> redirect(to: seiyu_path(conn, :index))
  end

  def show(conn, %{"id" => id}) do
    seiyu = Repo.get!(Seiyu, id)
    diff = seiyu |> Seiyu.recent_diff
    render(conn, "show.html", seiyu: seiyu, diff: diff)
  end

  def delete(conn, %{"id" => id}) do
    seiyu = Repo.get!(Seiyu, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(seiyu)

    conn
    |> put_flash(:info, "Seiyu deleted successfully.")
    |> redirect(to: seiyu_path(conn, :index))
  end
end
