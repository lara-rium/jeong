defmodule Jeong.Users.Journal do
  use Ecto.Schema

  alias Jeong.Users.User

  schema "journals" do
    field :token, :string

    has_many :users, User

    timestamps(type: :utc_datetime)
  end
end
