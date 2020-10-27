include("./ring_np_num.jl")
# calculates average detour and matching probability as function of width Θ

ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]


function get_b(n, Θ, c, games, ϕ_res)
    ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

    share_end = floor(Int, Θ/2π * ϕ_res)
    p_share = zeros(ϕ_res)
    p_share[1:share_end] .= 1

    detours = []
    matched = []

    for i in 1:games
        my_ind = rand(collect(1:length(ϕ))[p_share .== 1])
        ϕ_ind = rand(1:length(ϕ), n-1)

        #my_share = p_share[my_ind]
        realisations_share = [sample([false,true], Weights([1-p_share[i], p_share[i]])) for i in ϕ_ind]

        #my_ind = 1
        my_share = 1

        if my_share == 1
            index = get_share_config(my_ind, ϕ_ind, ϕ, realisations_share)
            if index != 0
                ang = abs(ϕ[my_ind] - ϕ[index])
                ang = ang > π ? 2π - ang : ang
                dist = cos_satz(ang)
                push!(matched, true)
            else
                push!(matched, false)
                dist = 0
            end
            push!(detours, dist/2)
        else
            dist = 0
        end
    end
    mhd = mean(detours)
    p_match = mean(matched)
    return (1-p_match*c) / mhd
end

function get_crit_b(n, c, games, ϕ)
    detours = []
    angles = []
    for i in 1:games
        ϕ_ind = rand(1:length(ϕ), n-1)
        index = get_share_config(1, ϕ_ind, ϕ, trues(n-1))
        if index != 0
            ang = ϕ[index]
            ang = ang > π ? 2π - ang : ang
            dist = cos_satz(ang)
            push!(detours, dist/2)
        else
            dist = 0
        end
    end
    mhd = mean(detours)
    #return mhd
    return (1-c) / mhd
end
