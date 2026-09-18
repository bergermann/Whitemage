
module Whitemage

using Oxygen, HTTP, JSON, TOML, Blackmage, DelimitedFiles

include("controller.jl")

include("logger.jl")
include("server.jl")

function main(; config="config.toml")
    @assert Threads.nthreads() >= 4 "At least 4 threads required for operation."
    # main + logger + targeter + server

    ctrl::Controller = Controller(config)
    md::MultiDevice = MultiDevice(getIPs(ctrl.config,:mc),getIPs(ctrl.config,:ids);
         mc_port=ctrl.config.devices_general[:mc_port],
        ids_port=ctrl.config.devices_general[:ids_port],
         timeout=ctrl.config.devices_general[:timeout_connect])
    
    applySettings!(md,ctrl)
    confirmPositions!(md,ctrl)

    # addMockLog_(md)

    # initMD!(md; rezero=ctrl.config.rezero)
      
    # startLogger!(md; interval=ctrl.config.logger_interval)
    # startTargeter!(md,ctrl)

    # server = serve(; host="127.0.0.1",port=ctrl.config.server_port,async=true)

    # return md, ctrl, server
    return md, ctrl
end

function initMD!(md::MultiDevice; rezero::Bool=false)
    if !getMeasurementEnabled(md)
        startMeasurement(md)
    end

    # if rezero
    #     mcZero(md)
    #     resetAxes(md)
    # end

    return
end

end # module Whitemage
