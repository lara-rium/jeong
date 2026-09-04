defmodule Jeong.Entries do
  import Ecto.Query

  alias Ecto.Changeset
  alias Jeong.Entry
  alias Jeong.Repo

  def create_entry(user, params, media) do
    params
    |> Entry.changeset()
    |> Changeset.change(media: media, user_id: user.id, journal_id: user.journal_id)
    |> Repo.insert!()
  end

  def get_entries(journal_id) do
    Entry
    |> where(journal_id: ^journal_id)
    |> order_by(desc: :id)
    |> Repo.all()
  end
end
