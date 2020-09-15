include("./ring_np_num.jl")


ϕ_res = 300
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

p_0 = (zeros(ϕ_res) .+ 0.1)
p_0 .-= cos.(1 * ϕ) * 0.03


configs = []
for n in [4, 8, 16]
    for b in 4.1:0.1:8
        push!(configs, Config_small(1, b, 0, π, n, 2, 1000, 100))
    end
end

run_multi_sims(configs, ϕ_res, p_0, "more_players_no_inc/")
