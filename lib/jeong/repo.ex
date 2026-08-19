defmodule Jeong.Repo do
  use Ecto.Repo,
    otp_app: :jeong,
    adapter: Ecto.Adapters.Postgres
end
