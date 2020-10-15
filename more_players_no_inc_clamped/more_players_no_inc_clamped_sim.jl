using Distributed
@everywhere include("../ring_np_num.jl")


@everywhere begin
    ϕ_res = 200
    ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

    p_0 = (zeros(ϕ_res) .+ 0.15)
    p_0 .-= cos.(1 * ϕ) * 0.03
end


configs = []
for n in [16]
    for b in 3.4:0.2:7
        push!(configs, Config_small(1, b, 0, π, n, 1.2, 1000, 200))
    end
end
wiggle_every = 10
run_multi_sims(configs, ϕ_res, p_0, wiggle_every, "")
