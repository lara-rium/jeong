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
    time_zone = get_connect_params(socket)["time_zone"]

    {:cont,
     socket
     |> assign(:current_user, user)
     |> assign(:time_zone, time_zone)
     |> attach_hook(:canonical_path, :handle_params, &redirect_to_index/3)}
  end

  def destination(%{current_user: nil}), do: ~p"/users/new"

  def destination(%{current_user: user, time_zone: time_zone}) do
    now = DateTime.now!(time_zone)

    yesterday =
      now
      |> DateTime.shift(day: -1)
      |> DateTime.to_date()

    entries = Entries.get_entries(user.journal_id, dbg(yesterday))

    if Enum.any?(entries, &(&1.user_id == user.id)) do
      ~p"/journals/#{user.journal_id}/days/#{DateTime.to_date(now) |> Date.to_iso8601()}"
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
end
