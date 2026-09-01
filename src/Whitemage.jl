
module Whitemage

using Oxygen, HTTP, JSON, TOML, Blackmage

include("logger.jl")
include("server.jl")

function main(; config="config.toml")
    cfg = TOML.parse(open(config)); display(cfg)

    timeout_av = Real(get(cfg,"timeout_available",600))

    idx, positions = loadPositions(get(cfg,"positions",""))




    md = MultiDevice()

    active = true
    new_target = false
    interrupt = false

    addMockLog_(md)

    Threads.@spawn begin
        while active
            if new_target
                if interrupt; md.interrupt = true; end

                waitForAvailable(md; timeout=timeout_av)

                mcTarget(md,target)

                new_target = false
            end
        end
    end

    s = serve(; host="127.0.0.1",port=2000,async=true)
    # HTTP.get("http://127.0.0.1:2000/rpos/1")

    return
end

function waitForAvailable(md::MultiDevice; interval::Real=0.1,timeout::Real=600)
    @assert interval > 0 ""
    @assert timeout > 0 ""
    @assert interval < timeout ""

    t0 = now(); timeout = Second(Real)
    while md.moving
        sleep(interval)

        if now()-t0 > timeout; throw(ErrorException("Waiting on booster timed out.")); end
    end

    return
end

function loadPositions(file)
    if !isfile(file); @warn "No such file: $file. No positions loaded!"; return -1, zeros(0,0); end

    try
        positions = readdlm(file,' ',Float64,'\n'; comments=true,skipblanks=true)
        return 0, positions
    catch e
        @warn "Invalid data format. No positions loaded!"

        return -1, zeros(0,0)
    end
end



end # module Whitemage
