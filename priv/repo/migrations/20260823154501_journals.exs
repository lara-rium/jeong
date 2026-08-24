defmodule Jeong.Repo.Migrations.Journals do
  use Ecto.Migration

  def change do
    create table(:journals) do
      add :token, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:journals, [:token])

    alter table(:users) do
      add :journal_id, references(:journals, on_delete: :nilify_all)
    end

    create index(:users, [:journal_id])
  end
end
