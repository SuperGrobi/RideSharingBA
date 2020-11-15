using Plots
using LaTeXStrings
using Roots
using QuadGK
pyplot()
include("./ring_np_num.jl")

ϕ = LinRange(0, 2π, 200)
function f_c(Θ, ϕ, b, c)
    1-b/2pi * quadgk(x -> abs(sin(x/2)), -ϕ, Θ-ϕ)[1] - (Θ/2pi) * c
end
get_Θ_c(b, c) = find_zero(x->f_c(x, 0, b, c), 2)
get_crit_b(c) = find_zero(x->f_c(2π, 0, x, c),1)

dir2 = "2_player_full_comparable_scale/"
filenames2 = readdir(dir2)
filenames2 = [x for x in filenames2 if x[end-3:end] == "jld2"];

c_array2 = []
b_array2 = []
share_array2 = []
match_array2 = []

for file in filenames2
    result2 = load_sim(dir2*file)
    c = result2[2].c
    b = result2[2].b
    dt = result2[2].dt
    if c < 10
        if ((b in [0, 0.2, 0.4]) & (dt == 5)) | (b>0.4)
            push!(b_array2, b)
            push!(c_array2, c)
            push!(share_array2, result2[1][1])
            push!(match_array2, result2[1][2])
        end
    end
end

sorted = sortperm(c_array2)
c_array2 = reshape(c_array2[sorted], 21, :)
b_array2 = reshape(b_array2[sorted], 21, :)
share_array2 = reshape(share_array2[sorted], 21, :)
match_array2 = reshape(match_array2[sorted], 21, :)

widths2 = zeros(size(share_array2))

ϕ_res2 = size(share_array2[1])[1]
ϕ2 = LinRange(0,2π, ϕ_res2+1)[1:end-1]

for (i, x) in enumerate(share_array2)
    params = simple_fitting(ϕ2, x[:,end])
    widths2[i] = (params[2] - params[1])
end
widths2 = reshape(widths2, 21, :)


fig = plot(xlabel=L"b",
    ylabel=L"sharing regime width $\theta$",
    title="rescaled with inconvenience factors",
    xlims=(0,4),
    ylims=(0,2π+0.05),
    framestyle=:box,
    xticks=(0:1:4, latexstring.(0:1:4)),
    yticks=(0:π/2:2π, [L"0", L"\frac{\pi}{2}", L"\pi", L"\frac{3\pi}{2}", L"2\pi"]))


for c in 0:0.4:2
    crit = get_crit_b(c)
    b = 0.01:0.01:4
    angles = get_Θ_c.(b, c)
    angles[angles.>2π] .= 2π
    plot!(fig, b, angles, label="", c=:black, alpha=0.4, widht=3, linestyle=:dash)
end

scatter!(fig, b_array2[1:end,1], widths2[1:end,1:2:end], labels=permutedims(["c = $i" for i in c_array2[1,1:2:end]]), marker=:o, ms=5)
plot!(fig, [0,0], [0,0], label="theory", color=:grey, width=3, linestyle=:dash)

# savefig(fig, "../writing/2_player_all_widths.pdf")
