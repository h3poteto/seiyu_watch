defmodule SeiyuWatch.SeiyuController do
  use SeiyuWatch.Web, :controller

  alias SeiyuWatch.Seiyu

  def index(conn, _params) do
    seiyus = Seiyu
    |> order_by(desc: :diffs_updated_at)
    |> Repo.all
    |> Repo.preload(:wikipedia)
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
    render_error = fn(conn) ->
      changeset = Seiyu.changeset(%Seiyu{})
      conn
      |> put_flash(:error, "声優名を入力してください")
      |> render("new.html", changeset: changeset)
    end
    case seiyu_params |> Map.fetch("name") do
      {:ok, name} ->
        if name |> String.strip |> String.length > 0 do
          Task.start_link(fn -> SeiyuWatch.SeiyuParser.save(name) end)
          conn
          |> put_flash(:info, "声優登録リクエストを受け付けました")
          |> redirect(to: seiyu_path(conn, :index))
        else
          render_error.(conn)
        end
      :error ->
        render_error.(conn)
    end
  end

  def show(conn, %{"id" => id}) do
    seiyu = Repo.get!(Seiyu, id)
    diff = seiyu |> Seiyu.recent_diff
    wiki_head = (seiyu |> Repo.preload(:wikipedia)).wikipedia
    |> SeiyuWatch.Wikipedia.head
    render(conn, "show.html", seiyu: seiyu, diff: diff, wiki_head: wiki_head)
  end
end
