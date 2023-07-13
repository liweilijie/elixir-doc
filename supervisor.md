# supervisor

[引用](https://www.cnblogs.com/wang_yb/p/5564459.html)

OTP 平台的容错性高，是因为它提供了机制来监控所有 processes 的状态，如果有进程出现异常， 不仅可以及时检测到错误，还可以对 processes 进行重启等操作。

有了 supervisor，可以有效的提高系统的可用性，一个 supervior 监督一个或多个应用， 同时， supervior 也可以监督 supervior，从而形成一个监督树，提高整个系统的可用性。

注意 ，supervior 最好只用于监督，不要有其他的业务逻辑处理，越是接近监督树根部的 supervior 就要越简单， 因为 supervior 简单就不容易出错，它是保证系统高可用的关键。

## 监督策略

监督策略有 4 种：

-   :one_for_one 只重启出错的 process
-   :one_for_all 当有 process 出错时，重启所有的 process
-   :rest_for_one 重启出错的 process ，以及所有在它之后启动的 process（也就是重启对出错 process 有依赖的 所有 process）
-   :simple_one_for_one 类似 :one_for_one ，但是 supervior 只能包含一个 process

监督策略的转换非常简单，下面演示 2 种监督策略的示例：
