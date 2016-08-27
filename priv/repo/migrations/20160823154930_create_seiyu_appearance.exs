defmodule SeiyuWatch.Repo.Migrations.CreateSeiyuAppearance do
  use Ecto.Migration

  def up do
    create table(:seiyu_appearances) do
      add :wiki_appearances, :mediumtext
      add :revision, :string
      add :revision_id, :integer
      add :seiyu_id, references(:seiyus, on_delete: :nothing)

      timestamps()
    end
    create index(:seiyu_appearances, [:seiyu_id])

  end

  def down do
    execute "ALTER TABLE seiyu_appearances DROP FOREIGN KEY seiyu_appearances_seiyu_id_fkey"

    drop index(:seiyu_appearances, [:seiyu_id])
    drop table(:seiyu_appearances)
  end

end
