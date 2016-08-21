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
    changeset = Seiyu.changeset(%Seiyu{}, seiyu_params)

    case Repo.insert(changeset) do
      {:ok, _seiyu} ->
        conn
        |> put_flash(:info, "Seiyu created successfully.")
        |> redirect(to: seiyu_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    seiyu = Repo.get!(Seiyu, id)
    render(conn, "show.html", seiyu: seiyu)
  end

  def edit(conn, %{"id" => id}) do
    seiyu = Repo.get!(Seiyu, id)
    changeset = Seiyu.changeset(seiyu)
    render(conn, "edit.html", seiyu: seiyu, changeset: changeset)
  end

  def update(conn, %{"id" => id, "seiyu" => seiyu_params}) do
    seiyu = Repo.get!(Seiyu, id)
    changeset = Seiyu.changeset(seiyu, seiyu_params)

    case Repo.update(changeset) do
      {:ok, seiyu} ->
        conn
        |> put_flash(:info, "Seiyu updated successfully.")
        |> redirect(to: seiyu_path(conn, :show, seiyu))
      {:error, changeset} ->
        render(conn, "edit.html", seiyu: seiyu, changeset: changeset)
    end
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
