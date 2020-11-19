using Plots
using LaTeXStrings
include("ring_np_num.jl")
include("average_detour.jl")
include("load_and_process.jl")
include("colors.jl")


ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

Θ = 2π:-0.2:1

# b8_theo = get_b.(8, Θ, 0, 100000, 200)
# b16_theo = get_b.(16, Θ, 0, 100000, 200)
# b31_theo = get_b.(31, Θ, 0, 100000, 200)
# b32_theo = get_b.(32, Θ, 0, 100000, 200)

# 16 players
b16_low, s16_low, _ = load_run("more_players_no_inc_final/16_low/")
s16_low_widths = [simple_width(ϕ, p[:,end]) for p in s16_low]

b16_high, s16_high, _ = load_run("more_players_no_inc_final/16_high/")
s16_high_widths = [simple_width(ϕ, p[:,end]) for p in s16_high]


p1 = plot(b8_low, s8_low_widths, label="simulation",
    color=blue4,
    linewidth=1.8)
vline!(p1, [b8_theo[1]], label="", color=:black, alpha=0.4, linewidth=1.8, linestyle=:dash)
plot!(p1, b8_high, s8_high_widths, label="",
color=blue4,
linestyle=:dash,
linewidth=1.8)
plot!(p1, b8_theo, Θ, label="theory",
    color=:black, alpha=0.4, linewidth=1.8)
plot!(p1, xlim=(2,7),
    ylims=(0,2π),
    yticks=(0:π/2:2π, [L"0", L"\frac{\pi}{2}", L"\pi", L"\frac{3\pi}{2}", L"2\pi"]),
    title="8 players", ylabel=L"sharing regime width $\theta$")


# 16 players
b16_low, s16_low, _ = load_run("more_players_no_inc_final/16_low/")
s16_low_widths = [simple_width(ϕ, p[:,end]) for p in s16_low]

b16_high, s16_high, _ = load_run("more_players_no_inc_final/16_high/")
s16_high_widths = [simple_width(ϕ, p[:,end]) for p in s16_high]

p2 = plot(b16_low, s16_low_widths, label="simulation",
    color=purple4,
    linewidth=1.8)
vline!(p2, [b16_theo[1]], label="", color=:black, alpha=0.4, linewidth=1.8, linestyle=:dash)

plot!(p2, b16_high, s16_high_widths, label="",
color=purple4,
linestyle=:dash,
linewidth=1.8)
plot!(p2, b16_theo, Θ, label="theory",
    color=:black, alpha=0.4, linewidth=1.8)
plot!(p2, xlim=(4, 9), title="16 players",
    ylims=(0,2π), yticks=(0:π/2:2π, fill("", 5)))



# 31 players
b31_low, s31_low, _ = load_run("more_players_no_inc_final/31_low/")
s31_low_widths = [simple_width(ϕ, p[:,end]) for p in s31_low]

b31_high, s31_high, _ = load_run("more_players_no_inc_final/31_high/")
s31_high_widths = [simple_width(ϕ, p[:,end]) for p in s31_high]
pushfirst!(b31_high, 1)
pushfirst!(s31_high_widths, 2π)

p4 = plot(b31_low, s31_low_widths, label="simulation",
    color=green4,
    linewidth=1.8)
vline!(p4, [b31_theo[1]], label="", color=:black, alpha=0.4, linewidth=1.8, linestyle=:dash)

plot!(p4, b31_high, s31_high_widths, label="",
color=green4,
linestyle=:dash,
linewidth=1.8)
plot!(p4, b31_theo, Θ, label="theory",
    color=:black, alpha=0.4, linewidth=1.8)
plot!(p4, xlim=(6, 15), title="31 players", ylims=(0,2π), yticks=(0:π/2:2π, fill("", 5)))







# 32 players
b32_low, s32_low, _ = load_run("more_players_no_inc_final/32_low/")
s32_low_widths = [simple_width(ϕ, p[:,end]) for p in s32_low]

b32_high, s32_high, _ = load_run("more_players_no_inc_final/32_high/")
s32_high_widths = [simple_width(ϕ, p[:,end]) for p in s32_high]
pushfirst!(b32_high, 1)
pushfirst!(s32_high_widths, 2π)

p3 = plot(b32_low, s32_low_widths, label="simulation",
    color=red4,
    linewidth=1.8)
vline!(p3, [b32_theo[1]], label="", color=:black, alpha=0.4, linewidth=1.8, linestyle=:dash)

plot!(p3, b32_high, s32_high_widths, label="",
color=red4,
linestyle=:dash,
linewidth=1.8)
plot!(p3, b32_theo, Θ, label="theory",
    color=:black, alpha=0.4, linewidth=1.8)
plot!(p3, xlim=(6, 15), title="32 players", ylims=(0,2π), yticks=(0:π/2:2π, fill("", 5)))


plot(p1, p2, p3, p4, layout=(1,4), framestyle=:box)
fig = plot!(xlabel=L"b", size=(1300, 400))
savefig(fig, "../writing/more_players_no_inc_comparison_theory.pdf")
