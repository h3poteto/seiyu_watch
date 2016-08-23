defmodule SeiyuWatch.SeiyuAppearanceController do
  use SeiyuWatch.Web, :controller

  alias SeiyuWatch.SeiyuAppearance

  def index(conn, _params) do
    seiyu_appearances = Repo.all(SeiyuAppearance)
    render(conn, "index.html", seiyu_appearances: seiyu_appearances)
  end

  def new(conn, _params) do
    changeset = SeiyuAppearance.changeset(%SeiyuAppearance{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"seiyu_appearance" => seiyu_appearance_params}) do
    changeset = SeiyuAppearance.changeset(%SeiyuAppearance{}, seiyu_appearance_params)

    case Repo.insert(changeset) do
      {:ok, _seiyu_appearance} ->
        conn
        |> put_flash(:info, "Seiyu appearance created successfully.")
        |> redirect(to: seiyu_appearance_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    seiyu_appearance = Repo.get!(SeiyuAppearance, id)
    render(conn, "show.html", seiyu_appearance: seiyu_appearance)
  end

  def edit(conn, %{"id" => id}) do
    seiyu_appearance = Repo.get!(SeiyuAppearance, id)
    changeset = SeiyuAppearance.changeset(seiyu_appearance)
    render(conn, "edit.html", seiyu_appearance: seiyu_appearance, changeset: changeset)
  end

  def update(conn, %{"id" => id, "seiyu_appearance" => seiyu_appearance_params}) do
    seiyu_appearance = Repo.get!(SeiyuAppearance, id)
    changeset = SeiyuAppearance.changeset(seiyu_appearance, seiyu_appearance_params)

    case Repo.update(changeset) do
      {:ok, seiyu_appearance} ->
        conn
        |> put_flash(:info, "Seiyu appearance updated successfully.")
        |> redirect(to: seiyu_appearance_path(conn, :show, seiyu_appearance))
      {:error, changeset} ->
        render(conn, "edit.html", seiyu_appearance: seiyu_appearance, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    seiyu_appearance = Repo.get!(SeiyuAppearance, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(seiyu_appearance)

    conn
    |> put_flash(:info, "Seiyu appearance deleted successfully.")
    |> redirect(to: seiyu_appearance_path(conn, :index))
  end
end
