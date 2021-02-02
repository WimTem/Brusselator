using Catalyst, Plots, DiffEqBase, OrdinaryDiffEq

rn = @reaction_network begin
    k1, A → A + X
    k2, 2X + Y → 3X
    k3, B + X → B + Y + C
    k4, X → D
end k1 k2 k3 k4

p = (1., 1., 1., .65) #k1 k2 k3 k4 
tspan = (.0, 30.)
u0 = [1., 1., 1., 1.7, 1., 1.]   # A X Y B C D
osys  = convert(ODESystem, rn)
u0map = map((x,y) -> Pair(x,y), species(rn), u0)
pmap  = map((x,y) -> Pair(x,y), params(rn), p)
oprob = ODEProblem(osys, u0map, tspan, pmap)
sol   = solve(oprob, Rosenbrock23())

t = 0:30/length(sol):30

plot(sol[2,:], sol[3,:], lw=2)
savefig("phase_plot.png")

plot(t[1:end-1], sol[2,:], lw=2, label="X(t)")
plot!(t[1:end-1], sol[3,:], lw=2, label="Y(t)")
savefig("concentration.png")