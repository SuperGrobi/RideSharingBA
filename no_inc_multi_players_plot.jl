using Plots
include("ring_np_num.jl")
include("average_detour.jl")
include("load_and_process.jl")

ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]
# 8 players
b8_low, s8_low, _ = load_run("more_players_no_inc_high_res/8_low/")
s8_low = shift_end_to_beginning.(s8_low);
s8_low_widths = [simple_width(ϕ, p[:,end]) for p in s8_low]
s8_low_widths[1] = 2π;

# 16 players
b16_low, s16_low, c16_low, _ = load_run("more_players_no_inc_high_res/16_low/")
#s16_low = shift_end_to_beginning.(s16_low);
s16_low_widths = [simple_width(ϕ, p[:,end]) for p in s16_low]
s16_low_widths[1] = 2π;

# 32 players
b32_low, s32_low, _ = load_run("more_players_no_inc_high_res/32_low/")
s32_low = shift_end_to_beginning.(s32_low);
s32_low_widths = [simple_width(ϕ, p[:,end]) for p in s32_low]
s32_low_widths[1] = 2π;

# 40 players
b40_low, s40_low, c40_low, _ = load_run("more_players_no_inc_high_res/40_low/")
s40_low = shift_end_to_beginning.(s40_low);
s40_low_widths = [simple_width(ϕ, p[:,end]) for p in s40_low]
s40_low_widths[1] = 2π;

# 48 players
b48_low, s48_low, _ = load_run("more_players_no_inc_high_res/48_low/")
s48_low = shift_end_to_beginning.(s48_low);
s48_low_widths = [simple_width(ϕ, p[:,end]) for p in s48_low]
s48_low_widths[1] = 2π;

# 56 players
#b56_low, s56_low, _ = load_run("more_players_no_inc_high_res/56_low/")
#s56_low = shift_end_to_beginning.(s56_low);
#s56_low_widths = [simple_width(ϕ, p[:,end]) for p in s56_low]
#s56_low_widths[1] = 2π;
θ = 2π:-0.1:1
b16_theo = get_b.(16, θ, 0, 10000, 200);

plot(b8_low, s8_low_widths, label="8 players, low start")
plot!(b16_low, s16_low_widths, label="16 players, low start")
plot!(b16_theo, θ, label="theorie 16 players")
plot!(b32_low, s32_low_widths, label="32 players, low start")
plot!(b40_low, s40_low_widths, label="40 players, low start")
plot!(b48_low, s48_low_widths, label="48 players, low start")
#plot!(b56_low, s56_low_widths, label="56 players, low start")
#p = s16_low[1][:,end]
#p_end = solve_time_evolution(p, ϕ, c16_low[1], 10, 41)

#for (i,x) in enumerate(s16_low[20:2:end])
#    p_advanced = solve_time_evolution(x[:,end], ϕ, c16_low[i], 10, 41)
#    save_sim(p_advanced, c16_low[i], "./more_players_no_inc_high_res/16_low/longer/")
#end
