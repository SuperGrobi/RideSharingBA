using Distributed
@everywhere include("../../../ring_np_num.jl")


@everywhere begin
    n = 32
    c = 1.0
    ϕ_res = 200
    ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

    p_0 = (zeros(ϕ_res) .+ 0.15)
    p_0 .-= cos.(1 * ϕ) * 0.03
end

configs = []
for b in 0.4:0.4:4
    push!(configs, Config_small(1, b, c, π, n, 6/b, 1000, 300))
end

smooth_every = 10
kernel_length = 41

reverse!(configs)
# create long simulation object
seed_config = configs[1]
seed_config.steps = 1000

println("################### seed simulation ###################")
seed_prob = solve_time_evolution(p_0, ϕ, seed_config, smooth_every, kernel_length)
p_track_start = seed_prob[1][:,end]

# reset seed config
configs[1].steps = configs[2].steps

println("################### starting multi sim ###################")
run_multi_track(configs, ϕ_res, p_track_start, smooth_every, kernel_length, "$(n)_low/")

println("################### small b_explicit ###################")

s_b_conf = Config_small(1, 0.1, c, π, n, 14, 1000, 300)
small_b = solve_time_evolution(p_0, ϕ, s_b_conf, smooth_every, kernel_length)
save_sim(small_b, s_b_conf, "$(n)_low/")
