defmodule Jeong.Entries do
  import Ecto.Query

  alias Ecto.Changeset
  alias Jeong.Entry
  alias Jeong.Repo

  def create_entry(user, params, media, date) do
    params
    |> Entry.changeset()
    |> Changeset.change(media: media, user_id: user.id, journal_id: user.journal_id, date: date)
    |> Repo.insert!()
  end

  def get_entries(journal_id, date) do
    Entry
    |> where(journal_id: ^journal_id, date: ^date)
    |> Repo.all()
  end
end
