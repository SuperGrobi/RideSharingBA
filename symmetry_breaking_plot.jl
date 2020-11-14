using Plots
using Plots.PlotMeasures
using LaTeXStrings
pyplot()
include("ring_np_num.jl")
include("load_and_process.jl")
include("colors.jl")


#=
conf = [Config_small(1, 8, 0, π, 2, 2, 1000+i, 100) for i in 1:9]

run_multi_sims(conf, 200, 0.1, 10000, 41, "plotting_stuff/breaking_2p/")
=#

b_array, s_array, _ = load_run("plotting_stuff/breaking_2p/", false)

all_images = heatmap.(s_array, colorbar=false, framestyle=:box, axis=false)
for i in [1,4,7]
    yticks!(all_images[i], 0:100:200, latexstring.([L"0", L"\pi", L"2\pi"]))
    ylabel!(all_images[i], "direction")
    yaxis!(all_images[i], true)
end

for i in [7,8,9]
    xticks!(all_images[i], 0:50:100, latexstring.(0:50:100))
    xlabel!(all_images[i], "timesteps")
    xaxis!(all_images[i], true)
end


p1 = plot(all_images..., layout=(3,3))

c1 = scatter([0,0], [0,1], zcolor=[0,1], clims=(0,1),
             xlims=(1,10), axis=false, label="", grid=false)


# savefig(p1, "test.png")

layout_upper = @layout [grid(1,1) b{0.8w}]
p_upper = plot(layout=layout_upper)
plot!(p_upper, subplot=2, rand(19), left_margin=-50mm, right_margin=100mm)
plot!(p_upper, subplot=1, rand(19), left_margin=50mm)

s_show = s_array[6]

ϕ = LinRange(0, 2π, 200)
p3 = plot(ϕ, s_show[:, [1, 5, 10, end]],
    labels=[L"t=0" L"t=5" L"t=10" L"t=100"],
    c=[blue6 blue4 blue3 blue1],
    lw=[1 1 1 3],
    xlims=(0, 2π),
    ylims=(0,1.001),
    xticks=(0:π/2:2π, [L"0", L"\frac{\pi}{2}", L"\pi", L"\frac{3\pi}{2}", L"2\pi"]),
    yticks=(0:0.25:1, latexstring.(0:0.25:1)),
    title=L"sage $te$")

final_layout = @layout [a{0.7h}; b]

fig_final = plot(p_upper, p3, layout=final_layout)

plot(rand(122), color="#111111")

savefig(fig_final, "../writing/simulation_2_player_overview.png")
