defmodule JeongWeb.AuthController do
  use JeongWeb, :controller

  plug Ueberauth

  alias Jeong.Users
  alias Plug.CSRFProtection

  def callback(%{assigns: %{ueberauth_failure: %Ueberauth.Failure{}}} = conn, _params) do
    conn
    |> put_flash(:error, "couldn't sign you in. please try again.")
    |> redirect(to: ~p"/users/new")
  end

  def callback(%{assigns: %{ueberauth_auth: %Ueberauth.Auth{} = auth}} = conn, params) do
    user =
      Users.get_user_by_email(auth.info.email) ||
        Users.register_user(
          %{name: auth.info.first_name, email: auth.info.email},
          params["journal_token"]
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
end
