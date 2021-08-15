---
author: "Tsung-Hsi, Wu"
title: "Type and Function"
linkTitle: "Type and Function"
---


## Inner & outer constructor
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





> **💡Hint:**
> - If no inner constructor was explicitly specified, there is a hidden one like `Time2(hour, minute, second) = new(hour, minute, second)`
> - If `Time2(hour, minute) = new(hour, minute, 0)` is specified in the `struct Time2`, the default one is replaced and hence constructing `Time2` with 3 arguments (e.g. `Time2(23,10,59)`) will fail.


## Mutable structure and mutating function
### Mutating function

If an inputargument is a mutable structure, e.g., an array, then it can (or will) be modified in the function. The notion `!` is just a notion that warns you this function modifies some of the input argument. (see this [thread](https://stackoverflow.com/questions/39293082/mutating-function-in-julia-function-that-modifies-its-arguments))

For example, make your mutable structure and a mutating function!
```julia
A = collect(1:5)
B = collect(6:10);
function modify_A!(A)
A[:] = B;
end
modify_A!(A);
A
```

```
5-element Vector{Int64}:
  6
  7
  8
  9
 10
```



```julia
mutable struct Time3
	hour::Int64
	minute::Int64
	second::Int64
end

function changeTo24!(t::Time3)
if t.hour<12 
	t.hour = t.hour + 12;
end
end
t3 = Time3(5,10,27);
changeTo24!(t3);
t3
```

```
Main.##WeaveSandBox#313.Time3(17, 10, 27)
```





If the input structure is not mutable, then error occurred just as that when we try to modify immutable structure:
```julia
B = Time2(3,2,1);
function modify_b!(B)
B.hour = 5;
end

try
    modify_b!(B)
catch e
    sprint(showerror, e)
end
```

```
"setfield! immutable struct of type Time2 cannot be changed"
```





## Parametric type
> **💡Hint:**
> - use `methods` to see how we can construct an object of a certain type

For example, we can find the method `The method `(Vector{T} where T)(::UndefInitializer, m::Integer)` using `methods(Vector)`.
Using this method, we can construct `Vector`:
```julia
Vector{Float64}(undef, 5)
```

```
5-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.0
 0.0
```





`(Array{T, N} where T)(x::AbstractArray{S, N}) where {S, N}`:

```julia
Array{Int64, 1}(1:5)
```

```
5-element Vector{Int64}:
 1
 2
 3
 4
 5
```





### Parametric type constructor

#### The simplest example of parametric type
```julia
struct Point{T<:Real}
	a::T
	b::T
end
```




which is equivalent to

```julia
struct Point{T<:Real}
	a::T
	b::T
	Point{T}(a,b) where {T<:Real} = new(a,b) # inner constructor
end
Point(a::T,b::T) where {T<:Real} = Point{T}(a,b) # outer constructor
```



, in which, the outer constructor is equivalent to:

```julia
function Point(a::T, b::T) where {T<:Real}
	Point{T}(a,b)
end
```



> **⚠️Notice🔥:**
> Noted that the **inner constructor** of a parametric type **should always have** a type parameter (i.e. **`{T}`**). 
> - for example, the `{T}` after `Point{T}(a,b) = new(a,b) where T`
> - once we have `{T}`, there must be a `where` at the end of the line

A typical purpose to overwrite the default inner constructor is that you want a certain field to be automatically calculated, not user assigned.

For example, 

```julia
struct Point3{T<:Real} 
    x::T
    y::T
    z::T
    function Point3{T}(x::T, y::T) where {T<:Real} # where T is also fine
        z = x * y;
        new(x,y,z);
    end
end
```


```julia
pt = Point3{Int64}(3,5)
```

```
Main.##WeaveSandBox#313.Point3{Int64}(3, 5, 15)
```





#### Parametric type with two or more parameters

```julia
struct Whatever{T<:AbstractString, N<:Int}
	name::T
	gender::T
	height::N
end
AAA = Whatever("John","M",1988)
```

```
Main.##WeaveSandBox#313.Whatever{String, Int64}("John", "M", 1988)
```





### Abstract type with parameter
```julia
abstract type Pointy{T<:Real} end

mutable struct Point2D{T} <: Pointy{T}
x::T
y::T
end
mutable struct Point1D{T} <: Pointy{T}
x::T
end
P1 = Point2D(1.2,2.0);
P2 = Point2D(4.0,3.0)
```

```
Main.##WeaveSandBox#313.Point2D{Float64}(4.0, 3.0)
```



```julia
p1 = Point1D(3)
```

```
Main.##WeaveSandBox#313.Point1D{Int64}(3)
```





#### An example of the use of abstract type
A typical reason for applying abstract type is to make it simpler in type assertions of the functions dependent on a similar set of types.

For example, 

```julia
function distance(p1::N, p2::N) where N<:Pointy
	pttype = typeof(p1);
	m = 0;
	for field in fieldnames(pttype)
		m += (getfield(p1, field) - getfield(p2, field))^2
	end
	return sqrt(m)
end

function length(p::Pointy)
	pttype = typeof(p);
	m = 0;
	for field in fieldnames(pttype)
		m += getfield(p, field)^2
	end
	return sqrt(m)
end
```

```
length (generic function with 1 method)
```



```julia
length(P2)
```

```
5.0
```



```julia
distance(P1,P2)
```

```
2.973213749463701
```





Without the abstract type `Pointy`, we have to define the function as
```julia
function distance(p1::Union{Point1D,Point2D}, p2::Union{Point1D,Point2D})
  ...
end
```



### `where`

With `where`, we are able to have assertion of variables to have their type satisfying a certain condition. Here is an example:
```julia
function add(a::T, b::T) where {Int <: T <: Real}
a + b;
end

try
    add(1.0,2.0)
    # Float64 does not lay between Int and Real; thus, error!
catch e
    sprint(showerror, e)
end
```

```
"MethodError: no method matching add(::Float64, ::Float64)\nClosest candida
tes are:\n  add(::T, !Matched::T) where Int64<:T<:Real at D:\\GoogleDrive\\
Sites\\unpredictable-life\\content\\en\\notes\\julia\\typefun\\type-and-fun
ction.jmd:2"
```





More about ["where"](https://docs.julialang.org/en/v1/base/base/#where).


### Tuple type
You can construct a tuple type.
For example, 
```julia
MyTuple = Tuple{Float64, AbstractString, Vararg{Int64}};
isa((5.2, "hello", 1,2,3,4,5), MyTuple)
```

```
true
```



```julia
n = 3; # only 3 elements of Int64 allowed
MyTuple2 = Tuple{Float64, AbstractString, Vararg{Int64,n}};
isa((5.2, "hello", 1,2,3,4,5), MyTuple2)
```

```
false
```





while `isa((5.2, "hello", 1,2,3), MyTuple2)` is true.

