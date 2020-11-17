using Plots
using LaTeXStrings
using Plots.PlotMeasures
using Distributed
include("ring_np_num.jl")
include("colors.jl")



# uncomment this if you want simulations.
#=
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
=#

n = 16
conf_low = Config_small(1, 6.5, 0, π, n, 1, 1000, 200)  # low games per destination
conf_high = Config_small(1, 6.5, 0, π, n, 1, 10000, 200)  # high games per destination

ϕ_low_res = 200
ϕ_high_res = 400

ϕ_low = LinRange(0,2π, ϕ_low_res+1)[1:end-1]
ϕ_high = LinRange(0,2π, ϕ_high_res+1)[1:end-1]


p_end_default = load_sim("plotting_stuff/convergence_default.jld2")[1][1]
p_end_high_res = load_sim("plotting_stuff/convergence_high_res.jld2")[1][1]
p_end_high_games = load_sim("plotting_stuff/convergence_high_games.jld2")[1][1]
p_end_high_res_high_games = load_sim("plotting_stuff/convergence_high_games_high_res.jld2")[1][1]

p1 = heatmap(p_end_default, title = "200 nodes, 1000 games",
    cbar=false,
    ylabel="direction",
    yticks=(LinRange(0,200,5), [L"0", L"\frac{\pi}{2}", L"\pi", L"\frac{3\pi}{2}", L"2\pi"]))
p2 = heatmap(p_end_high_res, title = "400 nodes, 1000 games",
    cbar=false,
    yticks=:none)
p3 = heatmap(p_end_high_games, title = "200 nodes, 10000 games",
    cbar=false,
    yticks=:none)
p4 = heatmap(p_end_high_res_high_games, title = "400 nodes, 10000 games",
    yticks=:none,
    right_margin=25mm,
    colorbar_title=L"p_{share}")

p5 = plot(ϕ_low, circshift(p_end_default[:,end], -3), label = "200 nodes, 1000 games",
    linewidth=2,
    color=blue5)
plot!(p5, ϕ_high, circshift(p_end_high_res[:,end], 1), label = "400 nodes, 1000 games",
    linewidth=2,
    color=red5)
plot!(p5, ϕ_low, p_end_high_games[:,end], label = "200 nodes, 10000 games",
    linewidth=2,
    color=purple5)
plot!(p5, ϕ_high, p_end_high_res_high_games[:,end], label = "400 nodes, 10000 games",
    linewidth=2,
    color=yellow5)
plot!(p5, title="equilibrium sharing adoption",
    xlims=(0,2π),
    xticks=(0:π/2:2π, [L"0", L"\frac{\pi}{2}", L"\pi", L"\frac{3\pi}{2}", L"2\pi"]),
    ylims=(0,1.001),
    yticks=(0:0.25:1, latexstring.(0:0.25:1)),
    xlabel="direction",
    ylabel=L"p_{share}")

line1 = plot(p1, p2, p3, p4, layout = (1,4), xlabel="timesteps",
    xticks=(50:50:200, latexstring.(50:50:200)),
left_margin=10mm)
fig = plot(line1, p5, layout=(2,1), size = (1500, 700), framestyle=:box, dpi=400)
savefig(fig, "../writing/convergence_more_res_games.png")
