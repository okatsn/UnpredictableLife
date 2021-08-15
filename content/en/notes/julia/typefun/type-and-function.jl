
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


Time2(23,10,4)


Time2(23,10)


Time2(23)


A = collect(1:5)
B = collect(6:10);
function modify_A!(A)
A[:] = B;
end
modify_A!(A);
A


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


B = Time2(3,2,1);
function modify_b!(B)
B.hour = 5;
end

try
    modify_b!(B)
catch e
    sprint(showerror, e)
end


Vector{Float64}(undef, 5)


Array{Int64, 1}(1:5)


struct Point{T<:Real}
	a::T
	b::T
end


struct Point{T<:Real}
	a::T
	b::T
	Point{T}(a,b) where {T<:Real} = new(a,b) # inner constructor
end
Point(a::T,b::T) where {T<:Real} = Point{T}(a,b) # outer constructor


function Point(a::T, b::T) where {T<:Real}
	Point{T}(a,b)
end


struct Whatever{T<:AbstractString, N<:Int}
	name::T
	gender::T
	height::N
end
AAA = Whatever("John","M",1988)


abstract type Pointy{T<:Real} end

mutable struct Point2D{T} <: Pointy{T}
x::T
y::T
end
mutable struct Point1D{T} <: Pointy{T}
x::T
end

P2 = Point2D(4.0,3.0)


p1 = Point1D(3)


function add(a::T, b::T) where {T <: Real}
a + b;
end

add(1.0,2.0)


struct Point3{T}
    x::T
    y::T
    z::T
end

Point3{T}(x::T,y::T,z::T) where {Int <: T <: Real} = Point3(x,y,z);


pt = Point3(3.2,7.1,5.5)

