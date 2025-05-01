defmodule Workspacefilter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WorkspacefilterWeb.Telemetry,
      Workspacefilter.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:workspacefilter, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:workspacefilter, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Workspacefilter.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Workspacefilter.Finch},
      # Start a worker by calling: Workspacefilter.Worker.start_link(arg)
      # {Workspacefilter.Worker, arg},
      # Start to serve requests, typically the last entry
      WorkspacefilterWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Workspacefilter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WorkspacefilterWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
