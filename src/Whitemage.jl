
module Whitemage

using Oxygen, HTTP, JSON, TOML, Blackmage, DelimitedFiles

include("controller.jl")

include("logger.jl")
include("server.jl")

function main(; config="config.toml")
    @assert Threads.nthreads >= 4 "At least 4 threads required for "

    ctrl::Controller = Controller(config)
    md::MultiDevice = MultiDevice(); # addMockLog_(md)

    confirmPositions!(md,ctrl)
    
    startLogger!(md)
    startTargeter!(md,ctrl)






    s = serve(; host="127.0.0.1",port=2000,async=true)
    # HTTP.get("http://127.0.0.1:2000/rpos/1")

    return
end

function waitForAvailable(md::MultiDevice; interval::Real=0.1,timeout::Real=600)
    @assert interval > 0 ""
    @assert timeout > 0 ""
    @assert interval < timeout ""

    waitForTarget()

    t0 = now(); timeout = Second(Real)
    while md.moving
        sleep(interval)

        if now()-t0 > timeout; throw(ErrorException("Waiting on booster timed out.")); end
    end

    return
end




end # module Whitemage
