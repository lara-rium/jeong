defmodule JeongWeb.AuthController do
  use JeongWeb, :controller

  plug :save_token when action == :request
  plug Ueberauth

  alias Jeong.Users
  alias Plug.CSRFProtection

  def callback(%{assigns: %{ueberauth_failure: %Ueberauth.Failure{}}} = conn, _params) do
    conn
    |> put_flash(:error, gettext("couldn't sign you in, please try again"))
    |> redirect(to: ~p"/users/new")
  end

  def callback(%{assigns: %{ueberauth_auth: %Ueberauth.Auth{} = auth}} = conn, _params) do
    user =
      Users.get_user_by_email(auth.info.email) ||
        Users.register_user(
          auth.info.first_name,
          auth.info.email,
          get_session(conn, :token)
        )

    conn
    |> renew_session()
    |> put_session(:user_id, user.id)
    |> redirect(to: ~p"/")
  end

  defp renew_session(conn) do
    CSRFProtection.delete_csrf_token()

    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  defp save_token(conn, _options) do
    put_session(conn, :token, conn.params["token"])
  end
end
