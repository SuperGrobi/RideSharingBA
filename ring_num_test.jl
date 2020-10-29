include("ring_np_num.jl")
using Test

@testcase "utilities" begin
    s_conf = Config_small(1, 1, 1, π, 8, 1, 1000, 100)
    @test begin a = u_share(2, π, s_conf)
        b1 = 
    end
