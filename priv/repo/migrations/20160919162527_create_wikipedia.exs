defmodule SeiyuWatch.Repo.Migrations.CreateWikipedia do
  use Ecto.Migration

  def up do
    create table(:wikipedias) do
      add :content, :mediumtext
      add :seiyu_id, references(:seiyus, on_delete: :nothing)

      timestamps()
    end
    create unique_index(:wikipedias, [:seiyu_id])
  end

  def down do
    execute "ALTER TABLE wikipedias DROP FOREIGN KEY wikipedias_seiyu_id_fkey"

    drop unique_index(:wikipedias, [:seiyu_id])
    drop table(:wikipedias)
  end
end
