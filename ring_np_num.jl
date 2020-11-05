using QuadGK
using NumericalIntegration
using Plots
using Random
using StatsBase
using JLD2
using Distributed
include("./load_and_process.jl")


pyplot()

mutable struct Config
    # player parameters
    b_i::Float64  # positive constant
    α::Float64  # price factor
    β::Float64  # detour factor
    γ::Float64  # inconvenience factor

    # system parameters
    ϵ::Float64  # discount when sharing
    p::Float64  # base price per distance
    r_0::Float64  # radius of ring
    angle_cutoff::Float64  # angle (rad) above which people are no longer getting matched
    player_count::Int  # number of players

    # simulation parameters
    dt::Float64  # timestep
    games::Int  # games played for each direction
    steps::Int  # integration steps
end

import Base.print
function print(x::Config)
    println("b_i: $(x.b_i)")
    println("α: $(x.α)")
    println("β: $(x.β)")
    println("γ: $(x.γ)")

    println("system params:")
    println("ϵ: $(x.ϵ)")
    println("p: $(x.p)")
    println("r_0: $(x.r_0)")
    println("angle_cutoff: $(x.angle_cutoff)")
    println("player_count: $(x.player_count)")
    println("sim params:")
    println("dt: $(x.dt)")
    println("games: $(x.games)")
    println("steps: $(x.steps)")
end

mutable struct Config_small
    # contains rescaled simulation parameters
    #TODO finish struct, rework functions, add new functions
    # player parameters
    a::Float64  # positive constant with financial incentives
    b::Float64  # detour disincentive
    c::Float64  # constant for inconvenience

    # system parameters
    angle_cutoff::Float64  # angle (rad) above which people are no longer getting matched
    player_count::Int  # number of players

    # simulation parameters
    dt::Float64  # timestep
    games::Int  # games played for each direction
    steps::Int  # integration steps
end


function print(x::Config_small)
    println("a: $(x.a)")
    println("b: $(x.b)")
    println("c: $(x.c)")
    println("system params:")
    println("angle_cutoff: $(x.angle_cutoff)")
    println("player_count: $(x.player_count)")
    println("sim params:")
    println("dt: $(x.dt)")
    println("games: $(x.games)")
    println("steps: $(x.steps)")

end


function u_share(ϕ_i, ϕ, conf::Config)
    #= calculates utility if user is shared at position ϕ_i with user at position ϕ =#
    f1 = conf.b_i - conf.α * (1-conf.ϵ) * conf.p * conf.r_0 - conf.γ * conf.r_0
    if rand([true, false])
        return f1 - conf.β * conf.r_0 * sqrt(2 - 2cos(ϕ-ϕ_i))
    else
        return f1
    end
end


function u_share_single(conf::Config)
    #= calculates the utility if user wants to share but does not get matched =#
    return conf.b_i - conf.α * (1-conf.ϵ) * conf.p * conf.r_0
end


function u_single(conf::Config)
    #= calculates the utility if user does not want to share =#
    return conf.b_i - conf.α * conf.p * conf.r_0
end


function u_share(ϕ_i, ϕ, conf::Config_small)
    #= calculates the difference in utility if user is shared at position ϕ_i with user at position ϕ =#
    f1 = conf.a - conf.c
    if rand([true, false])
        return f1 - (conf.b * cos_satz(ϕ-ϕ_i))
    else
        return f1
    end
end


function u_share_single(conf::Config_small)
    #= calculates the difference in utility if user wants to share but does not get matched =#
    return conf.a
end

