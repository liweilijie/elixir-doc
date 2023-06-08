defmodule KvServer do
  use Application
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Task.Supervisor, [[name: KvServer.TaskSupervisor]]),
      worker(Task, [KvServer, :accept, [4040]])
    ]

    opts = [strategy: :one_for_one, name: KvServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def accept(port) do
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - block on `:gen_tcp.recv/2` until data is available
    #
    {:ok, socket} =
      :gen_tcp.listen(
        port,
        [:binary, packet: :line, active: false]
      )

    IO.puts("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Task.Supervisor.start_child(KvServer.TaskSupervisor, fn -> serve(client) end)
    loop_acceptor(socket)
  end

  defp serve(client) do
    client
    |> read_line()
    |> write_line(client)

    serve(client)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
