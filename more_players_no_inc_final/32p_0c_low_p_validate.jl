using Distributed
@everywhere include("./ring_np_num.jl")
@everywhere include("./load_and_process.jl")


ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]
# 32 players
b32_low, s32_low, configs32_low, _ = load_run("more_players_no_inc_final/32_low/")
s32_low_widths = [simple_width(ϕ, p[:,end]) for p in s32_low]

offset = 0.2  # rad
sim_steps = 100
smooth_every = 10
kernel_length = 41

println("################### starting validation sims ###################")

b_validation = []
sim_widths = []
for i in 5:3:30  # empirical values from data...
    configs32_low[i].steps = sim_steps
    p_end, sim_width = validate(s32_low_widths[i], offset, ϕ, configs32_low[i], smooth_every, kernel_length, "more_players_no_inc_final/32_validation/")
    push!(sim_widths, sim_width)
    push!(b_validation, configs32_low[i].b)
end


plot(b32_low, s32_low_widths, label="simulation data", title="32 players, no inc")
plot!(b32_low, s32_low_widths .+ offset, label="validation start width", linestyle=:dash, color=:grey)
plot!(b_validation, sim_widths, label="validated widths")
