using QuadGK
using NumericalIntegration
using Plots
using Random
using StatsBase

pyplot()

base_config = Dict(
# player parameters
:b_i => 10,  # positive constant
:α => 0.1,  # price factor
:β => 0.9,  # detour factor
:γ => 0.1,  # inconvenience factor

# system parameters
:ϵ => 0.3,  # discount when sharing
:p => 5,  # base price per distance
:r_0 => 1,  # radius of ring
:angle_cutoff => 1,  # angle (rad) above which people are no longer getting matched
:player_count => 4,  # number of players

# simulation parameters
:dt => 2,  # timestep
:games => 1000,  # games played for each direction
:steps => 100
)


function u_share(ϕ_i, ϕ, conf)
    #= calculates utility if user is shared at position ϕ_i with user at position ϕ =#
    f1 = conf[:b_i] - conf[:α] * (1-conf[:ϵ]) * conf[:p] * conf[:r_0] - conf[:γ] * conf[:r_0]
    if rand([true, false])
        return f1 - conf[:β] * conf[:r_0] * sqrt(2 - 2cos(ϕ-ϕ_i))
    else
        return f1
    end
end

function u_share_single(conf)
    #= calculates the utility if user wants to share but does not get matched =#
    return conf[:b_i] - conf[:α] * (1-conf[:ϵ]) * conf[:p] * conf[:r_0]
end

function u_single(conf)
    #= calculates the utility if user does not want to share =#
    return conf[:b_i] - conf[:α] * conf[:p] * conf[:r_0]
end

function get_share_config(ϕ_i, ϕ_ind, ϕ, share; max_share_angle=2π)
    # ϕ_i: meine richtung (index)
    # ϕ_ind: indizes der richtungen in die alle anderen spieler fahren
    # ϕ: alle richtungen (array)
    # share: teilt der spieler (boolean array)
    # max_share_angle: angle over which player will not get matched
    # returns index of angle of player with which I will share.
    # returns 0 if no matched partner or angle index of matched

    all_players_ind = [ϕ_i; ϕ_ind[share]]  # winkelindizes der spieler die teilen (mit self)
    sorted_index = sortperm(all_players_ind)
    num_players = length(sorted_index)

    # indizes von self und "rechts" und "links" von mir
    sorted_position = findall(x->x==1, sorted_index)[1]
    left_ind = sorted_position == 1 ? num_players : sorted_position-1
    right_ind = sorted_position % num_players + 1

    ring_res = length(ϕ)  # auflösung des ringes (damit wir uns nicht mit winkeln rumschlagen müssen.)

    #println(ring_res)
    #println(all_players_ind)
    #println(sorted_index)
    #println(sorted_position)

    if true ∉ share  # wenn niemand sonst sharen will
        return 0
    else
        # max angle share cutoff

        # positive winkeldifferenz
        left_dist = abs(ϕ[ϕ_i] - ϕ[all_players_ind[sorted_index[left_ind]]])
        right_dist = abs(ϕ[ϕ_i] - ϕ[all_players_ind[sorted_index[right_ind]]])
        # wenn größer als halber winkel
        left_dist = left_dist>π ? 2π-left_dist : left_dist
        right_dist = right_dist>π ? 2π-right_dist : right_dist

        # wenn beide winkel größer als max cutoff winkel sind, dann finde keinen partner
        if (left_dist > max_share_angle) & (right_dist > max_share_angle)
            return 0
        end
    end

    # real calculations if trivial checks did not fail
    if (num_players) % 2 == 0  # wenn mit mir eine gerade Anzahl sharen

        i1 = all_players_ind[sorted_index]
        i2 = circshift(i1, 1)

        # differenzen der beiden konfigurationen
        first_config = abs.(i1[2:2:end] .- i1[1:2:end])
        second_config = abs.(i2[2:2:end] .- i2[1:2:end])

        # aufräumen, für periodische Randbedingungen (ind 180 und ind 2 -> Distanz von 22, nicht 178)
        first_config = [i>ring_res/2 ? ring_res-i : i for i in first_config]
        second_config = [i>ring_res/2 ? ring_res-i : i for i in second_config]

        #println(first_config)
        #println(second_config)

        # summation über umwege
        first_sum = sum(first_config)
        second_sum = sum(second_config)

        #println(first_sum)
        #println(second_sum)
        if first_sum < second_sum
            # if position of self in sorted array is even: return angle index before, else after
            i1 = sorted_position % 2 == 0 ? all_players_ind[sorted_index[left_ind]] : all_players_ind[sorted_index[right_ind]]
            return i1
        else
            # if shifted position of self in sorted array is even: return angle index before, else after
            i2 = (sorted_position+1) % 2 == 0 ? all_players_ind[sorted_index[left_ind]] : all_players_ind[sorted_index[right_ind]]
            return i2
        end

    else  # wenn eine ungerade Anzahl (inklusive mir) sharen will
        distances = zeros(Int, num_players)
        sharing_index = zeros(Int, num_players)

        # alle shifts durchprobieren
        for shift in 0:(num_players-1)
            sorted_targets = circshift(all_players_ind[sorted_index], shift)

            # differenzen und aufräumen
            config = abs.(sorted_targets[2:2:end] .- sorted_targets[1:2:end-1])
            config = [i>ring_res/2 ? ring_res-i : i for i in config]
            distances[shift+1] = sum(config)

            # decide on sharing partner
            if (sorted_position+shift) == num_players
                # if I am at the last position, in shifted array, I wont get matched
                sharing_index[shift+1] = 0
            else
                sharing_index[shift+1] = ((sorted_position+shift) % num_players) % 2 == 0 ? all_players_ind[sorted_index[left_ind]] : all_players_ind[sorted_index[right_ind]]
            end
        end

        # decide on return value
        final_share_index = sharing_index[argmin(distances)]
        if final_share_index == 0
            return 0
        else
            return final_share_index
        end
    end
