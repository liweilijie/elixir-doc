defmodule Stack do
  @moduledoc """
  Use the test cast for this code:
    iex -S mix
    c "lib/gen_server_example.ex"
    children = [{Stack, "hello,go,rust"}]
    Supervisor.start_link(children, strategy: :one_for_all)
    Stack.pop()
    Stack.pop()
    Stack.push("dada")
  """

  @server_name :stack_server

  use GenServer

  # Client

  def start_link(default) when is_binary(default) do
    GenServer.start_link(__MODULE__, default, name: @server_name)
  end

  def push(element) do
    GenServer.cast(@server_name, {:push, element})
  end

  def pop() do
    GenServer.call(@server_name, :pop)
  end

  # Server (callbacks)

  @impl true
  def init(elements) do
    initial_state = String.split(elements, ",", trim: true)
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:pop, _from, state) do
    [to_caller | new_state] = state
    {:reply, to_caller, new_state}
  end

  @imple true
  def handle_cast({:push, element}, state) do
    new_state = [element | state]
    {:noreply, new_state}
  end
end
