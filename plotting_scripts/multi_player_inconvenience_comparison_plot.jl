using Plots
using LaTeXStrings
pyplot()
include("ring_np_num.jl")
include("average_detour.jl")
include("colors.jl")
include("load_and_process.jl")

ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]
theo_games = 20000
Θ = 2π:-0.2:1

##############################################################
# 8 players
begin
    # 8 players, inconvenience 0
    b8_low, s8_low, _ = load_run("more_players_no_inc_final/8_low/")
    s8_low_widths = [simple_width(ϕ, p[:,end]) for p in s8_low]

    b8_high, s8_high, _ = load_run("more_players_no_inc_final/8_high/")
    s8_high_widths = [simple_width(ϕ, p[:,end]) for p in s8_high]


    # 8 players, inconvenience 0.2
    b8_c02_low, s8_c02_low, _ = load_run("more_players_with_inc/8p/c=0.2/8_low/")
    s8_c02_low_widths = [simple_width(ϕ, p[:,end]) for p in s8_c02_low]

    b8_c02_high, s8_c02_high, _ = load_run("more_players_with_inc/8p/c=0.2/8_high/")
    s8_c02_high_widths = [simple_width(ϕ, p[:,end]) for p in s8_c02_high]


    # 8 players, inconvenience 0.6
    b8_c06_low, s8_c06_low, _ = load_run("more_players_with_inc/8p/c=0.6/8_low/")
    s8_c06_low_widths = [simple_width(ϕ, p[:,end]) for p in s8_c06_low]

    b8_c06_high, s8_c06_high, _ = load_run("more_players_with_inc/8p/c=0.6/8_high/")
    s8_c06_high_widths = [simple_width(ϕ, p[:,end]) for p in s8_c06_high]


    # 8 players, inconvenience 1
    b8_c1_low, s8_c1_low, _ = load_run("more_players_with_inc/8p/c=1/8_low/")
    s8_c1_low_widths = [simple_width(ϕ, p[:,end]) for p in s8_c1_low]

    b8_c1_high, s8_c1_high, _ = load_run("more_players_with_inc/8p/c=1/8_high/")
    s8_c1_high_widths = [simple_width(ϕ, p[:,end]) for p in s8_c1_high]

    # theory
    crit8_0 = get_b(8, 2π, 0, theo_games, 200)
    crit8_02 = get_b(8, 2π, 0.2, theo_games, 200)
    crit8_06 = get_b(8, 2π, 0.6, theo_games, 200)
    crit8_1 = get_b(8, 2π, 1, theo_games, 200)

    p1 = vline([crit8_0, crit8_02, crit8_06, crit8_1], color=:black, alpha=0.4, linewidth=1.8, linestyle=:dash, label=L"b_{crit}")


    plot!(p1, b8_low, s8_low_widths, label=L"c=0", color=blue4, lw=1.8)
    plot!(p1, b8_high, s8_high_widths, label="", color=blue4, linestyle=:dash, lw=1.8)

    plot!(p1, b8_c02_low, s8_c02_low_widths, label=L"c=0.2", color=blue3, lw=1.8)
    plot!(p1, b8_c02_high, s8_c02_high_widths, label="", color=blue3, linestyle=:dash, lw=1.8)


    plot!(p1, b8_c06_low, s8_c06_low_widths, label=L"c=0.6", color=blue2, lw=1.8)
    plot!(p1, b8_c06_high, s8_c06_high_widths, label="", color=blue2, linestyle=:dash, lw=1.8)


    plot!(p1, b8_c1_low, s8_c1_low_widths, label=L"c=1", color=blue1, lw=1.8)
    plot!(p1, b8_c1_high, s8_c1_high_widths, label="", color=blue1, linestyle=:dash, lw=1.8)


    plot!(p1, xlim=(0, :auto), title="8 players",
    ylims=(0,2π),
    ylabel=L"sharing regime width $\theta$",
    yticks=(0:π/2:2π, [L"0", L"\frac{\pi}{2}", L"\pi", L"\frac{3\pi}{2}", L"2\pi"]))
