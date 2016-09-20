defmodule SeiyuWatch.Repo.Migrations.CreateSeiyuDiff do
  use Ecto.Migration

  def up do
    create table(:seiyu_diffs) do
      add :wiki_diff, :mediumtext
      add :revision_hash, :string
      add :revision_id, :integer
      add :from, :integer
      add :to, :integer
      add :seiyu_id, references(:seiyus, on_delete: :nothing)

      timestamps()
    end
    create index(:seiyu_diffs, [:seiyu_id])
    create unique_index(:seiyu_diffs, [:to, :from])

  end

  def down do
    execute "ALTER TABLE seiyu_diffs DROP FOREIGN KEY seiyu_diffs_seiyu_id_fkey"

    drop index(:seiyu_diffs, [:seiyu_id])
    drop unique_index(:seiyu_diffs, [:to, :from])
    drop table(:seiyu_diffs)
  end
end
