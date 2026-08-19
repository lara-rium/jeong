defmodule Jeong.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      JeongWeb.Telemetry,
      Jeong.Repo,
      {DNSCluster, query: Application.get_env(:jeong, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Jeong.PubSub},
      JeongWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Jeong.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    JeongWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
