defmodule Jeong.Users do
  alias Jeong.Repo
  alias Jeong.Users.Journal
  alias Jeong.Users.User

  def register_user(attrs, token \\ nil) do
    {:ok, user} =
      Repo.transact(fn ->
        journal = get_or_create_journal(token)

        {:ok,
         Repo.insert!(
           %User{
             name: attrs.name || attrs.email,
             email: attrs.email,
             journal_id: journal.id
           },
           on_conflict: {:replace, [:name, :updated_at, :journal_id]},
           conflict_target: :email
         )}
      end)

    user
  end

  defp get_or_create_journal(nil) do
    Repo.insert!(%Journal{
      token: Base.url_encode64(:crypto.strong_rand_bytes(16), padding: false)
    })
  end

  defp get_or_create_journal(token), do: Repo.get_by!(Journal, token: token)

  def get_user!(id), do: Repo.get!(User, id)

  def get_journal!(id),
    do:
      Journal
      |> Repo.get!(id)
      |> Repo.preload(:users)
end
