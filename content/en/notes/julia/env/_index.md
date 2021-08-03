---
title: "Package and Environment"
linkTitle: "Package & Environment"
date: 2021-07-26T14:07:09+08:00
weight: 5
---






[TOC]



## Very Basic
See instructions by `?` + keyword. For example, 
```
pkg> ?activate
  activate
  activate [--shared|--temp] [path]
```
In which
- Embraced by `[` and `]` is an optional argument.
In a path
- `.`: Denotes the current directory.
- `..`: Denotes the parent directory of the current directory.


switch between julia, pkg and shell mode
- `backspace` to julia
- `]` to package mode
- `;` to shell mode

## Basic knowledge
### Activate and Instantiate

An environment is a place where your project lives, where a bunch of packages of specific versions can be accessed.
- `activate` some/path basically says: From now on, use the `Project.toml` in some/path to resolve what I mean when I say using `SomePackage`. [link](https://discourse.julialang.org/t/trying-to-understand-developing-a-new-package/36701/11)
- `@pkg> activate .` activate the environment at the current folder, then you can `add` (only once) then `using` packages under this environment

Here is an example.
```
(@v1.6) pkg> activate .
  Activating new environment at `C:\MyResearch\FrictionExperiment_2020\code\Project.toml`
  
(code) pkg> activate
  Activating environment at `D:\Users\HSI\.julia\environments\v1.6\Project.toml`

(@v1.6) pkg> activate ..
  Activating new environment at `C:\MyResearch\FrictionExperiment_2020\Project.toml`

(FrictionExperiment_2020) pkg> activate
  Activating environment at `D:\Users\HSI\.julia\environments\v1.6\Project.**toml`**
```

#### Activate A Local Package
- `julia> Pkg.activate("D:\\GoogleDrive\\1Programming\\julia\\MyPackage")`

#### Use A Temporary Environment
```julia
using Pkg
Pkg.activate(mktempdir())
Pkg.add("Gadfly") # will not be permanently added
```



#### Instantiate
- After an environment activated, `@pkg> instantiate` automatically add (download/install) packages according to `Manifest.toml` if it exists [^1]; otherwise, according to `Project.toml` [^2]. `pkg> ?instantiate` to see more information.

[^1]: add specific version of packages as specified in `Manifest.toml`.
[^2]: according to `Project.toml`: add feasible version of packages according to the `[dep]` section with in the `Project.toml`.

### Load a Package/Module

path of built-in (or downloaded packages)
- e.g. `C:\Users\HSI\.julia\packages\Plots\NVH6y\src`
  - `NVH6y` represents the version
- Packages in julia
  - `C:\Users\HSI\.julia\packages\ModuleHomemade\NVH6y\src`
  - **Don't manually add** files and folders to `.\.julia\packages`. **Always use `Pkg` to manage**.


How to use a homemade module:
- `include("C:\Users\HSI\mycode\ModuleHomemade.jl")`
- `using .ModuleHomemade`


### Add packages (`add` and `dev`)


- `(@v1.5) pkg> add PackageExample`: add a package under JuliaLang
- `(@v1.5) pkg> add https://github.com/CGRG-lab/GeneralTools.jl.git`: add a package on github
- `(@v1.5) pkg> add D:\GoogleDrive\1Programming\julia\MyPackage`: add a package locally. 
- `(@v1.5) pkg> add https://github.com/CGRG-lab/GeneralTools.jl.git` and then `(@v1.5) pkg> dev GeneralTools`: clone the package to the local `C:\Users\HSI\.julia\dev\GeneralTools`
  - Every time you `using` this package under the environment where you `dev`, it is linked to the local state of the corresponding folder. 
  - To cancel this dependency on local folder/files, use `(@v1.5) pkg> free GeneralTools` which stops using the local clone and use a registered version instead).
  - If it is not registered, `ERROR: unable to free unregistered package GeneralTools [e6213164]` will occur. In this case, just `pkg> rm GeneralTools` and `pkg> add https://github.com/CGRG-lab/GeneralTools.jl.git` again.



