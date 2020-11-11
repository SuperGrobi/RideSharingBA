using Plots
gr()
include("ring_np_num.jl")
include("average_detour.jl")
include("load_and_process.jl")

ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

Θ = 2π:-0.2:1


# 15 players, inconvenience 0
b15_low, s15_low, _ = load_run("more_players_no_inc_final/15_low/")
s15_low_widths = [simple_width(ϕ, p[:,end]) for p in s15_low]

b15_high, s15_high, _ = load_run("more_players_no_inc_final/15_high/")
s15_high_widths = [simple_width(ϕ, p[:,end]) for p in s15_high]


# 15 players, inconvenience 0.2
b15_c02_low, s15_c02_low, _ = load_run("more_players_with_inc/15p/c=0.2/15_low/")
s15_c02_low_widths = [simple_width(ϕ, p[:,end]) for p in s15_c02_low]

b15_c02_high, s15_c02_high, _ = load_run("more_players_with_inc/15p/c=0.2/15_high/")
s15_c02_high_widths = [simple_width(ϕ, p[:,end]) for p in s15_c02_high]


# 15 players, inconvenience 0.6
b15_c06_low, s15_c06_low, _ = load_run("more_players_with_inc/15p/c=0.6/15_low/")
s15_c06_low_widths = [simple_width(ϕ, p[:,end]) for p in s15_c06_low]

b15_c06_high, s15_c06_high, _ = load_run("more_players_with_inc/15p/c=0.6/15_high/")
s15_c06_high_widths = [simple_width(ϕ, p[:,end]) for p in s15_c06_high]



# 15 players, inconvenience 1
b15_c1_low, s15_c1_low, _ = load_run("more_players_with_inc/15p/c=1/15_low/")
s15_c1_low_widths = [simple_width(ϕ, p[:,end]) for p in s15_c1_low]

b15_c1_high, s15_c1_high, _ = load_run("more_players_with_inc/15p/c=1/15_high/")
s15_c1_high_widths = [simple_width(ϕ, p[:,end]) for p in s15_c1_high]




p1 = plot(b15_low, s15_low_widths, label="low start, c=0")
plot!(p1, b15_high, s15_high_widths, label="high start, c=0")


plot!(p1, b15_c02_low, s15_c02_low_widths, label="low start, c=0.2")
plot!(p1, b15_c02_high, s15_c02_high_widths, label="high start, c=0.2")


plot!(p1, b15_c06_low, s15_c06_low_widths, label="low start, c=0.6")
plot!(p1, b15_c06_high, s15_c06_high_widths, label="high start, c=0.6")


plot!(p1, b15_c1_low, s15_c1_low_widths, label="low start, c=1")
plot!(p1, b15_c1_high, s15_c1_high_widths, label="high start, c=1")
plot!(p1, xlim=(0, :auto), title="15 players")




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

##############################################################

plot(p1, p2, layout=(1,2))
plot!(ylabel="theta", xlabel="b", size=(900, 400))
