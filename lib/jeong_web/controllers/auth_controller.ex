defmodule JeongWeb.AuthController do
  use JeongWeb, :controller

  plug Ueberauth

  alias JeongWeb.UserController

  def callback(%{assigns: %{ueberauth_failure: %Ueberauth.Failure{}}} = conn, _params) do
    conn
    |> put_flash(:error, "couldn't sign you in. please try again.")
    |> redirect(to: ~p"/users/new")
  end

  def callback(%{assigns: %{ueberauth_auth: %Ueberauth.Auth{} = auth}} = conn, _params) do
    UserController.create(conn, %{
      "name" => auth.info.first_name,
      "email" => auth.info.email
    })
  end
end
