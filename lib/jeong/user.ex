defmodule Jeong.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :image, :binary, load_in_query: false
    field :image_type, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :image, :image_type])
    |> validate_required([:name, :email, :image, :image_type])
  end
end
