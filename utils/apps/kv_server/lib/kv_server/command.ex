defmodule KvServer.Command do
  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples

      iex> KvServer.Command.parse "CREATE shopping\r\n"
      {:ok, {:create, "shopping"}}

  """
  def parse(line) do
    :not_implemented
  end
end
