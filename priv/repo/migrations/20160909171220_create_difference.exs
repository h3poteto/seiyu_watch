defmodule SeiyuWatch.Repo.Migrations.CreateDifference do
  use Ecto.Migration

  def up do
    create table(:differences) do
      add(:wiki_diff, :text)
      add(:from, :bigint)
      add(:to, :bigint)
      add(:seiyu_id, references(:seiyus, on_delete: :nothing))

      timestamps(type: :utc_datetime)
    end

    create(index(:differences, [:seiyu_id]))
    create(unique_index(:differences, [:to, :from]))
  end

  def down do
    execute("ALTER TABLE differences DROP FOREIGN KEY differences_seiyu_id_fkey")

    drop(index(:differences, [:seiyu_id]))
    drop(unique_index(:differences, [:to, :from]))
    drop(table(:differences))
  end
end
