defmodule AgentCount do
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def increment do
    Agent.update(__MODULE__, &(&1 + 1))
  end
end

defmodule KVBucket do
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end
end

defmodule BlockChainStruct do
  def start_link do
    blockchain = %{
      chain: [],
      current_transactions: [],
      last_block: nil
    }

    Agent.start_link(fn -> blockchain end, name: __MODULE__)
  end

  defp new_block() do
    block = nil

    __MODULE__
    |> Agent.update(fn blockchain ->
      chain = blockchain[:chain]
      %{blockchain | chain: [] ++ chain ++ [block], last_block: block}
    end)
  end

  defp new_transaction(transaction) do
    __MODULE__
    |> Agent.update(fn blockchain ->
      current_transaction = blockchain[:current_transactions]
      %{blockchain | current_transactions: [] ++ current_transactions ++ [transaction]}
    end)
  end
end
