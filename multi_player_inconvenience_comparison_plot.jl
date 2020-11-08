using Plots
gr()
include("ring_np_num.jl")
include("average_detour.jl")
include("load_and_process.jl")

ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

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


    p1 = plot(b8_low, s8_low_widths, label="low start, c=0")
    plot!(p1, b8_high, s8_high_widths, label="high start, c=0")

    plot!(p1, b8_c02_low, s8_c02_low_widths, label="low start, c=0.2")
    plot!(p1, b8_c02_high, s8_c02_high_widths, label="high start, c=0.2")


    plot!(p1, b8_c06_low, s8_c06_low_widths, label="low start, c=0.6")
    plot!(p1, b8_c06_high, s8_c06_high_widths, label="high start, c=0.6")


    plot!(p1, b8_c1_low, s8_c1_low_widths, label="low start, c=1")
    plot!(p1, b8_c1_high, s8_c1_high_widths, label="high start, c=1")
    plot!(p1, xlim=(0, :auto), title="8 players")
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


    p2 = plot(b16_low, s16_low_widths, label="low start, c=0")
    plot!(p2, b16_high, s16_high_widths, label="high start, c=0")


    plot!(p2, b16_c02_low, s16_c02_low_widths, label="low start, c=0.2")
    plot!(p2, b16_c02_high, s16_c02_high_widths, label="high start, c=0.2")


    plot!(p2, b16_c06_low, s16_c06_low_widths, label="low start, c=0.6")
    plot!(p2, b16_c06_high, s16_c06_high_widths, label="high start, c=0.6")


    plot!(p2, b16_c1_low, s16_c1_low_widths, label="low start, c=1")
    plot!(p2, b16_c1_high, s16_c1_high_widths, label="high start, c=1")
    plot!(p2, xlim=(0, :auto), title="16 players")
end
##############################################################
#32 players
begin
    # 32 players, inconvenience 0
    b32_low, s32_low, _ = load_run("more_players_no_inc_final/32_low/")
    s32_low_widths = [simple_width(ϕ, p[:,end]) for p in s32_low]

    b32_high, s32_high, _ = load_run("more_players_no_inc_final/32_high/")
    s32_high_widths = [simple_width(ϕ, p[:,end]) for p in s32_high]


    # 32 players, inconvenience 1
    b32_c1_low, s32_c1_low, _ = load_run("more_players_with_inc/32p/c=1/32_low/")
    s32_c1_low_widths = [simple_width(ϕ, p[:,end]) for p in s32_c1_low]

    b32_c1_high, s32_c1_high, _ = load_run("more_players_with_inc/32p/c=1/32_high/")
    s32_c1_high_widths = [simple_width(ϕ, p[:,end]) for p in s32_c1_high]


    p3 = plot(b32_low, s32_low_widths, label="low start, c=0")
    plot!(p3, b32_high, s32_high_widths, label="high start, c=0")


    plot!(p3, b32_c1_low, s32_c1_low_widths, label="low start, c=1")
    plot!(p3, b32_c1_high, s32_c1_high_widths, label="high start, c=1")
    plot!(p3, xlim=(0, :auto), title="32 players")
end
##############################################################

plot(p1, p2, p3, layout=(1,3))
plot!(ylabel="theta", xlabel="b", size=(1000, 400))
