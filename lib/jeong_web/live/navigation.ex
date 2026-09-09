defmodule JeongWeb.Navigation do
  use JeongWeb, :verified_routes

  import Phoenix.Component, only: [assign: 3]
  import Phoenix.LiveView, only: [attach_hook: 4, redirect: 2]

  alias Jeong.Users

  def on_mount(:default, _params, session, socket) do
    user_id = session["user_id"]
    user = user_id && Users.get_user(user_id)

    {:cont,
     socket
     |> assign(:current_user, user)
     |> attach_hook(:canonical_path, :handle_params, &redirect_to_index/3)}
  end

  def destination(nil), do: ~p"/users/new"
  def destination(_user), do: ~p"/entries/new"

  defp redirect_to_index(_params, uri, socket) do
    if URI.parse(uri).path in [~p"/", destination(socket.assigns.current_user)] do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: ~p"/")}
    end
  end
end
