# KV

**关于 OTP behaviors 的一个 kv 示例**

## Modules

-   KV.Bucket 模块： 负责存储可被不同进程读写的键值对

## State

-   Agent: 对状态简单的封装
-   GenServer: 通用的服务器进程，它封装了状态，提供了同步或者异步调用，支持代码热更新等等。
-   GenEvent: 通用的事件管理器，允许向多个接收者发布消息
-   Task: 计算处理异步单元，可以派生出进程并稍后收集计算结果

### Agent

```elixir
{:ok, agent} = Agent.start_link fn -> [] end # {:ok, #PID<0.57.0>}
Agent.update(agent, fn list -> ["eggs"|list] end) # :ok
Agent.get(agent, fn list -> list end) # ["egges"]
Agent.stop(agent)
```
