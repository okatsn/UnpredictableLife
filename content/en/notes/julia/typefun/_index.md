---
author: "Tsung-Hsi, Wu"
title: "Type and Function"
linkTitle: "Type and Function"
---


## Structure/Type
### Inner & outer constructor
Points:
- A `struct` can have multiple ways to be constructed.
- In general, try to keep inner constructor(s) flexible, and by adding outer constructors to provide alternative approaches for convenience.

Here is an example 
```julia
begin
	struct Time2
		hour::Int64
		minute::Int64
		second::Int64
		# The followings are inner constructions
		# if we didn't write any inner constructor, there is a default one (hidden) 
		#   that looks like:
		Time2(hour, minute, second) = new(hour, minute, second)
		# this constructor allows constructing a type with only two variables.
		Time2(hour, minute) = new(hour, minute, 0)
		function Time2(hours::Float64)
			exacthour = Int64(floor(hours));
			minutes = (hours - exacthour)*60;
			exactmin = Int64(floor(minutes));
			seconds = (minutes - exactmin)*60;
			exactsec = Int64(floor(seconds));
			return new(exacthour, exactmin, exactsec)
		end
	end
	
	# outer constructor
	function Time2(hour::Int64)
		Time2(hour,0,0)
	end
end;

# [println(m) for m in methods(Time2)]
methods(Time2)
```


# 4 methods for type constructor:<ul><li> Main.##WeaveSandBox#257.Time2(hours::<b>Float64</b>) in Main.##WeaveSandBox#257 at <a href="https://github.com/google/docsy-example/tree/8453a93952c51dc73e917119d5ac9a206c32c676//content/en/notes/julia/typefun/type-and-function.jmd#L13" target="_blank">D:\GoogleDrive\Sites\unpredictable-life\content\en\notes\julia\typefun\type-and-function.jmd:13</a></li> <li> Main.##WeaveSandBox#257.Time2(hour::<b>Int64</b>) in Main.##WeaveSandBox#257 at <a href="https://github.com/google/docsy-example/tree/8453a93952c51dc73e917119d5ac9a206c32c676//content/en/notes/julia/typefun/type-and-function.jmd#L24" target="_blank">D:\GoogleDrive\Sites\unpredictable-life\content\en\notes\julia\typefun\type-and-function.jmd:24</a></li> <li> Main.##WeaveSandBox#257.Time2(hour, minute) in Main.##WeaveSandBox#257 at <a href="https://github.com/google/docsy-example/tree/8453a93952c51dc73e917119d5ac9a206c32c676//content/en/notes/julia/typefun/type-and-function.jmd#L12" target="_blank">D:\GoogleDrive\Sites\unpredictable-life\content\en\notes\julia\typefun\type-and-function.jmd:12</a></li> <li> Main.##WeaveSandBox#257.Time2(hour, minute, second) in Main.##WeaveSandBox#257 at <a href="https://github.com/google/docsy-example/tree/8453a93952c51dc73e917119d5ac9a206c32c676//content/en/notes/julia/typefun/type-and-function.jmd#L10" target="_blank">D:\GoogleDrive\Sites\unpredictable-life\content\en\notes\julia\typefun\type-and-function.jmd:10</a></li> </ul>

```julia
Time2(23,10,4)
```

```
Main.##WeaveSandBox#257.Time2(23, 10, 4)
```



```julia
Time2(23,10)
```

```
Main.##WeaveSandBox#257.Time2(23, 10, 0)
```



```julia
Time2(23)
```

```
Main.##WeaveSandBox#257.Time2(23, 0, 0)
```


