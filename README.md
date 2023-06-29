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

## IDE.iead

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
