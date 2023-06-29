defmodule WebhookProcessor.Application do
  @moduledoc """
  OTP Applicaton specification for WebhookProcessor
  """

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: WebhookProcessor.Worker.start_link(arg)
      # {WebhookProcessor.Worker, arg}
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: WebhookProcessor.Endpoint,
        # options: [port: Application.get_env(:webhook_processor, :port)]
        options: [port: 4000]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WebhookProcessor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
