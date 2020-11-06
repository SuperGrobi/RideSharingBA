using Distributed
@everywhere include("./ring_np_num.jl")

ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]
# 16 players
b16_low, s16_low, configs16_low = load_run("more_players_no_inc_final/16_low/")
s16_low_widths = [simple_width(ϕ, p[:,end]) for p in s16_low]

offset = 0.2  # rad
sim_steps = 100
smooth_every = 10
kernel_length = 41

println("################### starting validation sims ###################")

b_validation = []
sim_widths = []
for i in 12:2:42  # empirical values from data...
    configs16_low[i].steps = sim_steps
    p_end, sim_width = validate(s16_low_widths[i], offset, ϕ, configs16_low[i], smooth_every, kernel_length, "more_players_no_inc_final/16_validation/")
    push!(sim_widths, sim_width)
    push!(b_validation, configs16_low[i].b)
end


plot(b16_low, s16_low_widths, label="simulation data", title="16 players, no inc")
plot!(b16_low, s16_low_widths .+ offset, label="validation start width", linestyle=:dash, color=:grey)
plot!(b_validation, sim_widths, label="validated widths")
