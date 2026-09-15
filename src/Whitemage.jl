
module Whitemage

using Oxygen, HTTP, JSON, TOML, Blackmage, DelimitedFiles

include("controller.jl")

include("logger.jl")
include("server.jl")

function main(; config="config.toml")
    @assert Threads.nthreads >= 4 "At least 4 threads required for operation."

    ctrl::Controller = Controller(config)
    md::MultiDevice = MultiDevice(;
        mc_port=ctrl.config.devices["general"].mc_port,
        ids_port=ctrl.config.devices["general"].ids_port,
        timeout=ctrl.config.devices["general"].timeout); # addMockLog_(md)

    confirmPositions!(md,ctrl)
    
    startLogger!(md)
    startTargeter!(md,ctrl)

    s = serve(; host="127.0.0.1",port=2000,async=true)

    return
end

# function waitForAvailable(md::MultiDevice; interval::Real=0.1,timeout::Real=600)
#     @assert interval > 0 ""
#     @assert timeout > 0 ""
#     @assert interval < timeout ""

#     waitForTarget()

#     t0 = now(); timeout = Second(Real)
#     while md.moving
#         sleep(interval)

#         if now()-t0 > timeout; throw(ErrorException("Waiting on booster timed out.")); end
#     end

#     return
# end

end # module Whitemage
