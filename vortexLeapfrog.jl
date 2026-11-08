using Plots

# start distances
startRingRadius = 0.5
startAdjacentDisance = 1
stepTime = 0.01
n_steps = 3000
# 4 position varables
P1 = [0.0, -startRingRadius]
P2 = [0.0, startRingRadius]
P3 = [startAdjacentDisance, -startRingRadius]
P4 = [startAdjacentDisance, startRingRadius]
# constant circulation 
circu = [-1, 1, -1, 1]

# veolocity function 
function velocity(self, other, num)
    dy = (self[2] - other[2])
    dx = (self[1] - other[1])
    rsq = dx^2 + dy^2
    vx = - circu[num] * dy / (2 * pi * rsq)
    vy = circu[num] * dx / (2 * pi * rsq)
    return [vx, vy]
end

# displacement function
function displacement(self, effectVelocity, dtime)
    return self + (effectVelocity * dtime)
end

# simlation loop
trajectory = []
for t in 1:n_steps
    global P1, P2, P3, P4
    
    v1 = velocity(P1, P2, 2) + velocity(P1, P3, 3) + velocity(P1, P4, 4)
    v2 = velocity(P2, P1, 1) + velocity(P2, P3, 3) + velocity(P2, P4, 4)
    v3 = velocity(P3, P1, 1) + velocity(P3, P2, 2) + velocity(P3, P4, 4)
    v4 = velocity(P4, P1, 1) + velocity(P4, P2, 2) + velocity(P4, P3, 3)

    P1 = displacement(P1, v1, stepTime)
    P2 = displacement(P2, v2, stepTime)
    P3 = displacement(P3, v3, stepTime)
    P4 = displacement(P4, v4, stepTime)

    push!(trajectory, [P1, P2, P3, P4])
end

# plot the trajectory
x1 = [trajectory[t][1][1] for t in 1:n_steps]
y1 = [trajectory[t][1][2] for t in 1:n_steps]
x2 = [trajectory[t][2][1] for t in 1:n_steps]
y2 = [trajectory[t][2][2] for t in 1:n_steps]
x3 = [trajectory[t][3][1] for t in 1:n_steps]
y3 = [trajectory[t][3][2] for t in 1:n_steps]
x4 = [trajectory[t][4][1] for t in 1:n_steps]
y4 = [trajectory[t][4][2] for t in 1:n_steps]

plt = plot(
    title = "Point Vortex Leapfrogging Trajectories",
    xlabel = "x position",
    ylabel = "y position",
    aspect_ratio = :equal,
    legend = :outertopright,
    grid = true
)

plot!(plt, x1, y1, label="P1 (Rear Bottom)",   color=:blue,   lw=1.8)
plot!(plt, x2, y2, label="P2 (Rear Top)",      color=:cyan,   lw=1.8)
plot!(plt, x3, y3, label="P3 (Front Bottom)",  color=:orange, lw=1.8)
plot!(plt, x4, y4, label="P4 (Front Top)",     color=:red,    lw=1.8)
scatter!(plt, [x1[1], x2[1], x3[1], x4[1]], [y1[1], y2[1], y3[1], y4[1]], 
         label="Start", color=:black, markersize=5, shape=:circle)
scatter!(plt, [x1[end], x2[end], x3[end], x4[end]], [y1[end], y2[end], y3[end], y4[end]], 
         label="End", color=:black, markersize=5, shape=:diamond)

display(plt)
savefig("leapfrog_plot.png")
