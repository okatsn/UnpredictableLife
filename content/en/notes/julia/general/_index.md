---
title: "General"
date: 2021-08-01T14:24:58+08:00
draft: true
---
[TOC]
## Tutorial and Resources


[2019 iT 邦幫忙鐵人賽 (共32個小課程)](https://ithelp.ithome.com.tw/users/20111688/ironman/1735?page=1)

[Julia為資料科學而生：一起來追程式語言新女神](https://mastertalks.tw/products/julialanguage)

[超新手教學-型別](https://github.com/JuliaLangTW/julia_tutorials_for_dummy/blob/master/notebook/3_types.ipynb)

[julia 程式風格指引](https://hackmd.io/@7WeiUEuJSBKp7WCRouAWVg/r106dSpkb/%2FGwTgZgzMAcCMCGBaArPAxgE0QFlgUwkWggAYAmReCDbbPWE6aEEIA%3D%3D%3D?type=book#%E7%A8%8B%E5%BC%8F%E9%A2%A8%E6%A0%BC%E6%8C%87%E5%BC%95)

### Addpath-Like Snippet
If you're a former matlab user, you might missing `addpath`.
The following code include all the `.jl` files in the `./src`, and all functions within the files are ready for use.
```
srcdir = joinpath(pwd(), "src");
for jl_file in readdir(srcdir)
	dotpos = findall(isequal('.'),jl_file); # find the index for the '.'
	if isempty(dotpos)
		continue
	end
	ext0 = dotpos[end] + 1; # the file extension starts right after the last '.'
  if jl_file[ext0:end] == "jl" # if extension is `jl`
	include(joinpath(srcdir, jl_file));
  end
end
```

Also see:
- [How to call a function from another folder in julia](https://stackoverflow.com/questions/54555530/how-to-call-a-function-from-another-folder-in-julia)
- [push with @everwhere](https://stackoverflow.com/questions/30197565/the-command-to-add-to-path-in-julia-language)

### LazyUtils
- pkg> `add https://github.com/yezhengkai/LazyUtils.jl` to download master's work.
- julia> `using LazyUtils`

julia> `get_environments()`
- will list all the environment directories, e.g. 
  - "C:\\Users\\HSI\\.julia\\environments\\v1.5"
  - "C:\\Users\\HSI\\.julia\\environments\\v1.4"
  - "D:\\GoogleDrive\\1Programming\\julia\\MyToolBox"
- and you can copy and paste to do 
  - pkg> activate D:\\GoogleDrive\\1Programming\\julia\\MyToolBox

julia> `get_projectfiles()`
- will list all `Project.toml`. Double click one to open the file directly.

### Useful macros
- `@code_lowered g(f)`:  ask Julia what happened. Also see [What is the difference between `@code_native`, `@code_typed` and `@code_llvm` in Julia](https://stackoverflow.com/questions/43453944/what-is-the-difference-between-code-native-code-typed-and-code-llvm-in-julia)