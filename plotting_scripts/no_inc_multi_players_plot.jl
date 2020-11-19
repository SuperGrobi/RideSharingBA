using Plots
include("ring_np_num.jl")
include("average_detour.jl")
include("load_and_process.jl")

ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]



# 8 players
b8_low, s8_low, _ = load_run("more_players_no_inc_final/8_low/")
s8_low_widths = [simple_width(ϕ, p[:,end]) for p in s8_low]

b8_high, s8_high, _ = load_run("more_players_no_inc_final/8_high/")
s8_high_widths = [simple_width(ϕ, p[:,end]) for p in s8_high]



# 16 players
b16_low, s16_low, _ = load_run("more_players_no_inc_final/16_low/")
s16_low_widths = [simple_width(ϕ, p[:,end]) for p in s16_low]

b16_high, s16_high, _ = load_run("more_players_no_inc_final/16_high/")
s16_high_widths = [simple_width(ϕ, p[:,end]) for p in s16_high]



# 32 players
b32_low, s32_low, _ = load_run("more_players_no_inc_final/32_low/")
s32_low_widths = [simple_width(ϕ, p[:,end]) for p in s32_low]

b32_high, s32_high, _ = load_run("more_players_no_inc_final/32_high/")
s32_high_widths = [simple_width(ϕ, p[:,end]) for p in s32_high]



# 31 players
b31_low, s31_low, _ = load_run("more_players_no_inc_final/31_low/")
s31_low_widths = [simple_width(ϕ, p[:,end]) for p in s31_low]

b31_high, s31_high, _ = load_run("more_players_no_inc_final/31_high/")
s31_high_widths = [simple_width(ϕ, p[:,end]) for p in s31_high]


plot(b8_low, s8_low_widths, label="8 players",
    color=blue4,
    linewidth=1.8)

plot!(b16_low, s16_low_widths, label="16 players",
    color=purple4,
    linewidth=1.8)

plot!(b31_low, s31_low_widths, label="31 players",
    color=green4,
    linewidth=1.8)


plot!(b32_low, s32_low_widths, label="32 players",
    color=red5,
    linewidth=1.8)




plot!(b32_low, s32_low_widths, label="",
    color=red5,
    linewidth=1.8)


plot!(b31_low, s31_low_widths, label="",
    color=green4,
    linewidth=1.8)

plot!(b16_low, s16_low_widths, label="",
    color=purple4,
    linewidth=1.8)

plot!(b8_low, s8_low_widths, label="",
    color=blue4,
    linewidth=1.8)

plot!(b8_high, s8_high_widths, label="", marker=:o, ms=4,
markerstrokewidth=0.4,
linestyle=:dash,
color=blue4,
linewidth=1.8)


plot!(b16_high, s16_high_widths, label="", marker=:o, ms=4,
    markerstrokewidth=0.4,
    linestyle=:dash,
    color=purple4,
    linewidth=1.8)



fill32_x = [7.6:0.4:11.6;].+0.2
fill32_y = fill(s32_high_widths[1], length(collect(7:0.4:11.6)))
plot!(fill32_x, fill32_y, label="", marker=:o, ms=4,
    markerstrokewidth=0.4,
    linestyle=:dot,
    color=red5,
    linewidth=1.8)
plot!(b32_high[10:end], s32_high_widths[10:end], label="", marker=:o, ms=4,
    markerstrokewidth=0.4,
    linestyle=:dash,
    color=red5,
    linewidth=1.8)


fill31_x = [7.2:0.4:11.2;]
fill31_y = fill(s31_high_widths[1], length(collect(7:0.4:11.2)))
scatter!(fill31_x, fill31_y, label="", marker=:o, ms=4,
    markerstrokewidth=0.4,
    color=green4,
    linewidth=1.8)
plot!(b31_high[3:end], s31_high_widths[3:end], label="", marker=:o, ms=4,
    markerstrokewidth=0.4,
    linestyle=:dash,
    color=green4,
    linewidth=1.8)






fig = plot!(ylabel=L"sharing regime width $\theta$", xlabel="b", title=L"multiple players, $c=0$",
    framestyle=:box,
    xlims=(0,15),
    ylims=(0,2π),
    yticks=(0:π/2:2π, [L"0", L"\frac{\pi}{2}", L"\pi", L"\frac{3\pi}{2}", L"2\pi"]))

savefig(fig, "../writing/multi_player_no_inc.pdf")
