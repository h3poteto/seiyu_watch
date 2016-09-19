defmodule SeiyuWatch.SeiyuController do
  use SeiyuWatch.Web, :controller

  alias SeiyuWatch.Seiyu

  def index(conn, _params) do
    seiyus = Repo.all(Seiyu)
    ln = fn
      (1) -> 1
      (2) -> 2
      (_) -> 3
    end

    length = seiyus |> Enum.count |> ln.()

    seiyus = seiyus |> Enum.chunk(length, length, [])
    render(conn, "index.html", seiyus: seiyus)
  end

  def new(conn, _params) do
    changeset = Seiyu.changeset(%Seiyu{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"seiyu" => seiyu_params}) do
    if String.length(seiyu_params["name"]) > 0 do
      Task.start_link(fn -> SeiyuWatch.SeiyuParser.save(seiyu_params["name"]) end)
      conn
      |> put_flash(:info, "声優登録リクエストを受け付けました")
      |> redirect(to: seiyu_path(conn, :index))
    else
      changeset = Seiyu.changeset(%Seiyu{})
      conn
      |> put_flash(:error, "声優名を入力してください")
      |> render("new.html", changeset: changeset)
    end
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
