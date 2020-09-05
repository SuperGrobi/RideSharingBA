using QuadGK
using NumericalIntegration
using Plots
pyplot()

a=1
b=1
c=0

dt = 5
ϕ_res = 200
ϕ = LinRange(0,2π, ϕ_res+1)[1:end-1]

p_0 = (zeros(ϕ_res) .+ 0.4)
p_0 .+= rand(ϕ_res) * 0.1
p_0[80:90] .+= 0.1


function Δu(a, b, c, ϕ::LinRange, p_share::Array, ϕ_i)
    f1 = a
    f2 = sqrt(2) * b / 4pi * integrate(ϕ, p_share .* sqrt.(1 .- cos.(ϕ .- ϕ_i)))
    f3 = c / (2pi) * integrate(ϕ, p_share)

    return f1 - f2 - f3
end

# numerical integration over periodic function.
# it seems that the trapezoid rule works quiet well.

function replicator_step(p_share, ϕ::LinRange, a, b, c, dt)
    p_new = zeros(length(p_share))
    for i in 1:length(p_share)
        p_new[i] = p_share[i] + dt * p_share[i]*(1-p_share[i]) * Δu(a, b, c, ϕ, p_share, ϕ[i])
        larger = p_new .> 1
        smaller = p_new .< 0
        p_new[larger] .= 1 .- rand(length(larger))[larger]*0.01
        p_new[smaller] .= rand(length(smaller))[smaller]*0.01
    end
    return p_new
end

function develop_p(p_0, ϕ, a, b, c, dt, steps)
    p_t0 = p_0
    for i in 1:steps
        p_t1 = replicator_step(p_t0, ϕ, a, b, c, dt)
        p_t0 = p_t1
    end
    return p_t0
end

ax = plot(ϕ, p_0)
p_end = develop_p(p_0, ϕ, a, b, c, dt, 500)
plot!(ax, ϕ, p_end)


#Δu_array = [Δu(α, β, γ, ϵ, p, r_c, ϕ, p_0, ϕ_i) for ϕ_i in ϕ]
ylabel!(ax, "π_share")
xlabel!(ax, "Angle ϕ")
title!(ax, "Probability of sharing as a Function of the Angle")

display(ax)
