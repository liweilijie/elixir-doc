# elixir-doc

elixir learning document.

有三周多没回来写代码,接下来还不知道还有多少天要耽搁.这是我和小伙伴刚出来的一个月时间我就一直有各种不得已的事情.

但是我想我需要更多的努力,更坚定的信念来做好我们的事情. elixir 是我刚出来遇到的一座山.我想我一定要坚持地看完它,并且用它做好我想要做的高并发.

加油.

## Hex

[Hex](https://hex.pm/) 是 **Elixir** 的包管理器(https://hex.pm).

```bash
mix local.hex --force
```

这里我们用到 **Mix**。**Mix** 是 **Elixir** 的构建工具，提供许多便捷功能，比如项目创建、编译、测试等等。

## 常用命令

```bash
iex -S mix
iex -S mix run -e HelloMain.main

mix run --no-halt
mix do deps.get
mix compile

mix help cmd
mix cmd --app app1 --app app2 mix test


# mix do run app1.exs, run app2.exs
mix do run ethereum_jsonrpc --no-halt

mix ecto.migrate
mix ecto.rollback
mix phx.routes # prints all routes
mix clean
mix phx.server
```

## IDE.vscode

插件:

-   elixirls
-   elixir-format
-   vscode-elixir
-   Credo (Elixir Linter)
-   hex.pm

配置:

-   "editor.formatOnSave": true
-   "editor.formatOnType": true

```json
"editor.formatOnSave": true
"editor.formatOnType": true
"[elixir]": {
    "editor.defaultFormatter": "JakeBecker.elixir-ls",
    "editor.wordBasedSuggestions": false,
    "editor.acceptSuggestionOnEnter": "on"
},
"emmet.includeLanguages": { "HTML (Eex)": "html" }
```

## IDE.idea

使用 **idea** 的设置，需要安装 `erlang`, `elixir` 两个插件。

然后设置自动 format:

From the menus

1. Code
2. Reformat File
3. Click Run in the "Reformat File" dialog

To tun on format on save:

1. Preferences
2. Tools > Actions on Save.
3. Check "Reformat code".
4. Make sure "All file types" is set or at least "Files: Elixir" is set.

Autosave

JetBrains IDEs have autosave turned on by default, but you can adjust the settings:

1. Preferences
2. Appearance & Behavior > System Settings.
3. Check or uncheck the settings in the Autosave section.

## 教程

-   [elixir 入门教程](https://github.com/straightdave/programming_elixir)

## Ecto

在创建的过程中发现有冲突,有时候写错了表名再改过来就会不存在的问题.

> \*\* (Postgrex.Error) ERROR 42P01 (undefined_table) table "actors" does not exist

我们可以用 mix ecto.reset 相当于这几个操作:

```bash
mix ecto.drop
mix ecto.create
mix ecto.migrate
```

## function one line

[one line](https://stackoverflow.com/questions/33983394/elixir-what-is-syntax-for-function-definitions)

You've combined two forms of method definition there - the shorter one-line syntax and the longer do/end syntax.

```elixir
# one line
def foobar(foo, bar), do: baz

# multi-line method
def foobar(foo, bar) do
    foo
    bar
end
```

## 基础知识

**list**

列表是链式的(不像元组那样连续内存),列表可以包含任意类型的值.

```elixir
[1, 2, true, 3]
[1,2,3] ++ [4,5,6] # [1,2,3,4,5,6]
[1,true, 2, false, 3, true] -- [true, false] # [1,2,3,true]
# 取列表表头和尾, 从空列表中取会报错
list = [1,2,3]
hd(list) # 1
tl(list) # [2,3]
```

**tuple(元组)**

使用大括号定义 tuples, 类似列表,可以承载任意的类型数据. 元组使用连续的内存空间存储数据,可以方便索引访问元组数据以及元组大小.

```elixir
{:ok, "hello"}
tuple_size {:ok, "hello"} # 2

# 可以使用函数put_elem/3 设置某个位置的元素值
tuple = {:ok, "hello"}
put_elem(tuple, 1, "world") # {:ok, "world"}
tuple # 值未变, {:ok, "hello"}

# elem/2 访问一个元组的元素
elem(tuple, 1) # "hello"
```

**pattern matching**

函数式编程很依赖模式匹配, 我们用模式匹配来决定执行哪个函数,从而控制流程.

检查 **=** 运算符两边是否相等的过程就是模式匹配.

模式匹配的用处:

-   变量赋值
-   提取值
-   决定调用哪个函数

模式匹配还能用来检查和提取各种类型的数据,从而解决更复杂的问题.

`x=1` 这是模式匹配, **Elixir** 将值 **1** 绑定到变量 **x** 使两边相等.

`2 = x` 的模式匹配相当于:

```elixir
if 2 == x
    2
else
    raise MatchError
end
```

**匹配部分字符串**

字符串匹配模式唯一限制是不能在<>运算符的左侧使用变量

```elixir
"Authentication: " <> credentials = "Authentication: Basic dXNlcjpwYXNz"
credentials # credentials is Basic dXNlcjpwYXNz


# 字符串匹配模式唯一限制是不能在<>运算符的左侧使用变量
first_name <> " Doe" = "John Doe" # 会报错
```

```elixir
{:ok, result} = {:ok, 13} # result is 13
[a, 2, 3] = [1, 2, 3] # a is 1
[head | tail] = [1,2,3] # head is 1, tail is [2,3]
# [head|tail]这种形式不光在模式匹配时可以用，还可以用作向列表插入前置数值：
list = [1,2,3]
[0|list] # [0,1,2,3]

[head | tail] = [:a] # head is :a, tail is [] 空列表
[ head | tail] = [] # MatchError 报错
[a, b | rest] = [1,2,3,4] # a is 1, b is 2
```

**pin**

```elixir
x = 1
x = 2
```

> Elixir 可以给变量重新绑定（赋值）。 它带来一个问题，就是对一个单独变量（而且是放在左端）做匹配时， Elixir 会认为这是一个重新绑定（赋值）操作，而不会当成匹配，执行匹配逻辑。 这里就要用到 pin 运算符。

如果你不想这样，可以使用 pin 运算符(^)。 加上了 pin 运算符的变量，在匹配时使用的值是本次匹配前就赋予的值：

```elixir
x = 1
{x, ^x} = {2, 1}
x # 2
```

**case**

```elixir
case {1,2,3} do
    {4,5,6} -> "this clause won't match."
    {1, x, 3} -> "this clause will match and bind x to 2 in this clause."
    _ -> "this clause would match any value."
end

# 如果与一个已赋值的变量做比较，要用pin运算符(^)标记该变量：
x = 1
case 10 do
    ^x -> "won't match"
    _ -> "will match"
end

# guard clauses
case {1,2,3} do
    {1, x, 3} when x > 0 -> "will match"
    _ -> "won't match"
end
```

**cond**
case 是拿一个值去同多个值或模式进行匹配，匹配了就执行那个分支的语句。 然而，许多情况下我们要检查不同的条件，找到第一个结果为 true 的，执行它的分支。 这时我们用 cond：

```elixir
cond do
    2 + 2 == 5 -> "will not be true"
    2 * 2 == 3 -> "nor this"
    1 + 1 == 2 -> "but this will."
    true -> "this is always true (equivalent to else)"
end
```

这样的写法和命令式语言里的 else if 差不多一个意思（尽管很少这么写）。

如果没有一个条件结果为 true，会报错。因此，实际应用中通常会使用 true 作为最后一个条件。 因为即使上面的条件没有一个是 true，那么该 cond 表达式至少还可以执行这最后一个分支：

**键值列表**

```elixir
list = [{:a, 1}, {:b, 2}]
list == [a: 1, b: 2]
```

**maps**

使用`%{}`来定义.

```elixir
map = %{:a => 1, 2=> b}
# 如果图中的键都是原子，那么你也可以用键值列表中的一些语法：
map = %{a: 1, b: 2}

map = %{:a => 1, 2=> b}
# 访问
map.a # 1
# 修改
%{map | :a => 2} # %{:a => 2, 2 => :b}
%{map | :c => 3} # ArgumentError :c 不存在

```

**function**

`&(&1+1)` => `fn x->x+1 end`

-   & 开始定义函数, &运算符后面的括号是可选的.
-   &1 第一个参数
-   &2 第二个参数

```elixir
fun = &(&1 +1)
fun.(1) # 2

total_cost = &(&1 * &2)
total_cost.(10, 2)

mult_by_2 = & &1 * 2
mult_by_2.(3)
```

默认参数 `\\`

```elixir
defmodule Concat do
    def join(a, b, sep \\ " ") do
        a <> sep <> b
    end
end
IO.puts Concat.join("hello", "world")
IO.puts Concat.join("hello", "world", "_")
```

```elixir
# 这是将具名函数绑定到变量或者函数参数的快捷方法.
upcase = &String.upcase/1
upcase.("hello, world!")
```

**用函数来控制流程**

比较两个数大的一个返回.

```elixir
defmodule NumberCompare do
    def greater(number, other_number) do
        check(number >= other_number, number, other_number)
    end

    defp check(true, number, _), do: number
    defp check(false, _, other_number), do: other_number
end
```

使用 guard clause 简化定义辅助函数的需求:

```elixir
defmodule NumberCompare do
    def greater(number, other_number) when number >= other_number, do: number
    def greater(_, other_number), do: other_number
end

defmodule Checkout do
    def total_cost(price, tax_rate) when price >= 0 and tax_rate >= 0 do
        price * (tax_rate + 1)
    end
end
```

**recursion**

递归的使用. 递归是函数式编程里面最难理解的事情之一,确定终止条件和函数自己调用自己都让人觉得费解.

```elixir
defmodule Sum do
    def up_to(0), do: 0
    def up_to(n), do: n + up_to(n - 1)
end

up_to(5)
# = 5 + up_to(4)
# = 5 + 4 + up_to(3)
# = 5 + 4 + 3 + up_to(2)
# = 5 + 4 + 3 + 2 + up_to(1)
# = 5 + 4 + 3 + 2 + 1 + up_to(0)
# = 5 + 4 + 3 + 2 + 1 + 0
# = 15


# 遍历列表,将所有数累加
defmodule Math do
    def sum([]), do: 0
    def sum([head | tail]), do: head + sum(tail)
end

Math.sum([10, 5, 15]) # 30
Math.sum([]) # 0
```

```elixir
defmodule Recursion do
    def print_multiple_times(msg, n) when n <= 1 do
        IO.puts msg
    end

    def print_multiple_times(msg, n) do
        IO.puts msg
        print_multiple_times(msg, n - 1)
    end
end

Recursion.print_multiple_times("hello", 3)
```

TODO:

```elixir
@enchanter_name "Edwin"

def enchant_for_sale([]), do: []
def enchant_for_sale([item = %{magic: true} | incoming_items]) do
    [item | enchant_for_sale(incoming_items)]
end
def enchant_for_sale([item | incoming_items]) do
    new_item = %{
        title: "#{@enchanter_name}'s #{item.title}",
        price: item.price * 3,
        magic: true
    }

    [new_item | enchant_for_sale(incoming_items)]
end
```

阶乘的递归:

```elixir
defmodule Factoral do
    def of(0), do: 1
    def of(n) when n > 0, do: n * of(n - 1) # n > 0 确保不会对负数求阶乘
end
```

TODO:

分治法排序列表:

```elixir

```

**高阶函数**

高阶函数是那些参数中包含有函数或者返回函数的函数.

```elixir
File.open("file.txt", [:write], &(IO.write(&1, "Hello, World!")))

spawn fn -> IO.puts "Hello, World!" end
```

## 代码片段

**猜数字**:

```elixir
defmodule Guess do
    def guess() do
        random = Enum.random(1..10)
        IO.puts "Guess a number between 1 and 100"
        Guess.guess_loop(random)
    end

    def guess_loop(num) do
        data = IO.read(:stdio, :line)
        {guest _rest} = Integer.parse(data)
        cond do
            guess < num ->
                IO.puts "Too low!"
                guess_loop(num)
            guess > num ->
                IO.puts "Too high!"
                guess_loop(num)
            true ->
                IO.puts "That's right!"
        end
    end
end

Guess.guess()
```

```elixir
# map函数知道如何将String.upcase应用于列表中的每个项目,其结果是一个新列表,所有的单词都是大写的.
Enum.map(["dog", "cats", "flowers"], &String.upcase/1)

# input: the dark tower
# output: The Dark Tower
def capitalize_words(title) do
    title
    |> String.split
    |> capitalize_all
    |> join_with_whitespace
end
```

声明式编程思绪侧重于必要的内容,使用递归函数遍历或者循环列表.

```elixir
# 转换为大写
defmodule StringList do
    def upcase([]), do: []
    def upcase([first | rest]), do: [String.upcase(first) | upcase(rest)]
end

StringList.upcase(["dogs", "hot dogs", "bananas"])
```

## Agent

[Agent](https://github.com/straightdave/advanced_elixir/blob/master/02-agent.md)

```elixir
# 常用方法
{:ok, agent} = Agent.start_link fn -> [] end
Agent.update(agent, fn list -> ["eggs" | list] end)
Agent.get(agent, fn list -> list end)
Agent.stop(agent)
```

kv 示例:

```elixir
defmodule KV.Bucket do
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
```
