defmodule Jeong.Repo.Migrations.UserNotNull do
  use Ecto.Migration

  def change do
    modify :email, :string, null: false, from: {:string, null: true}
    modify :name, :string, null: false, from: {:string, null: true}
  end
end
