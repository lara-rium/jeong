defmodule JeongWeb.UserController do
  use JeongWeb, :controller

  alias Jeong.Users

  def new(conn, _params) do
    render(conn, :new)
  end

  def new_with_journal(conn, %{token: token}) do
    render(conn, :new_with_journal)
  end

  def create(conn, %{"name" => name, "email" => email} = params) do
    user = Users.register_user(%{name: name, email: email}, params["journal_token"])

    conn
    |> renew_session()
    |> put_session(:user_id, user.id)
    |> redirect(to: ~p"/")
  end

  defp renew_session(conn) do
    Plug.CSRFProtection.delete_csrf_token()

    conn
    |> configure_session(renew: true)
    |> clear_session()
  end
end
