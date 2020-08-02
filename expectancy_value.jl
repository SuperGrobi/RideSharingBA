#= calculates the expectancy value of the smallest angle between n
directions on a disc and plots the results =#
using Plots

pyplot()

n_iter = 2:30
iterations = 4000
expected_value = zeros(length(n_iter))

for (pos, n) in enumerate(n_iter)
    average = 0
    for i in 1:iterations
        targets = sort(rand(n) * 2π)
        diff = targets[2:end] .- targets[1:end-1]
        diff = [diff; 2π-sum(diff)]
        average += minimum(diff)
    end
    average /= iterations
    expected_value[pos] = average
end

fig = plot(n_iter, expected_value, marker=:o, linetype=:scatter, yscale=:log, xscale=:log)
plot!(fig, x->2*π/x^2, 2, 30)
display(fig)
