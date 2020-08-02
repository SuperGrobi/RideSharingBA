#= numeric developement of the two player case on a ring =#
using QuadGK
using NumericalIntegration
using Plots
using Random
using StatsBase

pyplot()

b_i = 10
α = 0.1
β = 1
γ = 0.1
ϵ = 0.3
p = 5
r_0 = 1

dt = 3
ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

p_0 = (zeros(ϕ_res) .+ 0.4)
#p_0 .+= rand(ϕ_res) * 0.1
#p_0[80:90] .+= 0.1

games = 1000

function u_share(r, ϕ_i, ϕ, b, α, ϵ, p, β, γ)
    f1 = b - α * (1-ϵ) * p * r - γ * r
    if rand([true, false])
        return f1 - β * r * sqrt(2 - 2cos(ϕ-ϕ_i))
    else
        return f1
    end
end

function u_share_single(r, b, α, ϵ, p)
    return b - α * (1-ϵ) * p * r
end

function Δu(ϕ_index, ϕ, p_share, games, r_0, b, α, ϵ, p, β, γ)
    # calculates the difference in utility between sharing and single rides by playing multiple games
    realisations_phi_index = sample(1:length(ϕ), games)
    realisations_share = [sample([0,1], Weights([1-p_share[i], p_share[i]])) for i in realisations_phi_index]

    util_share = [realisations_share[i]==1 ? u_share(r_0, ϕ[ϕ_index], ϕ[x], b, α, ϵ, p, β, γ) : u_share_single(r_0, b, α, ϵ, p) for (i,x) in enumerate(realisations_phi_index)]
    util_share = mean(util_share)
    util_single = u_share_single(r_0, b, α, 0, p)

    return util_share - util_single
end

function Δu_array(ϕ, p_share, games, r_0, b, α, ϵ, p, β, γ)
    Δu_values = [Δu(i, ϕ, p_share, games, r_0, b, α, ϵ, p, β, γ) for i in 1:length(ϕ)]
end


# numerical integration over periodic function.
# it seems that the trapezoid rule works quiet well.

function replicator_step(p_share, ϕ::LinRange, games, r_0, b, α, ϵ, p, β, γ, dt)
    p_new = zeros(length(p_share))
    for i in 1:length(p_share)
        p_new[i] = p_share[i] + dt * p_share[i]*(1-p_share[i]) * Δu(i, ϕ, p_share, games, r_0, b, α, ϵ, p, β, γ)
    end
    return p_new
end

function develop_p(p_0, ϕ, games, r_0, b, α, ϵ, p, β, γ, dt, steps)
    p_t0 = p_0
    for i in 1:steps
        p_t1 = replicator_step(p_t0, ϕ, games, r_0, b, α, ϵ, p, β, γ, dt)
        p_t0 = p_t1
    end
    return p_t0
end

ax = plot(ϕ, p_0)
p_end = develop_p(p_0, ϕ, games, r_0, b_i, α, ϵ, p, β, γ, dt, 100)
plot!(ax, ϕ, p_end)


#Δu_array = [Δu(α, β, γ, ϵ, p, r_c, ϕ, p_0, ϕ_i) for ϕ_i in ϕ]
ylabel!(ax, "π_share")
xlabel!(ax, "Angle ϕ")
title!(ax, "Probability of sharing, 2 players, numeric")

display(ax)
