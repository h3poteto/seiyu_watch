defmodule SeiyuWatch.TaskCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias SeiyuWatch.Repo

      import SeiyuWatch.TestHelpers
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(SeiyuWatch.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(SeiyuWatch.Repo, {:shared, self()})
    end

    :ok
  end

  def errors_on(struct, data) do
    struct.__struct__.changeset(struct, data)
    |> Ecto.Changeset.traverse_errors(&SeiyuWatch.ErrorHelpers.translate_error/1)
    |> Enum.flat_map(fn {key, errors} -> for msg <- errors, do: {key, msg} end)
  end
end
