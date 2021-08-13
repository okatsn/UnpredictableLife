
# using Gadfly
using DataFrames


using QuadGK
using GeneralTools


sigma = 0.01;
mu = 0.0;
# define the acceleration as a function of normal distribution:
fn(x) = (sigma*sqrt(2*pi))^-1 * exp(-0.5*((x-mu)/sigma)^2)


T = -1.0:0.01:3.0; # define x domain
A = fn.(T);


function rsign(v) # sign with tolerance
	tol = 10^-5
	if -tol < v < tol
		absv = 0.0;
	else
		absv = sign(v);
	end
	return absv
end

# Define damping
Fc = 2.0;
Fv = 4.0; 
# Calculate integration of A
I_E = quadgk.(fn,minimum(T),collect(T)[2:end]); # (I, E)
v0 = 0.0;
vc = copy(v0);
vv = copy(v0);
V = Float64[v0];
Vc = copy(V);
Vv = copy(V);
dts = diff(T);


for (index, value) in enumerate(I_E)
	global vc, vv
	dt = dts[index];
	push!(V, value[1]);
	
	vc = vc + A[index]*dt - Fc*rsign(vc)*dt;
	vv = vv + A[index]*dt - Fv*vv*dt;
	push!(Vc, vc);
	push!(Vv, vv);
end
(V, Vc, Vv)


df_wide = DataFrame("time"=>T, "acceleration"=>A, "velocity"=>V, "velocity (with damping)"=> Vc);


println("""A "wide" dataframe: """);
preview(df_wide,10);


# a long dataframe where the three variables are grouped by their column name
df_long = stack(df_wide, ["acceleration", "velocity", "velocity (with damping)"]);


println("""The converted "long" dataframe: """);
preview(df_long,10)


plot(df_long, x = "time", y="value", color="variable", Geom.line)

