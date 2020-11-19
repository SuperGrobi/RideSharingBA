using Plots
using LaTeXStrings
pyplot()
include("load_and_process.jl")


dir = "2_player_no_inc/"
filenames = readdir(dir);
a_array = []
b_array = []
share_array = []
match_array = []

for filename in filenames
    if filename[end-2:end] != ".jl"
        result = load_sim(dir*filename)
        a = result[2].a
        b = result[2].b
        push!(a_array, a)
        push!(b_array, b)
        push!(share_array, result[1][1])
        push!(match_array, result[1][2])
    end
end
a_array = reshape(a_array, :, 11)'
b_array = reshape(b_array, :, 11)'
share_array = reshape(share_array, 11, :)
match_array = reshape(match_array, 11, :);

widths = zeros(size(share_array))
for (i, x) in enumerate(share_array)
    params = simple_fitting(ϕ, x[:,end])
    widths[i] = (params[2] - params[1])
end
widths = reshape(widths, 21, 11)'


p1 = plot(xlabel=L"\frac{1}{b}", ylabel=L"sharing regime width $\theta$", title="unscaled",
    xlims=(0, :auto),
    ylims=(0,2π+0.05),
    framestyle=:box,
    xticks=(0:1:4, latexstring.(0:1:4)),
    yticks=(0:π/2:2π, [L"0", L"\frac{\pi}{2}", L"\pi", L"\frac{3\pi}{2}", L"2\pi"]))
p2 = plot(xlabel=L"\frac{a}{b}", title="rescaled",
    ylims=(0,2π+0.05),
    framestyle=:box,
    xticks=(0:0.5:2, latexstring.(0:0.5:2)),
    yticks=(0:π/2:2π, fill("", 5)),
    xlims=(0.0,2.0))

for (i, y) in enumerate(eachrow(widths[2:end,:]))
    plot!(p1, 1 ./ b_array[1,:], y,
        ms=5,
        marker=:o,
        markerstrokewidth=0.4,
        label=latexstring("a=$(a_array[i+1,1])"))
    if a_array[i+1,1] ∈ [0.2, 0.6]
        plot!(p2, 1 ./ (b_array[1,7:end]/a_array[i+1,1]), y[7:end],
            ms=5,
            marker=:o,
            markerstrokewidth=0.4,
            label=latexstring("a=$(a_array[i+1,1])"))
    else
        plot!(p2, 1 ./ (b_array[1,:]/a_array[i+1,1]), y,
            ms=5,
            marker=:o,
            markerstrokewidth=0.4,
            label=latexstring("a=$(a_array[i+1,1])"))
    end
end

vline!(p2, [2/π], label="", color=:black, alpha=0.4, width=3, linestyle=:dash)
fig = plot(p1,p2, size=(1000,400))
savefig(fig, "../writing/rescalability_no_inc_inverted.pdf")