function cos_satz(Δϕ)
    return sqrt(2-2cos(Δϕ))
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
    left_ind = (sorted_position == 1) ? num_players : sorted_position-1
    right_ind = (sorted_position % num_players) + 1

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
        left_dist = left_dist>=π ? 2π-left_dist : left_dist
        right_dist = right_dist>=π ? 2π-right_dist : right_dist

        # wenn beide winkel größer als max cutoff winkel sind, dann finde keinen partner
        if (left_dist > max_share_angle) && (right_dist > max_share_angle)  # TODO: rework for cutoff.
            return 0
        end
    end

    # real calculations if trivial checks did not fail
    if (num_players) % 2 == 0  # wenn mit mir eine gerade Anzahl sharen

        i1 = ϕ[all_players_ind[sorted_index]]
        i2 = circshift(i1, 1)


        # differenzen der beiden konfigurationen
        first_config = abs.(i1[2:2:end] .- i1[1:2:end])
        second_config = abs.(i2[2:2:end] .- i2[1:2:end])


        # aufräumen, für periodische Randbedingungen (ind 180 und ind 2 -> Distanz von 22, nicht 178)
        first_config = [i>π ? 2π-i : i for i in first_config]
        second_config = [i>π ? 2π-i : i for i in second_config]

        #println(first_config)
        #println(second_config)

        # summation über umwege
        first_sum = sum(cos_satz.(first_config))
        second_sum = sum(cos_satz.(second_config))

        #println(first_sum)
        #println(second_sum)
        if first_sum < second_sum
            # if position of self in sorted array is even: return angle index before, else after
            i1 = sorted_position % 2 == 0 ? all_players_ind[sorted_index[left_ind]] : all_players_ind[sorted_index[right_ind]]
            return i1
        else
            # if shifted position of self in sorted array is even: return angle index before, else after
            i2 = sorted_position % 2 == 1 ? all_players_ind[sorted_index[left_ind]] : all_players_ind[sorted_index[right_ind]]
            return i2
        end

    else  # wenn eine ungerade Anzahl (inklusive mir) sharen will
        distances = zeros(Float64, num_players)
        sharing_index = zeros(Int, num_players)
        ϕ_targets = ϕ[all_players_ind[sorted_index]]

        # alle shifts durchprobieren
        for shift in 0:(num_players-1)
            sorted_targets = circshift(ϕ_targets, shift)

            # differenzen und aufräumen
            config = abs.(sorted_targets[2:2:end] .- sorted_targets[1:2:end-1])
            config = [i>π ? 2π-i : i for i in config]
            distances[shift+1] = sum(cos_satz.(config))

            # decide on sharing partner
            if (sorted_position+shift) == num_players
                # if I am at the last position, in shifted array, I wont get matched
                sharing_index[shift+1] = 0
            else
                my_ind_after_shift = ((sorted_position + shift - 1) % num_players) + 1
                sharing_index[shift+1] = my_ind_after_shift % 2 == 0 ? all_players_ind[sorted_index[left_ind]] : all_players_ind[sorted_index[right_ind]]
            end
        end

        # decide on return value
        final_share_index = sharing_index[argmin(distances)]
        return final_share_index
    end
end

function Δu(my_index, ϕ, p_share, conf::Config)
    # calculates the difference in utility between sharing and single rides by playing multiple games
    realisations_phi_index = sample(1:length(ϕ), (conf.player_count-1, conf.games))
    realisations_share = [sample([false,true], Weights([1-p_share[i], p_share[i]])) for i in realisations_phi_index]

    # fill util_share for each realisation
    actually_shared = 0
    util_share = zeros(conf.games)
    for (i, ϕ_ind) in enumerate(eachcol(realisations_phi_index))
        share = realisations_share[:, i]
        share_config = get_share_config(my_index, ϕ_ind, ϕ, share; max_share_angle=conf.angle_cutoff)  # get angle index of sharing partner
        if share_config == 0  # if no one shares with me
            util_share[i] = u_share_single(conf)
        else
            util_share[i] = u_share(ϕ[my_index], ϕ[share_config], conf)
            actually_shared += 1
        end
    end

    util_share = mean(util_share)
    util_single = u_single(conf)

    return util_share - util_single, actually_shared/conf.games
end


