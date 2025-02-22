function load_run(dir, shift=true)
    """loads a simulation run from folder. if shift=true, it shifts the
    simulations to the beginning. be carefull with this one, it is brittle..."""
    filenames = readdir(dir)
    filenames = [file for file in filenames if file[end] == '2']


    b_array = []
    player_array = []
    share_array = []
    match_array = []
    configs = []

    for filename in filenames
        result = load_sim(dir*filename)
        b = result[2].b
        p = result[2].player_count
        if true
            push!(configs, result[2])
            push!(b_array, b)
            push!(player_array, p)
            push!(share_array, result[1][1])
            push!(match_array, result[1][2])
        end
    end

    sorted = sortperm(b_array)

    b_array = b_array[sorted]
    player_array = player_array[sorted]
    share_array = share_array[sorted]
    match_array = match_array[sorted]
    configs = configs[sorted]

    if shift
        share_array = shift_end_to_beginning.(share_array);
    end

    return b_array, share_array, configs, player_array, match_array
    end


function shift_end_to_beginning(simulation, threshold=0.5)
    """shifts simulation array so that the last peak starts at the beginning.
    simulation: 2x2 array with time on x and destination on y"""
    bools = simulation[:,end] .> threshold
    changes = diff([bools..., bools[1]])  # -1: high to low; 1: low to high; 0 no change
    first = findfirst(x->x==1, changes)
    if first == nothing
        offset = length(simulation[:,end]) * 2
    else
        offset = first
    end
    circshift(simulation, -offset)
end


function simple_fitting(ϕ, p, threshold=0.5)
    """somewhat fit the box structure to the data. Returns lower and upper angle.
    ϕ: array with all destination angles,
    p: p_share(ϕ),
    threshold: above which value stuff belongs to full sharing"""
    places = p.>threshold
    larger_range = ϕ[places]
    if length(larger_range) <= 1
        return 0, 0
    else
        return larger_range[1], larger_range[end]
    end
end


function simple_width(ϕ, p, threshold=0.5)
    """Calculates width of sharing regime. Returns angle.
    ϕ: array with all destination angles,
    p: p_share(ϕ),
    threshold: above which value stuff belongs to full sharing"""
    params = simple_fitting(ϕ, p, threshold)
    return params[2] - params[1]
end
