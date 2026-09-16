
module Whitemage

using Oxygen, HTTP, JSON, TOML, Blackmage, DelimitedFiles

include("controller.jl")

include("logger.jl")
include("server.jl")

function main(; config="config.toml")
    @assert Threads.nthreads >= 4 "At least 4 threads required for operation."
    # main + logger + targeter + server

    ctrl::Controller = Controller(config)
    md::MultiDevice = MultiDevice(getIPs(ctrl.cfg,:mc),getIPs(ctrl.cfg,:ids);
         mc_port=ctrl.config.devices_general[:mc_port],
        ids_port=ctrl.config.devices_general[:ids_port],
         timeout=ctrl.config.devices_general[:timeout_connect])
    
    applySettings!(md,ctrl.cfg)
        
    # addMockLog_(md)

    confirmPositions!(md,ctrl)
    
    startLogger!(md; interval=ctrl.config.logger_interval)
    startTargeter!(md,ctrl)

    server = serve(; host="127.0.0.1",port=2000,async=true)

    return md, ctrl, server
end

end # module Whitemage
