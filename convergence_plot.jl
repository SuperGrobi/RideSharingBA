using Plots
include("ring_np_num.jl")
p_0 = load_sim("2_player_no_inc/a=1.0_b=3.0_c=0.0_angCut=3.141592653589793_Pc=2_dt=3.0_games=1000_steps=100.jld2")
p_1 = load_sim("plotting_stuff/a=1.0_b=5.0_c=0.0_Pc=16_old.jld2")
p_2 = load_sim("plotting_stuff/a=1.0_b=5.0_c=0.0_Pc=16_new.jld2")

plot(heatmap(p_0[1][1], title = "two players"), heatmap(p_1[1][1], title = "16 players, without smoothing"), heatmap(p_2[1][1], title="16 players, with smoothing"), layout=(1,3))
plot!(xlabel="timestep", ylabel="angle", size=(1200, 400))
