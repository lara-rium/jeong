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

  def get_entry(journal_id, user_id, date) do
    Entry
    |> where(journal_id: ^journal_id, user_id: ^user_id, date: ^date)
    |> Repo.one()
  end

  def get_entries(journal_id, date) do
    daily_seed = to_string(date)

    entries =
      Entry
      |> where(journal_id: ^journal_id)
      |> select_merge([entry], %{media: entry.media})
      |> preload(:user)

    requested =
      entries
      |> where(date: ^date)
      |> Repo.all()

    random_date =
      Entry
      |> where([entry], entry.journal_id == ^journal_id and entry.date != ^date)
      |> select([entry], entry.date)
      |> group_by([entry], entry.date)
      |> order_by([entry], fragment("md5(?::text || ?::text)", entry.date, ^daily_seed))
      |> limit(1)

    random =
      entries
      |> where([entry], entry.date in subquery(random_date))
      |> Repo.all()

    %{requested: requested, random: random}
  end
end
