defmodule PseudoServerA do
  use GenServer

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def handle_call(:display, _from, []) do
    {:reply, 'ServerA PID: ' ++ :erlang.pid_to_list(self()), []}
  end

  def handle_cast(:err, []) do
    {:stop, "stop ServerA", []}
  end
end

defmodule PseudoServerB do
  use GenServer

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def handle_call(:display, _from, []) do
    {:reply, 'ServerB PID: ' ++ :erlang.pid_to_list(self()), []}
  end

  def handle_cast(:err, []) do
    {:stop, "stop ServerB", []}
  end
end

defmodule PseudoServerC do
  use GenServer

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def handle_call(:display, _from, []) do
    {:reply, 'ServerC PID: ' ++ :erlang.pid_to_list(self()), []}
  end

  def handle_cast(:err, []) do
    {:stop, "stop ServerC", []}
  end
end

defmodule SupervisorTest do
  import Supervisor.Spec

  def init() do
    children = [
      worker(PseudoServerA, [[], [name: :server_a]]),
      worker(PseudoServerB, [[], [name: :server_b]]),
      worker(PseudoServerC, [[], [name: :server_c]])
    ]

    # Start the supervisor with children
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
