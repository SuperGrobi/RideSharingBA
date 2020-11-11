using Distributed
@everywhere include("../../../ring_np_num.jl")


@everywhere begin
    n = 15
    c = 0.2
    ϕ_res = 200
    ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

    p_0 = (zeros(ϕ_res) .+ 0.9)
    p_0 .-= cos.(1 * ϕ) * 0.03
end

configs = []
for b in 4:0.4:6
    push!(configs, Config_small(1, b, c, π, n, 6/b, 1000, 300))
end

smooth_every = 10
kernel_length = 41


println("################### starting multi sim ###################")
run_multi_sims(configs, ϕ_res, p_0, smooth_every, kernel_length, "$(n)_high/")
