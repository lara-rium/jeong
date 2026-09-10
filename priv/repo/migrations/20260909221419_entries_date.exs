defmodule Jeong.Repo.Migrations.EntriesDate do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :date, :date, null: false
    end

    create unique_index(:entries, [:journal_id, :date, :user_id])
    drop index(:entries, [:journal_id])
  end
end
