include("ring_2p_ana_rescaled.jl")


widths = []
results= []
for i in 0:0.2:15
    p_end = develop_p(p_0, ϕ, 1, i, 0, 5/i, 500)
    result = ϕ[p_end.>0.5]
    push!(results, p_end)
    push!(widths, result[end] - result[1])
end

plot(plot(0:0.2:15, widths), heatmap(hcat(results...)))
