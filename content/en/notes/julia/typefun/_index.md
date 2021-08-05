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

Here is an example of **3** inner constructor and **1** outer constructor.
```julia
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
end;

# the way to show
function Base.show(io::IO, t::Time2)
	print("$(t.hour)h $(t.minute)m $(t.second)s")
end
```







```output
# 4 methods for type constructor:
[1] Time2(hours::Float64) in Main at REPL[9]:11
[2] Time2(hour::Int64) in Main at REPL[11]:1   
[3] Time2(hour, minute) in Main at REPL[9]:10
[4] Time2(hour, minute, second) in Main at REPL[9]:8
```

```julia
Time2(23,10,4)
```

```
23h 10m 4s
```



```julia
Time2(23,10)
```

```
23h 10m 0s
```



```julia
Time2(23)
```

```
23h 0m 0s
```


