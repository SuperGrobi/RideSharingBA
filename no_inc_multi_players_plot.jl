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

plot(b8_low, s8_low_widths, label="8 players, low start")
plot!(b8_high, s8_high_widths, label="8 players, high start")



# 16 players
b16_low, s16_low, _ = load_run("more_players_no_inc_final/16_low/")
s16_low_widths = [simple_width(ϕ, p[:,end]) for p in s16_low]

b16_high, s16_high, _ = load_run("more_players_no_inc_final/16_high/")
s16_high_widths = [simple_width(ϕ, p[:,end]) for p in s16_high]

plot!(b16_low, s16_low_widths, label="16 players, low start")
plot!(b16_high, s16_high_widths, label="16 players, high start")



# 32 players
b32_low, s32_low, _ = load_run("more_players_no_inc_final/32_low/")
s32_low_widths = [simple_width(ϕ, p[:,end]) for p in s32_low]

b32_high, s32_high, _ = load_run("more_players_no_inc_final/32_high/")
s32_high_widths = [simple_width(ϕ, p[:,end]) for p in s32_high]

plot!(b32_low, s32_low_widths, label="32 players, low start")
plot!(b32_high, s32_high_widths, label="32 players, high start")



# 31 players
b31_low, s31_low, _ = load_run("more_players_no_inc_final/31_low/")
s31_low_widths = [simple_width(ϕ, p[:,end]) for p in s31_low]

b31_high, s31_high, _ = load_run("more_players_no_inc_final/31_high/")
s31_high_widths = [simple_width(ϕ, p[:,end]) for p in s31_high]

plot!(b31_low, s31_low_widths, label="31 players, low start")
plot!(b31_high, s31_high_widths, label="31 players, high start")


plot!(ylabel="theta", xlabel="b", title="multiple players, c=0")
