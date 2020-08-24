include("./ring_np_num.jl")


ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

p_0 = (zeros(ϕ_res) .+ 0.1)
p_0 .-= cos.(1 * ϕ) * 0.03

config = Config(10, 0.1, 1.5, 0.1, 0.3, 5, 1, π, 2, 5, 1000, 50)

#config_small = Config_small(10, 1, 3, π, 4, 5, 1000, 10)
p_end = solve_time_evolution(p_0, ϕ, config)

plot_result([p_end; config])
