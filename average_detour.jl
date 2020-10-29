include("./ring_np_num.jl")
# calculates average detour and matching probability as function of width Θ

ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]




function get_b(n, Θ, c, games, ϕ_res, my_ind=1)
    ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

    # build peak with start at first index and end at angle Θ
    share_end = floor(Int, Θ/2π * ϕ_res)
    #my_ind = floor(Int, share_end/2)
    p_share = zeros(ϕ_res)
    p_share[1:share_end] .= 1

    # setup arrays
    detours = []
    matched = Array{Bool, 1}()

    for i in 1:games

        # index of destinations of n-1 other players (constant random distribution)
        ϕ_ind = rand(1:length(ϕ), n-1)

        # array that tells us if players with destinations in φ_ind want to share
        realisations_share = [sample([false,true], Weights([1-p_share[i], p_share[i]])) for i in ϕ_ind]

        # get index of destination of the sharing partner in φ
        # if other player sits at at angle = 0 (element with index 1 in φ) (0 if no match)
        index = get_share_config(my_ind, ϕ_ind, ϕ, realisations_share)

        if index != 0
            # get destination angle of matched player and clean it up
            ang = ϕ[index]
            ang = ang > π ? 2π - ang : ang

            # calculate detour distance
            dist = cos_satz(ang)
            # tell the array that in this case the player at 1 got matched
            push!(matched, true)
        else  # no detour and no match
            dist = 0
            push!(matched, false)
        end
        push!(detours, dist/2)  # add halve of the detour in detours array
    end

    # calculate means
    mhd = mean(detours)
    p_match = mean(matched)

    return (1-p_match*c) / mhd  # this should be b
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
