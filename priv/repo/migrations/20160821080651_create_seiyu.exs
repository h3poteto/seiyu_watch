defmodule SeiyuWatch.Repo.Migrations.CreateSeiyu do
  use Ecto.Migration

  def change do
    create table(:seiyus) do
      add :name, :string
      add :appearances_updated_at, :datetime

      timestamps()
    end

    create unique_index(:seiyus, [:name])
  end
end
