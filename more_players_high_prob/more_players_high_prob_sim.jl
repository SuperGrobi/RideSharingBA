using Distributed
@everywhere include("./ring_np_num.jl")


@everywhere begin
ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

p_0 = (zeros(ϕ_res) .+ 0.8)
p_0 .-= cos.(1 * ϕ) * 0.03
end

@everywhere function multi_dev(conf, ϕ, p_0, folder)
    println("starting simulation with b = ", conf.b)
    p_end = solve_time_evolution(p_0, ϕ, conf)
    save_sim(p_end, conf, folder)
end

configs = []
for n in [16]
    for b in 4:0.2:8
        push!(configs, Config_small(1, b, 0, π, n, 1, 1000, 100))
    end
end

pmap(c->multi_dev(c, ϕ, p_0, "more_players_high_prob/"), configs)

#run_multi_sims(configs[9:end], ϕ_res, p_0, "more_players_high_prob/")
