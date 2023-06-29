defmodule Menu.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MenuWeb.Telemetry,
      # Start the Ecto repository
      Menu.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Menu.PubSub},
      # Start Finch
      {Finch, name: Menu.Finch},
      # Start the Endpoint (http/https)
      MenuWeb.Endpoint
      # Start a worker by calling: Menu.Worker.start_link(arg)
      # {Menu.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Menu.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MenuWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
