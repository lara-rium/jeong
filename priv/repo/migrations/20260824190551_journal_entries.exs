defmodule Jeong.Repo.Migrations.JournalEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :text, :text, null: false
      add :media, {:array, :binary}, default: []

      add :journal_id, references(:journals, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create index(:entries, [:journal_id])
  end
end
