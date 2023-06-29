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
      {Plug.Cowboy, scheme: :http, plug: Plugweb.Router, options: [port: cowboy_port()]}
    ]

    opts = [strategy: :one_for_one, name: Plugweb.Supervisor]

    Logger.info("Starting application and listen 127.0.0.1:#{cowboy_port()}...")

    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.get_env(:example, :cowboy_port, 8000)
end
