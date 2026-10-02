defmodule JeongWeb.Navigation do
  use JeongWeb, :verified_routes

  import Phoenix.Component, only: [assign: 3]

  import Phoenix.LiveView,
    only: [attach_hook: 4, connected?: 1, redirect: 2, get_connect_params: 1]

  alias Jeong.Entries
  alias Jeong.Users

  def on_mount(:default, _params, session, socket) do
    user_id = session["user_id"]
    user = user_id && Users.get_user(user_id)

    {:cont,
     socket
     |> assign(:current_user, user)
     |> assign(:entry_target, entry_target(socket))
     |> assign(:connected?, connected?(socket))
     |> attach_hook(:canonical_path, :handle_params, &redirect_to_index/3)}
  end

  def destination(%{current_user: nil}), do: ~p"/users/new"

  def destination(%{current_user: user, entry_target: %{date: date}}) do
    entry = Entries.get_entry(user.journal_id, user.id, date)

    if entry do
      ~p"/journals/#{user.journal_id}/entries/#{Date.to_iso8601(date)}"
    else
      ~p"/entries/new"
    end
  end

  defp redirect_to_index(_params, uri, socket) do
    if !connected?(socket) || URI.parse(uri).path in [~p"/", destination(socket.assigns)] do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: ~p"/")}
    end
  end

  defp entry_target(socket) do
    time_zone = get_connect_params(socket)["time_zone"]

    if time_zone do
      now = DateTime.now!(time_zone)
      today = DateTime.to_date(now)

      cond do
        now.hour in 0..5 -> %{date: Date.add(today, -1), is_today: true}
        now.hour in 6..21 -> %{date: Date.add(today, -1), is_today: false}
        now.hour in 22..23 -> %{date: today, is_today: true}
      end
    end
  end
end
