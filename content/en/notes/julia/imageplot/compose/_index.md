---
author: "Tsung-Hsi, Wu"
title: "A Brief Tutorial for Compose.jl"
date: "2021-08-27"
linkTitle: "using Compose.jl"
---



## Introduction
Compose creates graphics that can be further composed with others.
For example, create a circle of radius 0.2 centered at 0.5 filled with red color in the coordinate system with both x, y's range being [0,1] by default:


```julia
using Compose
compose(context(), fill("red"), circle(0.5,0.5,0.2))
```

![](compose_2_1.png)


Regarding the structure of the composed graphic as a tree, there are three important types for "member" in the tree:
- `Context`: an internal node that you may regard it as a "coordinate system"; it is created by `context()`.
- `Form`: a leaf node that defines geometry. For example, the `circle()`
- Property: a leaf node that gives a property to the `Form`. For example, `fill("red")`.

## Decomposition of composed object
`compose(a,b,c,ds...)` is in fact `compose(compose(a, b), c, ds...)`; with `compab = compose(a,b)`, it can further be rewritten to `compose(compose(compab, c), ds...)`.

## Introspect the structure of graphics
You can `introspect` the `compose`d graphic to see the relations between objects and properties.

![](cmpsexplained.png)


## Vectorization
Plot three circles of three colors:
```julia
# the x, y, r of the three circles:
xs = [0.25, 0.5, 0.75];
ys = [0.75, 0.5, 0.25];
rs = [0.1, 0.1, 0.1]; # or simply [0.1] is ok

# the colors to fill for the three circles
using Colors
colors = [LCHab(92, 10, 77), LCHab(68, 74, 192), LCHab(78, 84, 29)];

fig_e = compose(context(),
circle(xs, ys, rs), fill(colors));
```


![](compose_4_1.png)



Create a new coordinate system of 9 sub-coordinate system, put `fig_e` (the three circles) inside each sub-coordinate system:
```julia
# the start points of the 9 sub-coordinate systems
x0 = [0,0,0,1,1,1,2,2,2]./3;
y0 = [0,1,2,0,1,2,0,1,2]./3;
# and their x range and y range
xw = yh = 1.0./3;

subcoord(x0,y0) = (context(x0,y0,xw,yh), fig_e);
fig_f = compose(context(),
        subcoord.(x0,y0)... );
```


![](compose_6_1.png)


in which, `x0,y0,xw,yh` defines the position of the sub-coordinate system `context(x0,y0,xw,yh)` in `context()`'s space. 
The default x, y range of `context(x0,y0,xw,yh)` is [0,1], and you can redefine it by adding the `;units=UnitBox()` kwarg. 
`circle(xs, ys, rs)` in `fig_e`, is plotted in `context(x0,y0,xw,yh)`, in which, `xs`, `ys`, and radius `rs` define the three circles in `context(x0,y0,xw,yh)`.

If you redefine the scale of the coordinate system of `subcoord`, for example, that x, y coordinates ranges changed to [0,2], and `xs`, `ys`, and radius `rs` spans less portion of the axes of larger scale, they look smaller:
```julia
subcoord(x0,y0) = (context(x0,y0,xw,yh;units=UnitBox(0,0,2,2)), fig_e);
fig_g = compose(context(),
        subcoord.(x0,y0)... );
```


![](compose_8_1.png)



Here is the overview of `fig_e`, `fig_f`, `fig_g`:
```julia
h = 0.7;
w = 1/3;
box = (context(), rectangle(), fill(nothing),stroke("black"));
cap(str) = (context(), text(0.75,0.95,str),fill("black"));
compose(context(0.0,0.0,1.0,h), 
         (context(0.0,0.0,w,h), cap("fig_e"), fig_e, box), 
		 (context(1/3,0.0,w,h), cap("fig_f"), fig_f, box),
		 (context(2/3,0.0,w,h), cap("fig_g"), fig_g, box))
```

![](compose_9_1.png)
