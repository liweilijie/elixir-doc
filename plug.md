# Plug

我们使用 `PlugCowboy` 打造一个简单的 **http server**. `Cowboy` 是为 **Erlang** 打造的简单服务器, 而 `Plug` 则为我们提供了它的 connection 适配.

添加依赖:`{:plug_cowboy, "~> 2.0"}`

## Plug 的规范

实际上就是两个函数是必须的: `init/1` 和 `call/2`

`init/1` 函数使用来初始化 `Plug` 的配置。它会被 **supervision tree** 调用。现在，它只是一个空列表，并不会有什么影响。

从 `init/1` 返回的值最终会作为第二个参数，传入到 `call/2` 中。

在我们的 web 服务器，Cowboy，接收到每一个新的请求的时候，调用 call/2 这个函数。这个函数的第一个参数是 %Plug.Conn{} 这个连接结构体，它也应该返回一个 %Plug.Conn{} 连接结构体。

```elixir
defmodule Example.HelloWorldPlug do
    import Plug.Conn

    def init(options), do: options

    def call(conn, _opts) do
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, "Hello World!\n")
    end
end
```

## 配置启动

我们需要在应用启动的时候，告知它启动并监控 Cowboy web 服务器。

这是通过 `Plug.Cowboy.child_spec/1` 函数来实现。

这个函数期望接收三个配置选项：

-   :scheme - 原子类型的 HTTP or HTTPS 配置（:http, :https）
-   :plug - 在 web 服务器中用作为接口的 plug 模块。你可以指定模块的名字，比如 MyPlug，或者是模块名字和配置的元组 `{MyPlug, plug_opts}`，`plug_opts` 将会传入 plug 模块的 `init/1` 函数。
-   :options - 服务器配置。需要包含服务器监听和接收请求的端口号。

`lib/example/application.ex` 文件需要在 `start/2` 函数内定义好子进程 Spec：

```elixir
defmodule Example.Application do
    use Application
    require Logger

    def start(_type, _args) do
        children = [
            {Plug.Cowboy, scheme: :http, plug: Example.HelloWorldPlug, options: [port: 8080]}
        ]
        opts = [strategy: one_for_one, name: Example.Supervisor]

        Logger.info("Starting application...")

        Supervisor.start_link(children, opts)
    end
end
```

注意：我们并不需要显式地调用 child_spec ，这个函数会在 Supervisor 启动进程时自动调用。所以，我们只需要提供一个包括需要启动的模块名，以及启动需要的配置选项。

在 mix.exs 里面增加 application 配置:

```elixir
def application do
    [
        extra_application: [:logger],
        mod: {Example.Application, []}
    ]
end
```

## Router

`lib/example/router.ex`创建一个路由文件:

```elixir
defmodule Example.Router do
    use Plug.Router
    plug :match
    plug :dispatch

    get "/" do
        send_resp(conn, 200, "Welcome")
    end

    match _ do
        send_resp(conn, 404, "Oops!")
    end
end
```

我们需要回到 `lib/example/application.ex` 文件，把 `Example.Router` 添加到 web 服务器的 `supervisor tree` 当中。把 `Example.HelloWorldPlug` 替换为新的路由：

```elixir
def start(_type, _args) do
  children = [
    {Plug.Cowboy, scheme: :http, plug: Example.Router, options: [port: 8080]}
  ]
  opts = [strategy: :one_for_one, name: Example.Supervisor]

  Logger.info("Starting application...")

  Supervisor.start_link(children, opts)
end
```
