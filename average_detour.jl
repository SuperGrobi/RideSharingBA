include("./ring_np_num.jl")


ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

function get_crit_b(n, c, games, ϕ)
    detours = []
    angles = []
    for i in 1:games
        ϕ_ind = rand(1:length(ϕ), n-1)
        index = get_share_config(1, ϕ_ind, ϕ, trues(n-1))
        ang = ϕ[index]
        ang = ang > π ? 2π - ang : ang
        dist = cos_satz(ang)
        push!(detours, dist/2)
    end
    mhd = mean(detours)
    return (1-c) / mhd
end
