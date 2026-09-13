
mutable struct Config
    path::String
    positions_file::String

    timeout_av::Float64

    devices::Dict
    general::Dict
    precision::Dict

    function Config(config::String)
        cfg = TOML.parse(open(config))

        new(
            config,
            get(cfg,"positions_file",""),

            Float64(get(cfg,"timeout_available",600.)),

            cfg[devices],
            cfg[general],
            cfg[precision],
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