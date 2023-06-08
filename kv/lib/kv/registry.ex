defmodule KV.Registry do
  use GenServer

  ## Client API

  @doc """
  Starts the registry with the given `name`.
  """
  def start_link(table, event_manager, buckets, opts \\ []) do
    # GenServer.start_link(__MODULE__, :ok, name: name)
    # 1. We now expect the tables as argument and pass it to the server
    GenServer.start_link(__MODULE__, {table, event_manager, buckets}, opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `table`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(table, name) do
    # GenServer.call(server, {:lookup, name})
    # 2. lookup now expects a table and looks directly into ETS.
    #    No request is sent to the server.
    case :ets.lookup(table, name) do
      [{^name, bucket}] -> {:ok, bucket}
      [] -> :error
    end
  end

  @doc """
  Ensures there is a bucket associated to the given `name` in `server`.
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  @doc """
  Stops the registry.
  """
  def stop(server) do
    GenServer.stop(server)
  end

  ## Server Callbacks

  def init({table, events, buckets}) do
    # 3. We have replaced the names HashDict by the ETS table
    refs =
      :ets.foldl(
        fn {name, pid}, acc -> Map.put(acc, Process.monitor(pid), name) end,
        Map.new(),
        table
      )

    {:ok, %{names: table, refs: refs, events: events, buckets: buckets}}
  end

  # 4. The previous handle_call callback for lookup was removed
  # def handle_call({:lookup, name}, _from, {names, _} = state) do
  #   {:reply, Map.fetch(names, name), state}
  # end

  def handle_call({:create, name}, _from, state) do
    # 5. Read and write to the ETS table instead of the Map
    case lookup(state.names, name) do
      {:ok, pid} ->
        # Reply with pid
        {:reply, pid, state}

      :error ->
        # {:ok, pid} = KV.Bucket.Supervisor.start_bucket(state.buckets)
        {:ok, pid} = KV.Bucket.Supervisor.start_bucket()
        ref = Process.monitor(pid)
        refs = Map.put(state.refs, ref, name)
        :ets.insert(state.names, {name, pid})
        GenEvent.sync_notify(state.events, {:create, name, pid})
        # Reply with pid
        {:reply, pid, %{state | refs: refs}}
    end

    # if Map.has_key?(names, name) do
    #   {:noreply, {names, refs}}
    # else
    #   # {:ok, pid} = KV.Bucket.start_link()
    #   {:ok, pid} = KV.Bucket.Supervisor.start_bucket()
    #   ref = Process.monitor(pid)
    #   refs = Map.put(refs, ref, name)
    #   names = Map.put(names, name, pid)
    #   {:noreply, {names, refs}}
    # end
  end

  def handle_info({:DOWN, ref, :process, pid, _reason}, state) do
    # 6. Delete from the ETS table instead of the Map
    {name, refs} = Map.pop(state.refs, ref)
    :ets.delete(state.names, name)
    GenEvent.sync_notify(state.events, {:exit, name, pid})
    {:noreply, %{state | refs: refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
