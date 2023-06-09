defmodule Plugweb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      # {Plug.Cowboy, scheme: :http, plug: Plugweb.HelloWorldPlug, options: [port: 8080]}
      {Plug.Cowboy, scheme: :http, plug: Plugweb.Router, options: [port: 8080]}
    ]

    opts = [strategy: :one_for_one, name: Plugweb.Supervisor]

    Logger.info("Starting application...")

    Supervisor.start_link(children, opts)
  end
end
