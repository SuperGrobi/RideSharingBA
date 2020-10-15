using QuadGK
using NumericalIntegration
using Plots
using Statistics
pyplot()

function a_fac(α, ϵ, p, r_c)
    return α * ϵ * p * r_c
end


function b(β, r_c)
    return sqrt(2) * β * r_c / (4pi)
end


function c(γ, r_c)
    return γ * r_c / (2pi)
end


function Δu(α, β, γ, ϵ, p, r_c, ϕ::LinRange, p_share::Array, ϕ_i)
    f1 = a_fac(α, ϵ, p, r_c)
    f2 = b(β, r_c) * integrate(ϕ, p_share .* sqrt.(1 .- cos.(ϕ .- ϕ_i)))
    f3 = c(γ, r_c) * integrate(ϕ, p_share)

    return f1 - f2 - f3
end

# numerical integration over periodic function.
# it seems that the trapezoid rule works quiet well.

function replicator_step(p_share, ϕ::LinRange, α, β, γ, ϵ, p, r_c, dt)
    p_new = zeros(length(p_share))
    for i in 1:length(p_share)
        p_new[i] = p_share[i] + dt * p_share[i]*(1-p_share[i]) * Δu(α, β, γ, ϵ, p, r_c, ϕ, p_share, ϕ[i])
    end
    return p_new
end

function developement_plot(ax, p_0, ϕ, α, β, γ, ϵ, p, r_c, dt)
    p_t0 = copy(p_0)
    for i in 1:10000
        p_t1 = replicator_step(p_t0, ϕ, α, β, γ, ϵ, p, r_c, dt)
        p_t0 = p_t1
        if i%1000==0
            plot!(ax, ϕ, p_t1, label="t=$(dt*i)")
        end
    end
    return ax
end

function get_λ_from_p(p_0, p_t, ϕ, δ, k, t)
    a = p_t .- p_0
    a = a ./ (δ * cos.(k * ϕ))
    a = log.(a.+1)
    return a/t
end

"""
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
"""


"""
#Δu_array = [Δu(α, β, γ, ϵ, p, r_c, ϕ, p_0, ϕ_i) for ϕ_i in ϕ]
ax = plot(ϕ, p_0)
ax = developement_plot(ax, p_0, ϕ, α, β, γ, ϵ, p, r_c, dt)
ylabel!(ax, "π_share")
xlabel!(ax, "Angle ϕ")
title!(ax, "Probability of sharing, 2 players, analytical")

display(ax)
"""