function Δu(my_index, ϕ, p_share, conf::Config_small)
    # calculates the difference in utility between sharing and single rides by playing multiple games
    realisations_phi_index = sample(1:length(ϕ), (conf.player_count-1, conf.games))
    realisations_share = [sample([false,true], Weights([1-p_share[i], p_share[i]])) for i in realisations_phi_index]

    # fill util_share for each realisation
    actually_shared = 0
    Δutils = zeros(conf.games)
    for (i, ϕ_ind) in enumerate(eachcol(realisations_phi_index))
        share = realisations_share[:, i]
        share_config = get_share_config(my_index, ϕ_ind, ϕ, share; max_share_angle=conf.angle_cutoff)  # get angle index of sharing partner
        if share_config == 0  # if no one shares with me
            Δutils[i] = u_share_single(conf)
        else
            Δutils[i] = u_share(ϕ[my_index], ϕ[share_config], conf)
            actually_shared += 1
        end
    end

    Δutils = mean(Δutils)

    return Δutils, actually_shared/conf.games
end

"""
function distributed_games(x, my_index, ϕ, conf::Config_small)
    ϕ_ind = x[1]
    share = x[2]
    share_config = get_share_config(my_index, ϕ_ind, ϕ, share; max_share_angle=conf.angle_cutoff)  # get angle index of sharing partner
    if share_config == 0  # if no one shares with me
        return u_share_single(conf), 0.0
    else
        return u_share(ϕ[my_index], ϕ[share_config], conf), 1.0
    end

end

function Δu(my_index, ϕ, p_share, conf::Config_small)
    # calculates the difference in utility between sharing and single rides by playing multiple games
    realisations_phi_index = sample(1:length(ϕ), (conf.player_count-1, conf.games))
    realisations_share = [sample([false,true], Weights([1-p_share[i], p_share[i]])) for i in realisations_phi_index]

    # fill util_share for each realisation
    actually_shared = 0
    Δutils = zeros(conf.games)

    games_iterator = zip(eachcol(realisations_phi_index), eachcol(realisations_share))

    Δutils = pmap(x -> distributed_games(x, my_index, ϕ, conf), games_iterator)

    Δutils_end = mean([x[1] for x in Δutils])
    actually_shared = sum([x[2] for x in Δutils])

    return Δutils_end, actually_shared/conf.games
end
"""

function Δu_array(ϕ, p_share, conf)
    result = pmap(x->Δu(x, ϕ, p_share, conf), 1:length(ϕ))
    Δu_values = [i[1] for i in result]
    shared = [i[2] for i in result]
    """
    Δu_values = zeros(length(ϕ))
    shared = zeros(length(ϕ))
    for i in 1:length(ϕ)
        result = Δu(i, ϕ, p_share, conf)
        Δu_values[i] = result[1]
        shared[i] = result[2]
    end
    """
    return Δu_values, shared

end



function replicator_step(p_share, ϕ::LinRange, conf)
    result = Δu_array(ϕ, p_share, conf)
    p_new = p_share + conf.dt * p_share .* (1 .- p_share) .* result[1]
    larger = p_new .> 1
    smaller = p_new .< 0
    p_new[larger] .= 1 .- rand(length(larger))[larger]*0.01
    p_new[smaller] .= 0 .+ rand(length(smaller))[smaller]*0.01
    #p_new = zeros(length(p_share))
    #for i in 1:length(p_share)
    #    p_new[i] = p_share[i] + conf[:dt] * p_share[i]*(1-p_share[i]) * Δu(i, ϕ, p_share, games, players, r_0, b, α, ϵ, p, β, γ, angle_cutoff)
    #end
    return p_new, result[2]
end


function develop_p(p_0, ϕ, conf)
    p_t0 = copy(p_0)
    actual_match= zeros(length(p_0))
    for i in 1:conf.steps
        result = replicator_step(p_t0, ϕ, conf)
        p_t1 = result[1]
        p_t0 = p_t1
        actual_match = result[2]
        print("step $i finished.\r")
    end
    return p_t0, actual_match
end

