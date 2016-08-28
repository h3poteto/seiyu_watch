defmodule SeiyuWatch.Repo.Migrations.CreateAppearancesDiff do
  use Ecto.Migration

  def up do
    create table(:appearances_diffs) do
      add :add_html, :mediumtext
      add :sub_html, :mediumtext
      add :current_appearance_id, references(:seiyu_appearances, on_delete: :nothing)
      add :previous_appearance_id, references(:seiyu_appearances, on_delete: :nothing)

      timestamps()
    end
    create index(:appearances_diffs, [:current_appearance_id])
    create index(:appearances_diffs, [:previous_appearance_id])

  end

  def down do
    execute "ALTER TABLE appearances_diffs DROP FOREIGN KEY appearances_diffs_current_appearance_id_fkey"
    execute "ALTER TABLE appearances_diffs DROP FOREIGN KEY appearances_diffs_previous_appearance_id_fkey"
    drop index(:appearances_diffs, [:current_appearance_id])
    drop index(:appearances_diffs, [:previous_appearance_id])
    drop table(:appearances_diffs)
  end
end
