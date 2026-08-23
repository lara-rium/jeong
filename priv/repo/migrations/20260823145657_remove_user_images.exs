defmodule Jeong.Repo.Migrations.RemoveUserImages do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :image, :binary
      remove :image_type, :string
    end
  end
end
