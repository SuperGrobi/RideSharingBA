using Plots
using LaTeXStrings
include("colors.jl")

include("ring_2p_ana.jl")
pyplot()
# change these
β = 0.6  # b
γ = 1  # c

# do not touch these!
α = 1
ϵ = 1
p = 1

r_c = 1

dt = 0.02
ϕ_res = 1000
ϕ = LinRange(0,2π, ϕ_res)

fp = α*ϵ*p / (γ+2*β/π)

δ = 0.0001
p_0 = (fp .+ sin.(1 * ϕ) * δ)

λ = zeros(11)
λ_err = zeros(11)
for k in 0:10
    p_1 = (fp .+ cos.(k * ϕ) * δ)
    p_2 = replicator_step(p_1, ϕ, α, β, γ, ϵ, p, r_c, dt)
    λ_temp = get_λ_from_p(p_1, p_2, ϕ, δ, k, dt)
    λ[k+1] = mean(λ_temp)
    λ_err[k+1] = std(λ_temp)
end

function λ_ana(k)
    if k == 0
        return fp-1
    else
        return -(fp-fp^2)/π * 2*β/(1-4k^2)
    end
end

println(fp)
fig = vline([0], color=:black, label="")
hline!(fig, [0], color=:black, label="")
scatter!(fig, 0:10, λ[1:end], label="numeric",marker=:x, ms=13, color=blue4)
scatter!(fig, 0:10, λ_ana.(0:10), label="analytic",
    ms=6,
    framestyle=:box,
    color=yellow5,
    xlabel=L"perturbation wave number $k$",
    ylabel=L"growth factor $\lambda_k$",
    xlims=(-0.2, 7.2),
    ylims=(-0.3,0.06),
    yticks=([-0.3:0.05:0; 0.05], latexstring.([-0.3:0.05:0; 0.05])),
    xticks=(0:7, latexstring.(0:7)),
    legend=:bottomright)
title!(fig, "linear stability of the two player case")
savefig(fig, "../writing/lin_stab.pdf")