function convolve(p, kernel_length=21)
    kernel_length = kernel_length%2==0 ? kernel_length+1 : kernel_length
    """convolves a periodic function with a gaussian kernel
    (maybe constant of some sort would be better?)"""
    edge_overlap = kernel_length ÷ 2
    conv_base = [p..., p[1:2edge_overlap]...]

    sup_kernel = (-edge_overlap:1:edge_overlap) .* 3/edge_overlap  # 3 controls the cutoff. higher means narrower gaussian
    kernel = @. exp(-1/2 * sup_kernel^2) / sqrt(2π)
    kernel = kernel ./ sum(kernel)

    convolved = [sum(kernel .* conv_base[i:i+kernel_length-1]) for i in 1:length(conv_base)-kernel_length+1]
    return circshift(convolved, edge_overlap)
end


function solve_time_evolution(p_0, ϕ, conf, smooth_every=10, kernel_length=21)
    save_array = zeros(length(ϕ), conf.steps+1)
    save_array[:,1] .= p_0
    actual_dist_array = zeros(length(ϕ), conf.steps+1)
    print("step 1 of $(conf.steps) done.\r")
    for i in 2:conf.steps+1

        if ((i%smooth_every==0) && (i<(conf.steps-smooth_every)))
            width = simple_width(1:length(ϕ), save_array[:, i-1], 0.7)
            if width > 1.4*kernel_length
                kernel = kernel_length
                #println("convolved at ", i, " with ", kernel)
            else
                kernel = 3 + ceil(Int, 3/4 * width)
                #println("convolved at ", i, " with ", kernel)
            end
            input_p = convolve(save_array[:, i-1], kernel)
        else
            input_p = save_array[:, i-1]
        end

        result = replicator_step(input_p, ϕ, conf)
        save_array[:,i] .= result[1]
        actual_dist_array[:,i] .= result[2]
        #println("step $(i-1) of $(conf.steps) done.")
        print("step $(i-1) of $(conf.steps) done.\r")
    end
    println("Simulation completed!")
    return save_array, actual_dist_array
end


function save_sim(p_end, config::Config, folder)
    result = [p_end; config]
    save_string = folder * "alpha=$(config.α)_beta=$(config.β)_gamma=$(config.γ)_epsilon=$(config.ϵ)_p=$(config.p)_r0=$(config.r_0)_angCut=$(config.angle_cutoff)_Pc=$(config.player_count)_dt=$(config.dt)_games=$(config.games)_steps=$(config.steps).jld2"
    @save save_string result
end


function save_sim(p_end, config::Config_small, folder)
    result = [p_end; config]
    save_string = folder * "a=$(config.a)_b=$(config.b)_c=$(config.c)_angCut=$(config.angle_cutoff)_Pc=$(config.player_count)_dt=$(config.dt)_games=$(config.games)_steps=$(config.steps).jld2"
    @save save_string result
end


function load_sim(source::String)
    f = jldopen(source, "r")
    return f["result"]
end


function run_multi_sims(configs, ϕ_res, p_fac::Number, smooth_every, kernel_length, folder)
    # runs multiple simulations wit random initial conditions
    ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]
    for (i,conf) in enumerate(configs)
        println("==========================================")
        println("simulating $i out of $(length(configs)) ")
        println("now simulating the system:")
        print(conf)
        println("==========================================")
        p_0 = ((rand(ϕ_res) .+ 0.01) .* p_fac)
        p_end = solve_time_evolution(p_0, ϕ, conf, smooth_every, kernel_length)
        println("==========================================")
        save_sim(p_end, conf, folder)
        println("saved!")
        println("==========================================")

    end
end


function run_multi_sims(configs, ϕ_res, p_0::Array, smooth_every, kernel_length, folder)
    # runs multiple simulations with given start function
    ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]
    for (i,conf) in enumerate(configs)
        println("==========================================")
        println("simulating $i out of $(length(configs)) ")
        println("now simulating the system:")
        print(conf)
        println("==========================================")
        p_end = solve_time_evolution(p_0, ϕ, conf, smooth_every, kernel_length)
        println("==========================================")
        save_sim(p_end, conf, folder)
        println("saved!")
        println("==========================================")

    end
