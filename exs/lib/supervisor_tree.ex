defmodule PSrvA do
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

defmodule PSrvB do
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

defmodule PSrvC do
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

defmodule SupervisorBranch do
  import Supervisor.Spec

  def start_link(state) do
    children = [
      worker(PSrvA, [[], [name: :server_a]]),
      worker(PSrvB, [[], [name: :server_b]])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

defmodule SupervisorRoot do
  import Supervisor.Spec

  def init() do
    children = [
      supervisor(SupervisorBranch, [[name: :supervisor_branch]]),
      worker(PSrvC, [[], [name: :server_c]])
    ]

    # Start the supervisor with children
    Supervisor.start_link(children, strategy: :one_for_all)
  end
end
