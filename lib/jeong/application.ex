defmodule Jeong.Application do
  use Application

  alias JeongWeb.Endpoint

  @impl Application
  def start(_type, _args) do
    children = [
      JeongWeb.Telemetry,
      Jeong.Repo,
      {DNSCluster, query: Application.get_env(:jeong, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Jeong.PubSub},
      {Tz.UpdatePeriodically, []},
      JeongWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Jeong.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl Application
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
