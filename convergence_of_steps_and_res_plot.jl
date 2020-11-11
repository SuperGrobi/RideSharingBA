using Plots
using Distributed

@everywhere begin
    n = 16
    conf_low = Config_small(1, 6.5, 0, π, n, 1, 1000, 200)  # low games per destination
    conf_high = Config_small(1, 6.5, 0, π, n, 1, 10000, 200)  # high games per destination

    ϕ_low_res = 200
    ϕ_high_res = 400

    ϕ_low = LinRange(0,2π, ϕ_low_res+1)[1:end-1]
    ϕ_high = LinRange(0,2π, ϕ_high_res+1)[1:end-1]

    p_low_res = (zeros(ϕ_low_res) .+ 0.15)
    p_low_res .-= cos.(1 * ϕ_low) * 0.03

    p_high_res = (zeros(ϕ_high_res) .+ 0.15)
    p_high_res .-= cos.(1 * ϕ_high) * 0.03
end

p_end_default = solve_time_evolution(p_low_res, ϕ_low, conf_low, 10, 41)
save_sim(p_end_default, conf_low, "plotting_stuff/")

p_end_high_res = solve_time_evolution(p_high_res, ϕ_high, conf_low, 10, 41)
save_sim(p_end_high_res, conf_low, "plotting_stuff/")

p_end_high_games = solve_time_evolution(p_low_res, ϕ_low, conf_high, 10, 41)
save_sim(p_end_high_games, conf_high, "plotting_stuff/")

p_end_high_res_high_games = solve_time_evolution(p_high_res, ϕ_high, conf_high, 10, 41)
save_sim(p_end_high_res_high_games, conf_high, "plotting_stuff/")



p_end_default = load_sim("plotting_stuff/convergence_default.jld2")[1][1]
p_end_high_res = load_sim("plotting_stuff/convergence_high_res.jld2")[1][1]
p_end_high_games = load_sim("plotting_stuff/convergence_high_games.jld2")[1][1]
p_end_high_res_high_games = load_sim("plotting_stuff/convergence_high_games_high_res.jld2")[1][1]

p1 = heatmap(p_end_default, title = "200 nodes, 1000 games")
p2 = heatmap(p_end_high_res, title = "400 nodes, 1000 games")
p3 = heatmap(p_end_high_games, title = "200 nodes, 10000 games")
p4 = heatmap(p_end_high_res_high_games, title = "400 nodes, 10000 games")

p5 = plot(ϕ_low, p_end_default[:,end], label = "200 nodes, 1000 games")
plot!(p5, ϕ_high, p_end_high_res[:,end], label = "400 nodes, 1000 games")
plot!(p5, ϕ_low, p_end_high_games[:,end], label = "200 nodes, 10000 games")
plot!(p5, ϕ_high, p_end_high_res_high_games[:,end], label = "400 nodes, 10000 games")


line1 = plot(p1, p2, p3, p4, layout = (1,4))
plot(line1, p5, layout=(2,1))
