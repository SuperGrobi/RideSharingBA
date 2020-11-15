using Plots
using LaTeXStrings
using Plots.PlotMeasures
pyplot()
include("ring_np_num.jl")
p_0 = load_sim("2_player_no_inc/a=1.0_b=3.0_c=0.0_angCut=3.141592653589793_Pc=2_dt=3.0_games=1000_steps=100.jld2")
p_1 = load_sim("plotting_stuff/a=1.0_b=5.0_c=0.0_Pc=16_old.jld2")
p_2 = load_sim("plotting_stuff/a=1.0_b=5.0_c=0.0_Pc=16_new.jld2")

f1 = heatmap(p_0[1][1], title = "two players", cbar=false,
    framestyle=:box,
    ylabel="direction",
    xticks=(0:50:100, latexstring.(0:50:100)),
    yticks = (LinRange(0,200,5), [L"0", L"\frac{\pi}{2}", L"\pi", L"\frac{3\pi}{2}", L"2\pi"]))

f2 = heatmap(p_1[1][1], title = "16 players, without smoothing", cbar=false,
    framestyle=:box,
    xticks=(0:50:200, latexstring.(0:50:200)),
    yticks=:none)
f3 = heatmap(p_2[1][1], title="16 players, with smoothing",
    framestyle=:box,
    xticks=(0:50:200, latexstring.(0:50:200)),
    yticks=:none)


fig = plot(f1, f2,f3, layout=(1,3), xlabel="timesteps", size=(1200, 400), right_margin=15mm, dpi=500)
savefig(fig, "../writing/convergence_problem_multi_player.png")
