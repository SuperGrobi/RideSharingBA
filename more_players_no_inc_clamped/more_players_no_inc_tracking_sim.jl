using Distributed
@everywhere include("../ring_np_num.jl")


@everywhere begin
    ϕ_res = 200
    ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

    #p_0 = (zeros(ϕ_res) .+ 0.15)
    #p_0 .-= cos.(1 * ϕ) * 0.03
end
print("hallo!")
theo_b = [4.922533972655057, 4.935313112174467, 5.077310801502003, 5.216420631492205, 5.390122944652823, 5.6229642766224766, 5.741646173820571, 5.989349006093706, 6.13586016531216, 6.330637022651147, 6.507479518785063, 6.643987508801511, 6.818897764996288, 6.962457200003415, 7.126827465081846, 7.2764923869303955, 7.428635866957749, 7.573212587974893, 7.753609193440634]

theo_angles = collect(6:-0.2:2)[3:end]

configs = []
for n in [16]
    for b in theo_b
        push!(configs, Config_small(1, b, 0, π, n, 6/b, 1000, 200))
    end
end


smooth_every = 10
kernel_length = 41

p_starts = []
for i in theo_angles
    p = zeros(ϕ_res) .+ 0.15
    pw = floor(Int, i/2π * ϕ_res)
    start = floor(Int, (ϕ_res - pw) / 2)
    p[start:start+pw] .= 0.85
    push!(p_starts, p)
end

run_multi_different_start(configs, ϕ_res, p_starts, smooth_every, kernel_length, "./theo_start/")

"""
reverse!(configs)
# create long simulation object
seed_config = configs[1]
seed_config.steps = 1000

println("################### seed simulation ###################")
seed_prob = solve_time_evolution(p_0, ϕ, seed_config, smooth_every, kernel_length)
p_track_start = seed_prob[1][:,end]

# reset seed config
configs[1].steps = configs[2].steps

println("################### starting multi sim ###################")
run_multi_track(configs, ϕ_res, p_track_start, smooth_every, kernel_length, "")
"""
