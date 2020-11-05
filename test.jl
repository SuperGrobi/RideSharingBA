include("ring_np_num.jl")
include("load_and_process.jl")

using Plots

ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

n = 16  # well what are you going to do?
b = 6.4  # gathered from sim data (here the angle is about 2.827rad)

width_theo = 3.883
width_sim = 2.827

# create starting distribution acording to the theorie
p_width = floor(Int, width_sim / 2π * ϕ_res)
p = zeros(ϕ_res)
onset = floor(Int, (ϕ_res - p_width) / 2)
p[onset:onset+p_width] .= 1
p = (p .* 0.9) .+ 0.05

conf = Config_small(1, b, 0, π, n, 7/b, 1000, 400)

smooth_every = 10
kernel_length = 31

p_end = solve_time_evolution(p, ϕ, conf, smooth_every, kernel_length)

heatmap(p_end[1])

plot!(p_end[1][:,end])
plot!(p)


simple_width(ϕ, p_end[1][:,end], 0.8)
