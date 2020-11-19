using Plots
using LaTeXStrings
using Plots.PlotMeasures
include("colors.jl")


f(x, r) = x^2 - r
y = -2:0.01:2
x1 = f.(y, 1)
x2 = f.(y, 0)

linew = 3

p1 = plot([0,0], [-1.2, 1.2], arrow=true, label="", color=:black, lw=linew)
plot!(p1, [-2.2,2.2], [0,0], arrow=true, label="", color=:black, lw=linew)
plot!(p1, y, x1, framestyle=:none, label="",
    xlims=(-2.2, 2,2),
    ylims=(-1.2,1.2),
    lw=linew+1,
    color=blue4,
    title=L"f\left(x\right)=x^2 - r",
    top_margin=10px,
    xlabel=L"y",
    ylabel=L"x")

p2 = plot([0,0], [-1.2, 1.2], arrow=true, label="", color=:black, lw=linew)
plot!(p2, [-2.2,2.2], [0,0], arrow=true, label="", color=:black, lw=linew)
plot!(p2, y, x2, framestyle=:none, label="",
    xlims=(-2.2, 2,2),
    ylims=(-1.2,1.2),
    lw=linew+1,
    color=blue4,
    xlabel=L"y",
    ylabel=L"-\sqrt{r}")

fig = plot(p1, p2, size=(1000,400))
savefig(fig, "base-explanation.svg")