end


function run_multi_track(configs, ϕ_res, p_0::Array, smooth_every, kernel_length, folder)
    # runs multiple simulations with given start function
    ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]
    for (i,conf) in enumerate(configs)
        println("==========================================")
        println("simulating $i out of $(length(configs)) ")
        println("now simulating the system:")
        print(conf)
        println("==========================================")
        p_end = solve_time_evolution(p_0, ϕ, conf, smooth_every, kernel_length)
        p_0 = (p_end[1][:,end] .* 0.8) .+ 0.1
        println("==========================================")
        save_sim(p_end, conf, folder)
        println("saved!")
        println("==========================================")

    end
end


function run_multi_different_start(configs, ϕ_res, p_0::Array, smooth_every, kernel_length, folder)
    # runs multiple simulations with given start function
    ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]
    for (i,conf) in enumerate(configs)
        println("==========================================")
        println("simulating $i out of $(length(configs)) ")
        println("now simulating the system:")
        print(conf)
        println("==========================================")
        p_end = solve_time_evolution(p_0[i], ϕ, conf, smooth_every, kernel_length)
        println("==========================================")
        save_sim(p_end, conf, folder)
        println("saved!")
        println("==========================================")

    end
end

function plot_result(result)
    p_end = result[1]
    config = result[2]
    ϕ_res = size(p_end[1])[1]
    ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]
    l = @layout [a; b; c]

    if typeof(config) == Config_small
        params = "a=$(config.a), b=$(config.b)"
    else
        params = ""
    end

    p1 = heatmap(p_end[1], title="share request probability pc=$(config.player_count)")
    p2 = heatmap(p_end[2], title="matching probability $params")
    p3 = plot(ϕ, p_end[1][:,1], label="start sharing probability")
    plot!(p3, ϕ, p_end[1][:,end], label="share request probability")
    plot!(p3, ϕ, p_end[2][:,end], label="match probability", title = "end distributions")
    plot(p1,p2,p3, layout=l)
end


function plot_polar(ϕ, ϕ_ind, ϕ_i)
       angles = ϕ[ϕ_ind]
       x = sin.(angles)
       y = cos.(angles)

       share_partner = get_share_config(ϕ_i, ϕ_ind, ϕ, trues(length(ϕ_ind)))
       if share_partner != 0
           share_x = [sin(ϕ[ϕ_i]), sin(ϕ[share_partner])]
           share_y = [cos(ϕ[ϕ_i]), cos(ϕ[share_partner])]
           plot(share_x, share_y, title=share_partner, label="")y
       else
           plot([0], [0], label="")
       end
       scatter!(x,y, color=:black, ylims=(-1.1, 1.1), xlims=(-1.1,1.1), label=ϕ_ind)
       scatter!([sin(ϕ[ϕ_i])], [cos(ϕ[ϕ_i])], color=:red, ratio=1, label=ϕ_i)
   end


function validate(width, offset, ϕ, conf, smooth_every, kernel_length, folder)
   # offset: how much wider the test start peak should be (angle)
   ϕ_res = length(ϕ)
   p = zeros(ϕ_res)
   peak_width = floor(Int, (width + offset)/2π * ϕ_res)
   peak_start = floor(Int, (ϕ_res - peak_width) / 2)
   p[peak_start:peak_start+peak_width] .= 1
   p = (p .* 0.8) .+ 0.1
   p_end = solve_time_evolution(p, ϕ, conf, smooth_every, kernel_length)
   p_end = (shift_end_to_beginning(p_end[1]), p_end[2])
   sim_width = simple_width(ϕ, p_end[1][:,end])
   save_sim(p_end, conf, folder)
   println("saved!")
   return p_end[1], sim_width
end
