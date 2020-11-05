using Distributed
@everywhere include("./ring_np_num.jl")

ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]
# 8 players
b8_low, s8_low, configs8_low = load_run("more_players_no_inc_final/8_low/")
s8_low_widths = [simple_width(ϕ, p[:,end]) for p in s8_low]

offset = 0.3  # rad
sim_steps = 100
smooth_every = 10
kernel_length = 41

println("################### starting validation sims ###################")

b_validation = []
sim_widths = []
for i in 5:2:32  # empirical values from data...
    configs8_low[i].steps = sim_steps
    p_end, sim_width = validate(s8_low_widths[i], offset, ϕ, configs8_low[i], smooth_every, kernel_length, "more_players_no_inc_final/8_validation/")
    push!(sim_widths, sim_width)
    push!(b_validation, configs8_low[i].b)
end


plot(b8_low, s8_low_widths, label="simulation data")
plot!(b8_low, s8_low_widths .+ offset, label="validation start width", linestyle=:dash, color=:grey)
plot!(b_validation, sim_widths, label="validated widths")
