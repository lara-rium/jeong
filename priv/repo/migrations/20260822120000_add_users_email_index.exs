defmodule Jeong.Repo.Migrations.AddUsersEmailIndex do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:email])
  end
end
