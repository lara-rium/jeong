defmodule Jeong.Entry do
  use Ecto.Schema

  import Ecto.Changeset

  alias Jeong.Users.Journal
  alias Jeong.Users.User

  schema "entries" do
    field :text, :string
    field :media, {:array, :binary}, load_in_query: false

    belongs_to :journal, Journal
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  def changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
