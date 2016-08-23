defmodule SeiyuWatch.Repo.Migrations.CreateSeiyu do
  use Ecto.Migration

  def change do
    create table(:seiyus) do
      add :name, :string
      add :wiki_url, :text

      timestamps()
    end

    create unique_index(:seiyus, [:name])
  end
end
