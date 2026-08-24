defmodule Jeong.Users.User do
  use Ecto.Schema

  alias Jeong.Users.Journal

  schema "users" do
    field :name, :string
    field :email, :string

    belongs_to :journal, Journal

    timestamps(type: :utc_datetime)
  end
end
