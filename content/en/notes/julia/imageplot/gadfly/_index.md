---
author: "Tsung-Hsi, Wu"
title: "A Brief Tutorial for Gadfly"
date: "2021-08-28"
linkTitle: "using Gadfly.jl"
---


Of course, we need:
```julia
using Gadfly
using DataFrames
```




> **⚠️Notice:**
> - If you're using `Weave.jl`, which render the figures depend on output png files, it is necessary to `using Cairo, Fontconfig` with Gadfly in order to output images in `png` format. For more information, see [this](https://discourse.julialang.org/t/im-not-able-to-use-gadfly-weave/47810/4).
> 
> **🐔Hint:**
> - When using `Gadfly.jl`, there are much more advantages to plot your data in the format of `DataFrame`. Thus in this tutorial, I mostly demonstrate how to format your data as `DataFrame` and plot them with Gadfly.





## Basics
`Gadfly.jl` also supports input arguments as arrays like what `Plots.jl` [see [this](http://gadflyjl.org/stable/tutorial/#Arrays) for more information], for example:
```julia
X=0.0:0.1:4;
set_default_plot_size(2cm, 8cm) # optional
plot(x = X, y = sin.(X), 
		Geom.line, # This is optional; default is `Geom.point`
		# you can specify both: `Geom.point, Geom.line` to plot line with data points
		Guide.xlabel("displacement"),
		Guide.title("A Sine Plot")
	)
```

![](using_gadfly_3_1.png)


> 🔰 Hints:
> - for more **geometries** other than `Geom.point`, `Geom.line`, see [here](http://gadflyjl.org/stable/gallery/geometries/#Geometries).

### Simple Multiple Layers
```julia
plot(x = X, y = sin.(X),color=["sin(x)"], Geom.point, Geom.line,
	layer(x=X, y=cos.(X), shape=[Shape.square], size=[4pt],
		Geom.point, Geom.line, color=["cos(x)"], linestyle=[:dash]),
	layer(x=X, y=exp.(-X), color=[colorant"firebrick1"],Geom.line,
		linestyle=[[8pt, 3pt, 2pt, 3pt]]), # short-long dashed line
	Guide.xlabel("displacement"),
	Guide.colorkey(title="function"), # "legend" title
	)
```

![](using_gadfly_4_1.png)


> 🔰 Hints:
> - specify named color with [non-standard string literals](https://docs.julialang.org/en/v1/manual/metaprogramming/#Non-Standard-String-Literals) `colorant`; e.g., `colorant"red"`.
> - all named color: see [here](http://juliagraphics.github.io/Colors.jl/stable/namedcolors/)

### Scale And Ticks
```julia
# create a 2D Gaussian distribution and a set of sample points:
using Distributions, LinearAlgebra
gauss2d = MvNormal(10*ones(2), Diagonal(ones(2)));
xy = rand(gauss2d, 10000);

set_default_plot_size(20cm, 8cm)
p1 = plot(x = xy[1,:], y = xy[2,:], Geom.histogram2d(xbincount=25, ybincount=25)
	 , Scale.x_log10
	)
	
p2 = plot(x = xy[1,:], y = xy[2,:], Geom.histogram2d(xbincount=25, ybincount=25)
	 , Scale.x_log10
	 , Scale.color_continuous(minvalue=1, maxvalue=10) # set color scale
	 , Scale.y_continuous(format=:scientific , minvalue=0 , maxvalue=20) # set y scale
	)
hstack(p1, p2)
```

![](using_gadfly_5_1.png)


> 🔰 Hints:
> - `x_` or `y_continuous` option `format` can be `:plain`, `:scientific`, `:engineering`, or `:auto`. 
> - See [Coninuous Scales](http://gadflyjl.org/stable/tutorial/#Continuous-Scales), and [Discrete Scales](http://gadflyjl.org/stable/tutorial/#Discrete-Scales)
> - Also go [here](http://gadflyjl.org/stable/gallery/scales/#Scales) to see all supported continuous and discrete scales for size, alpha, color, and etc.


## Multiple subplots with layers
### Prepare the data







Assuming you want to plot time (`T`) versus acceleration (`A`), velocity (`V`) and velocity with two kinds of damping (`Vc` and `Vv`).

Since Gadfly works especially great with `DataFrame` objects; so, 
firstly, create the Dataframe:
```julia
df_wide = DataFrame("time"=>T, "acceleration"=>A, "velocity"=>V, "velocity (with damping)"=> Vv);
```


```
A "wide" dataframe: 
┌─────┬───────┬──────────────┬──────────┬─────────────────────────┐
│ Row │  time │ acceleration │ velocity │ velocity (with damping) │
├─────┼───────┼──────────────┼──────────┼─────────────────────────┤
│   1 │  -1.0 │          0.0 │      0.0 │                     0.0 │
│   2 │ -0.99 │          0.0 │      0.0 │                     0.0 │
│   3 │ -0.98 │          0.0 │      0.0 │                     0.0 │
│ ... │   ... │          ... │      ... │                     ... │
│ 199 │  0.98 │          0.0 │      1.0 │               0.0190841 │
│ 200 │  0.99 │          0.0 │      1.0 │               0.0183207 │
│ ... │   ... │          ... │      ... │                     ... │
│ 399 │  2.98 │          0.0 │      1.0 │              5.43148e-6 │
│ 400 │  2.99 │          0.0 │      1.0 │              5.21422e-6 │
│ 401 │   3.0 │          0.0 │      1.0 │              5.00565e-6 │
└─────┴───────┴──────────────┴──────────┴─────────────────────────┘
(401 rows × 4 columns)
```






and convert it to "long" format:
```julia
# a long dataframe where the three variables are grouped by their column name
df_long = stack(df_wide, ["acceleration", "velocity", "velocity (with damping)"]);
```


```
The converted "long" dataframe: 
┌──────┬───────┬─────────────────────────┬────────────┐
│  Row │  time │                variable │      value │
├──────┼───────┼─────────────────────────┼────────────┤
│    1 │  -1.0 │            acceleration │        0.0 │
│    2 │ -0.99 │            acceleration │        0.0 │
│    3 │ -0.98 │            acceleration │        0.0 │
│  ... │   ... │                     ... │        ... │
│  600 │  0.98 │                velocity │        1.0 │
│  601 │  0.99 │                velocity │        1.0 │
│  ... │   ... │                     ... │        ... │
│ 1201 │  2.98 │ velocity (with damping) │ 5.43148e-6 │
│ 1202 │  2.99 │ velocity (with damping) │ 5.21422e-6 │
│ 1203 │   3.0 │ velocity (with damping) │ 5.00565e-6 │
└──────┴───────┴─────────────────────────┴────────────┘
(1203 rows × 3 columns)
```





### One subplot with three layers
Plotting the data _**by color**_ in one subplot, where the color is distinguished by the column `"variable"` (i.e., "acceleration", "velocity", or "velocity with damping"):

```julia
plot(df_long, x = "time", y="value", color="variable", Geom.line)
```

![](using_gadfly_13_1.png)


For more about layers, see [Gadfly/compositing](http://gadflyjl.org/stable/man/compositing/).
### Three subplots
Now we plot the 3 sets of data _**by group**_ in individual subplots respectively:
```julia
plot(df_long, x = "time", y="value", ygroup = "variable", 
     Geom.subplot_grid(Geom.line, free_y_axis=true))
```

![](using_gadfly_14_1.png)



What if I want plot another velocity with another damping, saying `Vc`? 
Firstly, following the same procedure in [Prepare the data](#prepare-the-data), create a dataframe having "time", "value", and **a "variable" column** saying that the data also belong to "velocity (with damping)":
```julia
df_vdamp2 = DataFrame("time"=> T, "value"=> Vc, "variable"=> "velocity (with damping)")
```


```
┌─────┬───────┬────────────┬─────────────────────────┐
│ Row │  time │      value │                variable │
├─────┼───────┼────────────┼─────────────────────────┤
│   1 │  -1.0 │        0.0 │ velocity (with damping) │
│   2 │ -0.99 │        0.0 │ velocity (with damping) │
│ ... │   ... │        ... │                     ... │
│ 200 │  0.99 │ 5.35058e-9 │ velocity (with damping) │
│ ... │   ... │        ... │                     ... │
│ 401 │   3.0 │ 5.35058e-9 │ velocity (with damping) │
└─────┴───────┴────────────┴─────────────────────────┘
(401 rows × 3 columns)
```



```julia
# Gadfly.push_theme(style(line_style=[:solid])); # seems not required
plot(df_long, x = "time", y="value", ygroup = "variable", 
     Geom.subplot_grid(
        layer(Geom.line), # layer 1: df_long
        layer(df_vdamp2, x = "time", y="value", ygroup = "variable",
        Geom.line, style(line_style=[:dot])),
        free_y_axis=true)
	)
```

![](using_gadfly_17_1.png)
```julia
# Gadfly.push_theme(style(line_style=[:solid])); # seems not required
plot(Geom.subplot_grid(
	layer(df_long, ygroup = "variable", x="time", y="value", #color="color", 
			Geom.line)
	,layer(df_vdamp2, ygroup = "variable", x="time", y="value", #color="color", 
			Geom.line,style(line_style=[:dot]))
	,free_y_axis=true
	)
    ,Guide.ylabel("Y")
)
```

![](using_gadfly_18_1.png)


For more about subplots, see [Gallery_Geom.subplot_grid](http://gadflyjl.org/stable/gallery/geometries/#Gallery_Geom.subplot_grid) and [Compositing](http://gadflyjl.org/stable/man/compositing/).
