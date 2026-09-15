
mutable struct Config
    path::String
    positions_file::String

    timeout_av::Float64

    # general::Dict
    precision::Dict
    devices_general::Dict
    devices::Dict

    function Config(config::String)
        cfg = TOML.parse(open(config))

        # general = get(cfg,"general",Dict{String,Any}())
        precision = get(cfg,"precision",Dict{String,Any}())
        devices = get(cfg,"devices",Dict{String,Any}())

        devices_ = Dict{Int,Dict}()
        for (key,value) in devices
            if key == "general"; continue; end
            devices_[parse(Int,key)] = value
        end

        new(
            config,
            string(get(cfg,"positions_file","positions.txt")),

            Float64(get(general,"timeout_wait",600.)),

            # cfg[general],
            cfg[precision],
            get(devices,"general",Dict{String,Any}),
            cfg[devices]["general"],
        )
    end
end



mutable struct Controller
    config::Config

    idx::Int
    positions::Matrix{Float64}
    target::Vector{Float64}

    targeter::Bool = true
    listener::Bool = true

    new_target::Bool = false
    interrupt::Bool = false

    function Controller(config::String)
        config = Config(config)
        
        idx, positions = loadPositions(config.positions_file)

        new(
            config,

            -1,
            zeros(Float64,0,0),
            zeros(Float64,length(md)),

            false,
            false,

            false,
            false
        )
    end
end

function loadPositions(file)
    if !isfile(file); @warn "No such file: $file. No positions loaded!"; return -1, zeros(0,0); end

    try
        positions = collect(transpose(readdlm(file,' ',Float64,'\n'; comments=true,skipblanks=true)))
        
        return 0, positions
    catch e
        @warn "Invalid data format. No positions loaded!\nError: $e"

        return -1, zeros(Float64,0,0)
    end
end

function loadPositions!(md::MultiDevice,ctrl::Controller,file::String=ctrl.config.positions_file)
    ctrl.config.positions_file = file

    ctrl.idx, ctrl.positions = loadPositions(file)

    confirmPositions!(md,ctrl)

    return
end

function confirmPositions!(md::MultiDevice,ctrl::Controller)
    if ctrl.idx >= 0
        if size(ctrl.positions,1) != length(md)
            @info "Loaded positions don't match number of discs. Discarding positions."
            
            ctrl.idx = -1; ctrl.positions = zeros(0,0)
        else
            @info "Valid positions loaded, $(size(ctrl.positions,2)) available."
        end
    end

    return
end