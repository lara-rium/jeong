defmodule JeongWeb.UserController do
  use JeongWeb, :controller

  alias Jeong.Repo
  alias Jeong.User

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"name" => name, "email" => email}) do
    user =
      %User{name: name || email, email: email}
      |> Repo.insert!(on_conflict: {:replace, [:name, :updated_at]}, conflict_target: :email)

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