end
##############################################################
# 16 players
begin
    # 16 players, inconvenience 0
    b16_low, s16_low, _ = load_run("more_players_no_inc_final/16_low/")
    s16_low_widths = [simple_width(ϕ, p[:,end]) for p in s16_low]

    b16_high, s16_high, _ = load_run("more_players_no_inc_final/16_high/")
    s16_high_widths = [simple_width(ϕ, p[:,end]) for p in s16_high]


    # 16 players, inconvenience 0.2
    b16_c02_low, s16_c02_low, _ = load_run("more_players_with_inc/16p/c=0.2/16_low/")
    s16_c02_low_widths = [simple_width(ϕ, p[:,end]) for p in s16_c02_low]

    b16_c02_high, s16_c02_high, _ = load_run("more_players_with_inc/16p/c=0.2/16_high/")
    s16_c02_high_widths = [simple_width(ϕ, p[:,end]) for p in s16_c02_high]


    # 16 players, inconvenience 0.6
    b16_c06_low, s16_c06_low, _ = load_run("more_players_with_inc/16p/c=0.6/16_low/")
    s16_c06_low_widths = [simple_width(ϕ, p[:,end]) for p in s16_c06_low]

    b16_c06_high, s16_c06_high, _ = load_run("more_players_with_inc/16p/c=0.6/16_high/")
    s16_c06_high_widths = [simple_width(ϕ, p[:,end]) for p in s16_c06_high]



    # 16 players, inconvenience 1
    b16_c1_low, s16_c1_low, _ = load_run("more_players_with_inc/16p/c=1/16_low/")
    s16_c1_low_widths = [simple_width(ϕ, p[:,end]) for p in s16_c1_low]

    b16_c1_high, s16_c1_high, _ = load_run("more_players_with_inc/16p/c=1/16_high/")
    s16_c1_high_widths = [simple_width(ϕ, p[:,end]) for p in s16_c1_high]

    # theory
    crit16_0 = get_b(16, 2π, 0, theo_games, 200)
    crit16_02 = get_b(16, 2π, 0.2, theo_games, 200)
    crit16_06 = get_b(16, 2π, 0.6, theo_games, 200)
    crit16_1 = get_b(16, 2π, 1, theo_games, 200)

    p2 = vline([crit16_0, crit16_02, crit16_06, crit16_1], color=:black, alpha=0.4, linewidth=1.8, linestyle=:dash, label=L"b_{crit}")

    plot!(p2, b16_low, s16_low_widths, label=L"c=0", color=purple4, lw=1.8)
    plot!(p2, b16_high, s16_high_widths, label="", color=purple4, linestyle=:dash, lw=1.8)


    plot!(p2, b16_c02_low, s16_c02_low_widths, label=L"c=0.2", color=purple3, lw=1.8)
    plot!(p2, b16_c02_high, s16_c02_high_widths, label="", color=purple3, linestyle=:dash, lw=1.8)


    plot!(p2, b16_c06_low, s16_c06_low_widths, label=L"c=0.6", color=purple2, lw=1.8)
    plot!(p2, b16_c06_high, s16_c06_high_widths, label="", color=purple2, linestyle=:dash, lw=1.8)


    plot!(p2, b16_c1_low, s16_c1_low_widths, label=L"c=1", color=purple1, lw=1.8)
    plot!(p2, [0.1; 0.4; 0.79; b16_c1_high], [2π; 4.95; π+0.6; s16_c1_high_widths], label="", color=purple1, linestyle=:dash, lw=1.8)

    plot!(p2, xlim=(0, :auto), title="16 players",
    ylims=(0, 2π), yticks=(0:π/2:2π, fill("", 5)))
end
##############################################################
#32 players
begin
    # 32 players, inconvenience 0
    b32_low, s32_low, _ = load_run("more_players_no_inc_final/32_low/")
    s32_low_widths = [simple_width(ϕ, p[:,end]) for p in s32_low]

    b32_high, s32_high, _ = load_run("more_players_no_inc_final/32_high/")
    s32_high_widths = [simple_width(ϕ, p[:,end]) for p in s32_high]


    # 32 players, inconvenience 0.2
    b32_c02_low, s32_c02_low, _ = load_run("more_players_with_inc/32p/c=0.2/32_low/")
    s32_c02_low_widths = [simple_width(ϕ, p[:,end]) for p in s32_c02_low]

    b32_c02_high, s32_c02_high, _ = load_run("more_players_with_inc/32p/c=0.2/32_high/")
    s32_c02_high_widths = [simple_width(ϕ, p[:,end]) for p in s32_c02_high]


    # 32 players, inconvenience 0.6
    b32_c06_low, s32_c06_low, _ = load_run("more_players_with_inc/32p/c=0.6/32_low/")
    s32_c06_low_widths = [simple_width(ϕ, p[:,end]) for p in s32_c06_low]

    b32_c06_high, s32_c06_high, _ = load_run("more_players_with_inc/32p/c=0.6/32_high/")
    s32_c06_high_widths = [simple_width(ϕ, p[:,end]) for p in s32_c06_high]


    # 32 players, inconvenience 1
    b32_c1_low, s32_c1_low, _ = load_run("more_players_with_inc/32p/c=1/32_low/")
    s32_c1_low_widths = [simple_width(ϕ, p[:,end]) for p in s32_c1_low]

    b32_c1_high, s32_c1_high, _ = load_run("more_players_with_inc/32p/c=1/32_high/")
    s32_c1_high_widths = [simple_width(ϕ, p[:,end]) for p in s32_c1_high]

    # theory
    crit32_0 = get_b(32, 2π, 0, theo_games, 200)
    crit32_02 = get_b(32, 2π, 0.2, theo_games, 200)
    crit32_06 = get_b(32, 2π, 0.6, theo_games, 200)
    crit32_1 = get_b(32, 2π, 1, theo_games, 200)

    p3 = vline([crit32_0, crit32_02, crit32_06, crit32_1], color=:black, alpha=0.4, linewidth=1.8, linestyle=:dash, label=L"b_{crit}")



    plot!(p3, b32_low, s32_low_widths, label=L"c=0", color=red4, lw=1.8)
    plot!(p3, [0; b32_high], [s32_high_widths[1]; s32_high_widths], label="", color=red4, linestyle=:dash, lw=1.8)

    plot!(p3, b32_c02_low, s32_c02_low_widths, label=L"c=0.2", color=red3, lw=1.8)
    plot!(p3, b32_c02_high, s32_c02_high_widths, label="", color=red3, linestyle=:dash, lw=1.8)

    plot!(p3, b32_c06_low, s32_c06_low_widths, label=L"c=0.6", color=red2, lw=1.8)
    plot!(p3, b32_c06_high, s32_c06_high_widths, label="", color=red2, linestyle=:dash, lw=1.8)

    plot!(p3, b32_c1_low, s32_c1_low_widths, label=L"c=1", color=red1, lw=1.8)
    plot!(p3, b32_c1_high, s32_c1_high_widths, label="", color=red1, linestyle=:dash, lw=1.8)

    plot!(p3, xlim=(0, :auto), title="32 players",
        ylims=(0,2π), yticks=(0:π/2:2π, fill("", 5)))
end
##############################################################

plot(p1, p2, p3, layout=(1,3))
fig = plot!(xlabel=L"b", size=(1000, 400), framestyle=:box)
savefig(fig, "../writing/more_players_inconvenience_comparison.pdf")
