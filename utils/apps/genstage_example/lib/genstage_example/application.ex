defmodule GenstageExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Starts a worker by calling: GenstageExample.Worker.start_link(arg)
      # {GenstageExample.Worker, arg}
      {GenStageExample.Producer, 0},
      {GenStageExample.ProducerConsumer, []},
      %{id: 1, start: {GenStageExample.Consumer, :start_link, [[]]}},
      %{id: 2, start: {GenStageExample.Consumer, :start_link, [[]]}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GenStageExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
