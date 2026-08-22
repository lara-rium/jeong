defmodule Jeong.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :image, :binary
      add :image_type, :string

      timestamps(type: :utc_datetime)
    end
  end
end
