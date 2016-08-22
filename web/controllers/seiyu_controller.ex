defmodule SeiyuWatch.SeiyuController do
  use SeiyuWatch.Web, :controller
  use SeiyuWatch.SeiyuParser

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
    case SeiyuWatch.SeiyuParser.save(seiyu_params["name"]) do
      {:ok, _seiyu} ->
        conn
        |> put_flash(:info, "Seiyu created successfully.")
        |> redirect(to: seiyu_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
      {:failed, _name} ->
        render(conn, "new.html")
    end
  end

  def show(conn, %{"id" => id}) do
    seiyu = Repo.get!(Seiyu, id)
    render(conn, "show.html", seiyu: seiyu)
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
