
import Base: convert; Base.convert(Tuple,a::Vector) = Tuple(a)

mutable struct Config
    path::String
    positions_file::String

    server_port::Int
    logger_interval::Float64

    timeout_move::Float64

    precision::Dict{Symbol,Any}
    devices_general::Dict{Symbol,Any}
    devices::Dict{Int,Dict{Symbol,Any}}

    function Config(config::String)
        cfg = TOML.parse(open(config))

        general = get(cfg,"general",Dict{String,Any}())
        precision = get(cfg,"precision",Dict{String,Any}())
        devices = get(cfg,"devices",Dict{String,Any}())
        devices_general = get(devices,"general",Dict{String,Any}())

        devices_ = Dict{Int,Dict}()
        for (key,value) in devices
            if key == "general"; continue; end
            devices_[parse(Int,key)] = Dict(Symbol(replace(k,"alpha"=>"α")) => v
                                                                        for (k,v) in value)
        end

        new(
            config,
            string(get(general,"positions_file","positions.txt")),

            Int(get(general,"server_port",2001)),
            Float64(get(general,"logger_interval",1.)),

            Float64(get(general,"timeout_move",600.)),

            Dict(Symbol(key) => value for (key,value) in precision),
            Dict(Symbol(key) => value for (key,value) in devices_general),
            devices_,
        )
    end
end



mutable struct Controller
    config::Config

    idx::Int
    positions::Matrix{Float64}
    target::Vector{Float64}

    targeter::Bool
    new_target::Bool

    function Controller(config::String)
        config = Config(config)
        
        idx, positions = loadPositions(config.positions_file)

        new(
            config,

            -1,
            zeros(Float64,0,0),
            zeros(Float64,size(positions,1)),

            false,
            false,
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
    if length(ctrl.target) != length(md); ctrl.target = zeros(Float64,length(md)); end

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



function getIPs(cfg::Config,type::Symbol)
    return [cfg.devices[i][type] for i in sort!(collect(keys(cfg.devices)))]
end



function applySettings!(md::MultiDevice,cfg::Config)
    applyPrecisionSettings!(md,cfg)
    applyDeviceSettings!(md,cfg)

    return
end

function applyPrecisionSettings!(md::MultiDevice,cfg::Config)
    if haskey(cfg.precision,:doprecision)
        md.settings.doprecision = cfg.precision[:doprecision]
    else
        @info "No config found wether to do precision correction.
            Using default of $(md.settings.doprecision)"
    end

    cfg_ = cfg.precision
    ps = md.settings.psettings
    ps_ = Integer[]

    for p in propertynames(ps)
        try 
            p_ = convert(typeof(ps[p]),cfg_[p])
            push!(ps_,p_)
        catch e
            if e isa KeyError
                @info "No config found for precision setting :$p. Using default value $(ps[p])."
                push!(ps_,ps[p])
            elseif e isa MethodError
                @info "Could not convert config for precision setting :$p to the proper type
                    $(typeof(ps[p])). Using default value $(ps[p])."
                push!(ps_,ps[p])
            else
                @error "Unexpected error while reading precision setting :$p. Check config inputs."
                rethrow(e)
            end
        end
    end

    md.settings.psettings = NamedTuple{propertynames(ps)}(ps_)

    return
end

function applyDeviceSettings!(md::MultiDevice,cfg::Config)
    for i in eachindex(md)
        if !haskey(cfg.devices,i); @warn "No config found for device $i."; continue; end
        
        ds = md[i].settings
        cfg_ = cfg.devices[i]
        cfg__ = cfg.devices_general

        for p in propertynames(ds)
            if haskey(cfg_,p)
                try 
                    setfield!(ds,p,convert(fieldtype(typeof(ds),p),cfg_[p]))
                catch e
                    if e isa MethodError
                        @info "Could not convert config :$p to the proper type
                        $(fieldtype(ds,p)). Using default value $(getfield(ds,p))."
                    else
                        @error "Unexpected error while reading device setting :$p. Check config inputs."
                        rethrow(e)
                    end
                end
            elseif haskey(cfg__,p)
                try
                    setfield!(ds,p,cfg__[p])
                catch e
                    if e isa MethodError
                        @info "Could not convert config :$p to the proper type
                        $(fieldtype(ds,p)). Using default value $(getfield(ds,p))."
                    else
                        @error "Unexpected error while reading device setting :$p. Check config inputs."
                        rethrow(e)
                    end
                end
            else
                @info "No config found for property :$p of device $i. Using default value
                    $(getfield(ds,p))."
            end
        end
    end

    return
end