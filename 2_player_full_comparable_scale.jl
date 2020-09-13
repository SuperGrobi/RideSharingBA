include("./ring_np_num.jl")


ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

p_0 = (zeros(ϕ_res) .+ 0.1)
p_0 .-= cos.(1 * ϕ) * 0.03


configs = []

for c in 0:0.2:2
    for b in 0:0.2:4
        push!(configs, Config_small(1, b, c, π, 2, 2, 1000, 100))
    end
end

run_multi_sims(configs, ϕ_res, p_0, "2_player_full_comparable_scale/")