end


function Δu(my_index, ϕ, p_share, conf)
    # calculates the difference in utility between sharing and single rides by playing multiple games
    realisations_phi_index = sample(1:length(ϕ), (conf[:player_count]-1, conf[:games]))
    realisations_share = [sample([false,true], Weights([1-p_share[i], p_share[i]])) for i in realisations_phi_index]

    # fill util_share for each realisation
    util_share = zeros(conf[:games])
    for (i, ϕ_ind) in enumerate(eachcol(realisations_phi_index))
        share = realisations_share[:, i]
        share_config = get_share_config(my_index, ϕ_ind, ϕ, share; max_share_angle=conf[:angle_cutoff])  # get angle index of sharing partner
        if share_config == 0  # if no one shares with me
            util_share[i] = u_share_single(conf)
        else
            util_share[i] = u_share(ϕ[my_index], ϕ[share_config], conf)
        end
    end

    util_share = mean(util_share)
    util_single = u_single(conf)

    return util_share - util_single
end

function Δu_array(ϕ, p_share, conf)
    Δu_values = [Δu(i, ϕ, p_share, conf) for i in 1:length(ϕ)]
end



function replicator_step(p_share, ϕ::LinRange, conf)
    p_new = p_share + conf[:dt] * p_share .* (1 .- p_share) .* Δu_array(ϕ, p_share, conf)
    #p_new = zeros(length(p_share))
    #for i in 1:length(p_share)
    #    p_new[i] = p_share[i] + conf[:dt] * p_share[i]*(1-p_share[i]) * Δu(i, ϕ, p_share, games, players, r_0, b, α, ϵ, p, β, γ, angle_cutoff)
    #end
    return p_new
end

function dpdt(p, ϕ, conf)
    # dgl to solve with different solvers
    return conf[:dt] * p .* (1 .- p) .* Δu_array(ϕ, p, conf)
end


function develop_p(p_0, ϕ, conf)
    p_t0 = copy(p_0)
    for i in 1:conf[:steps]
        p_t1 = replicator_step(p_t0, ϕ, conf)
        p_t0 = p_t1
        println("step $i finished.")
    end
    return p_t0
end


if abspath(PROGRAM_FILE) == @__FILE__

    ϕ_res = 150
    ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

    p_0 = (zeros(ϕ_res) .+ 0.1)
    p_0 .-= cos.(10 * ϕ) * 0.03
    #p_0[80:90] .+= 0.1

    ax = plot(ϕ, p_0)
    p_end = develop_p(p_0, ϕ, config)
    plot!(ax, ϕ, p_end)


    #Δu_array = [Δu(α, β, γ, ϵ, p, r_c, ϕ, p_0, ϕ_i) for ϕ_i in ϕ]
    ylabel!(ax, "π_share")
    xlabel!(ax, "Angle ϕ")
    title!(ax, "Probability of sharing, numeric, $(config[:player_count]) players
    \ncutoff angle: $(config[:angle_cutoff])")

    display(ax)
end
