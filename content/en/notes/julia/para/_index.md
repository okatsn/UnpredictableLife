---
title: "Parallel Computing"
date: 2021-08-01T14:21:10+08:00
draft: true
---
TODO: draft: true
### parallel computing
#### multi-threading
- <img src="julia-thread.png">
- julia> `Base.Threads.nthreads()` to see current number of thread.
- simply apply `@threads` in front of the for loop:
  ```julia
  Threads.@threads for i in 1:6 
  ... 
  end
  ```
- using `lock` and `unlock` to prevent [race condition](https://yuehhua.github.io/2020/10/19/use-threads-lock-in-julia/). Or you have to properly do variable slicing like matlab parfor (notice that if you do it improperly, no error will occurred).

