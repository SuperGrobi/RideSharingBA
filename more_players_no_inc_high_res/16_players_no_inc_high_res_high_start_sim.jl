using Distributed
@everywhere include("../ring_np_num.jl")


@everywhere begin
    n = 16
    ϕ_res = 200
    ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

    p_0 = (zeros(ϕ_res) .+ 0.9)
    p_0 .-= cos.(1 * ϕ) * 0.03
end

configs = []
for b in 4:0.1:9
    push!(configs, Config_small(1, b, 0, π, n, 6/b, 1000, 300))
end

smooth_every = 10
kernel_length = 41


println("################### starting multi sim ###################")
run_multi_sims(configs, ϕ_res, p_0, smooth_every, kernel_length, "16_high/")

println("################### small b_explicit ###################")
s_b_conf = Config_small(1, 0.1, 0, π, n, 14, 1000, 300)
small_b = solve_time_evolution(p_0, ϕ, seed_config, smooth_every, kernel_length)
save_sim(small_b, s_b_conf, "16_high/")
