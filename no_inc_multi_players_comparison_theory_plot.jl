using Plots
include("ring_np_num.jl")
include("average_detour.jl")
include("load_and_process.jl")

ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

Θ = 2π:-0.2:1


# 8 players
b8_low, s8_low, _ = load_run("more_players_no_inc_final/8_low/")
s8_low_widths = [simple_width(ϕ, p[:,end]) for p in s8_low]

b8_high, s8_high, _ = load_run("more_players_no_inc_final/8_high/")
s8_high_widths = [simple_width(ϕ, p[:,end]) for p in s8_high]

b8_theo = get_b.(8, Θ, 0, 10000, 200);

p1 = plot(b8_low, s8_low_widths, label="low start")
plot!(p1, b8_high, s8_high_widths, label="high start")
plot!(p1, b8_theo, Θ, label="theory")
plot!(p1, xlim=(2, :auto), title="8 players")


# 16 players
b16_low, s16_low, _ = load_run("more_players_no_inc_final/16_low/")
s16_low_widths = [simple_width(ϕ, p[:,end]) for p in s16_low]

b16_high, s16_high, _ = load_run("more_players_no_inc_final/16_high/")
s16_high_widths = [simple_width(ϕ, p[:,end]) for p in s16_high]

b16_theo = get_b.(16, Θ, 0, 10000, 200);

p2 = plot(b16_low, s16_low_widths, label="low start")
plot!(p2, b16_high, s16_high_widths, label="high start")
plot!(p2, b16_theo, Θ, label="theory")
plot!(p2, xlim=(4, :auto), title="16 players")



# 31 players
b31_low, s31_low, _ = load_run("more_players_no_inc_final/31_low/")
s31_low_widths = [simple_width(ϕ, p[:,end]) for p in s31_low]

b31_high, s31_high, _ = load_run("more_players_no_inc_final/31_high/")
s31_high_widths = [simple_width(ϕ, p[:,end]) for p in s31_high]
pushfirst!(b31_high, 1)
pushfirst!(s31_high_widths, 2π)


b31_theo = get_b.(31, Θ, 0, 10000, 200);


p4 = plot(b31_low, s31_low_widths, label="low start")
plot!(p4, b31_high, s31_high_widths, label="high start")
plot!(p4, b31_theo, Θ, label="theory")
plot!(p4, xlim=(6, :auto), title="31 players")







# 32 players
b32_low, s32_low, _ = load_run("more_players_no_inc_final/32_low/")
s32_low_widths = [simple_width(ϕ, p[:,end]) for p in s32_low]

b32_high, s32_high, _ = load_run("more_players_no_inc_final/32_high/")
s32_high_widths = [simple_width(ϕ, p[:,end]) for p in s32_high]
pushfirst!(b32_high, 1)
pushfirst!(s32_high_widths, 2π)


b32_theo = get_b.(32, Θ, 0, 10000, 200);


p3 = plot(b32_low, s32_low_widths, label="low start")
plot!(p3, b32_high, s32_high_widths, label="high start")
plot!(p3, b32_theo, Θ, label="theory")
plot!(p3, xlim=(6, :auto), title="32 players")


plot(p1, p2, p3, p4, layout=(1,4))
plot!(ylabel="theta", xlabel="b", size=(1300, 400))