## Create Packages 
### The minimal way using `generate`
[Creating Packages](https://julialang.github.io/Pkg.jl/v1/creating-packages/?fbclid=IwAR1hCwre1UYqrzeqRk8XA-mf3NUKhs8yqJb9aaagPwraOY-pcRjLOGsbpew)
**It is officially recommended to use PkgTemplates**

- pkg> `generate MyPackage`
  - this generates the folder `MyPackage` and
    - `MyPackage\Project.toml`
    - `MyPackage\src\MyPackage.jl`

### Using PkgTemplates (Recommended)

[PkgTemplates.jl](https://invenia.github.io/PkgTemplates.jl/stable/user/)

Create your package with `PkgTemplates` is simple:

```julia
using PkgTemplates # a package that creates new Julia packages.
t = Template()
t("MyPackage") # create an environment name MyPackage (generate and activate)
```

(更多詳見:[包成套件並測試](https://ithelp.ithome.com.tw/articles/10186179))

In most cases, we use git and host our package on github.
With `PkgTemplates` we can create and initiate a git repository the same time:

```julia
t = Template(;
       user = "okatsn", #  GitHub (or other code hosting service) username
       authors = "Tsung-Hsi Wu <okatsn@gmail.com>",
       host = "github.com",
       julia = v"1.6.1", # Minimum allowed Julia version.
       plugins = [Git(;manifest = false, name = "okatsn", email = "okatsn@gmail.com")],
       );
t("MyPackage");
```

> 🔑**Key**
> - The keyword option `manifest = false` of `Git()`: add `/Manifest.toml` to `.gitignore`. 
> - The reason to exclude the `Manifest.toml` is that my package is not sensitive to the version of dependent package. For example, in the case where my package depends on a package, saying `Plots.jl`, if `Manifest.toml` does not be ignored, a specific version that `MyPackage` depends on will be added (where I may already have the newest `Plots` already, since it is so popular).
> - `Manifest.toml` is for version control and in the cases for a package it is usually not necessary. For the dependent package `Plots` as an example, other packages in a project might also be dependent on it; if two different versions of `Plots` are specified by package `A` and `B`, then conflicts might occur when we `using A; using B; func_dep_on_Plots();`.


The information is recorded in the generated `Project.toml` like this:

```julia
name = "MyPackage"
uuid = "cc16d58c-5ce7-42a0-8156-698284945e42"
authors = ["Tsung-Hsi Wu <okatsn@gmail.com>"]
version = "0.1.0"

[compat]
julia = "1.6.1"

...
```
### The Directory Structure of a Package
Here is the directory structure and files that `PkgTemplates` automatically generates: 
```
MyPackage
  ├─.git
  ├─.github
  │  └─workflows
  ├─src
  │  └─MyPackage.jl
  ├─.gitignore
  ├─LICENSE
  ├─Manifest.toml
  ├─Project.toml
  └─README.md
```

### Create your module
_A module_ is practically for organizing your code, and in this tutorial it is the synonym for _a package_. Assuming you have `src/myjoinpath.jl`, in which
```julia
filesep = Base.Filesystem.path_separator;
function myjoinpath(c...)
  path_str = join(c, filesep);
  path_md = Markdown.parse(path_str);
  return path_str, path_md
end
```
Then in `src/MyPackage.jl` file we can do this:
```julia
__precompile__()  # 這可以在你載入套件的時候預先編譯
module MyPackage # 記得套件的內容要縮排！！
  using Markdown
  include("myjoinpath.jl");
  export filesep
  export myjoinpath
end
```
> **🔑 Key:**
> - `include`: Run the script/codes in the `.jl` file.
> - `export`: Make a method/variable be ready for use directly. If something, for example the `myjoinpath` function, is not exported, to use it you have to specify the module name: `MyPackage.myjoinpath(...)`.

#### Use your module
By `include("MyPackage.jl")`, the function `myjoinpath` and the variable `filesep` is ready for use.

Use an unregistered package:
 - `pkg> add https://github.com/CGRG-lab/GeneralTools.jl.git`
 - `julia> using GeneralTools`

#### Best Practice
- Put functions under `src` and its sub-folders.
- Include functions in `MyPackage.jl`.
- Import (`using`) packages in `MyPackage.jl` that is used by the functions in `src`. 
- Choose either way to start a new environment
  - way 1: `julia> cd("MyPackage")` and `pkg> activate .`.
  - way 2: `pkg> activate GeneralTools`
- Add packages that are used in `MyPackage.jl`
  - e.g. `(MyPackage) pkg> add Markdown`
  - If you didn't do this, `Project.toml` will have no information about dependencies, and consequently someone else will fail when trying to `using Markdown; myjoinpath();`. 
- In most cases, git ignore `Manifest.toml` to prevent conflicts.




## Best Practices Handling your project
- create a new environment for every project (`@pkg> activate PATH`), where a `Project.toml` will be created (after the first package being added to the environment).

- only `Pkg.add` the most essential packages under the base environment (e.g. `(@v1.5) pkg> add IJulia, Pluto,  BenchmarkTools`); add all packages used by `using` under a certain project environment (e.g. `(MyProject) pkg>`). 

- In my opinion, packages "seems to be essential" such as `Plots`, should also be added under project environment (e.g. `(MyProject) pkg> add Plots`, not `(@v1.5) pkg> add Plots`), since:
  - if someone clone your project (without `Manifest.toml`), one might failed when `using Plots` since `Plots` does not exists in the `[deps]` section of the `Project.toml`
  - Different version of `Plots` could give you a different result, or even an error. It could be a mess if you update the `Plots` in the base, encounter an error in a certain project and then you want to downgrade it again, since all projects dependent on the packages installed under base will be affected.

- Unless the package you develop aims for selling or being an app, in most case you should loosely define the dependent packages (e.g. `(MyPackage) pkg> add Plots` instead of `(MyPackage) pkg> add Plots@v1.10.2`). That is, 
  - When you developing `MyPackage`, you loosely add dependent packages such as `(MyTools) pkg> add Plots`. 
  - When you work on a project (e.g. `MyProject`) that uses a specific version of `Plots`, you might need to strictly build dependencies by `(MyProject) pkg> add Plots@v1.10.2`. 
  - You also need `MyPackage` in `MyProject`. In this case you should add `MyPackage` by `(MyProject) pkg> add https://github.com/MyAccount/MyPackage.git`.
  - In this way, functions in `MyPackage` will use the same `Plots` (`v1.10.2` in this example) as used by `MyProject`, which is mostly what we expected.

## Develop Your Package
With the help of [Revise.jl](https://timholy.github.io/Revise.jl/stable/), any local changes to the script you apply immediately gets updated.

Of course, you have to `(@v1.6) pkg> add Revise` first.
Second, add your package in a developer mode: 
```
(whatever) pkg> dev D:/GoogleDrive/1Programming/julia/GeneralTools.jl 
```
and in julia repl, 
```
julia > using Revise
julia > using GeneralTools
```
After that, **Revise.jl** starts tracking the package `GeneralTools`, and whatever change you made under the package directory (e.g. `D:/GoogleDrive/1Programming/julia/GeneralTools.jl`) responses immediately.

Last but not least, you have to `pkg> free GeneralTools` after the development session completes. 

> **💡 Kill the terminal won't free the package**, which means you don't have to `(whatever) pkg> dev YourPackage` every time you are developing the package under the environment `whatever`. Also, remember to `free` it while you're not developing the package; otherwise, the project environment (i.e. `whatever` as an example) keeps sticking to the local path.


## Test
Write a test `test/myjoinpath.jl` for `src\myjoinpath.jl`:
```julia
fs = Base.Filesystem.path_separator;
@ test myjoinpath("dir",".to","whatever") == joinpath("dir",".to","whatever")
@ test myjoinpath("foo","bar","nice") == join(["foo","bar","nice"], fs)
```

Write your `test/runtest.jl`
```
using MyPackage
using Base.Test

# script in the test, for example
tests = ["stable",  # test/myjoinpath.jl
         "cooling", # test/myjoinpath.jl
         ......
         ]

println("Running tests:")

for t in tests
    println(" * $(t)")
    include("$(t).jl")
end
```

Run the test:
```julia
using Pkg
Pkg.test("MyPackage");
```

> 💡 A test file's name does not necessarily to be the same as the function to be tested.
> 🙏 This example is modified from [this](https://ithelp.ithome.com.tw/articles/10186179).


## More about `include` (INCOMPLETE)
> :warning: The conclusion of this section may require further validation. For more information, see [code-loading](https://docs.julialang.org/en/v1/manual/code-loading/).

- It seems the order of including function does not affect the results in any sense, according to `@code_lowered`.
In the following example, `testinc0` do the calculation, where `testinc1` just pass all the inputs to `testinc0`; `testinca1` calls `testinca0` in exactly the way as `testinc0`/`testinc1`.

```julia
julia> include("testinc1.jl")
  testinc1 (generic function with 1 method)

julia> include("testinc0.jl")
  testinc0 (generic function with 1 method)

julia> @code_lowered(testinc1(5,2))
  CodeInfo(
  1 ─ %1 = Main.testinc0(a, b)
  └──      return %1
  )

julia> include("testinca0.jl")
  testinca0 (generic function with 1 method)

julia> include("testinca1.jl")
  testinca1 (generic function with 1 method)

julia> @code_lowered(testinca1(5,2))
  CodeInfo(
  1 ─ %1 = Main.testinca0(a, b)
  └──      return %1
  )
```

- The file name does not need to be the same as the function name. That is, we can have `hello.jl` with `function hello_a()` and `function hello_b()` inside. 

- The order of function in `xxxx.jl` seems do not matter.

## Resources
[Pkg.jl](https://julialang.github.io/Pkg.jl/v1.1/managing-packages/)
[Develop a package and test](https://tlienart.github.io/pub/julia/dev-pkg.html)
### About Git and GitHub
[Git 與 GitHub 版本控制基本指令與操作入門教學](https://blog.techbridge.cc/2018/01/17/learning-programming-and-coding-with-python-git-and-github-tutorial/)

[GitHub Pages](https://pages.github.com/)

[公開程式碼](https://ithelp.ithome.com.tw/articles/10186180)

### Test
- https://docs.julialang.org/en/v1/stdlib/Test/

- [包成套件並測試](https://ithelp.ithome.com.tw/articles/10186179)

- [看一下Julia裡頭的unit test ](https://ithelp.ithome.com.tw/articles/10204464)

- [Adding tests to the package](https://julialang.github.io/Pkg.jl/dev/creating-packages/#Adding-tests-to-the-package-1)

### Manifest
- [Create manifest](https://pkgdocs.julialang.org/v1/toml-files/)
  - [Project or Package environment](https://docs.julialang.org/en/v1/manual/code-loading/)
  - [Creating Package](https://pkgdocs.julialang.org/v1/creating-packages/)