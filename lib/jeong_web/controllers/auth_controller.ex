defmodule JeongWeb.AuthController do
  use JeongWeb, :controller

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: %Ueberauth.Failure{}}} = conn, _params) do
    conn
    |> put_flash(:error, "oops... something went wrong.")
    |> redirect(to: ~p"/")
  end

  def callback(%{assigns: %{ueberauth_auth: %Ueberauth.Auth{} = auth}} = conn, _params) do
    # user = MyApp.Accounts.create_user_from_ueberauth!(auth)

    dbg(auth)

    conn
    |> renew_session()
    |> put_session(:user_id, 1234)
    |> redirect(to: ~p"/")
  end

  defp renew_session(conn) do
    Plug.CSRFProtection.delete_csrf_token()

    conn
    |> configure_session(renew: true)
    |> clear_session()
  end
end
