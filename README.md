# elixir-doc

elixir learning document.

有三周多没回来写代码,接下来还不知道还有多少天要耽搁.这是我和小伙伴刚出来的一个月时间我就一直有各种不得已的事情.

但是我想我需要更多的努力,更坚定的信念来做好我们的事情. elixir 是我刚出来遇到的一座山.我想我一定要坚持地看完它,并且用它做好我想要做的高并发.

加油.

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

```elixir
{:ok, result} = {:ok, 13} # result is 13
[a, 2, 3] = [1, 2, 3] # a is 1
[head | tail] = [1,2,3] # head is 1, tail is [2,3]
# [head|tail]这种形式不光在模式匹配时可以用，还可以用作向列表插入前置数值：
list = [1,2,3]
[0|list] # [0,1,2,3]
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

```elixir
fun = &(&1 +1)
fun.(1) # 2
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

**recursion**

递归的使用.

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
