
module Whitemage

using Oxygen, HTTP, JSON, TOML, Blackmage, DelimitedFiles

include("controller.jl")
include("logger.jl")
include("targeter.jl")



function main(; config="config.toml")
    @assert Threads.nthreads() >= 4 "At least 4 threads required for operation."
    # main + logger + targeter + server

    ctrl = Controller(config)
        
    applySettings!(ctrl)
    confirmPositions!(ctrl)

    addMockLog_(ctrl.md)

    # initMD!(ctrl; rezero=ctrl.config.rezero)
      
    startLogger!(ctrl; interval=ctrl.config.logger_interval)
    # startTargeter!(ctrl)

    include("src/server/server.jl")

    server = serve(; host="127.0.0.1",port=ctrl.config.server_port,async=true,context=ctrl)

    return ctrl, server
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

initMD!(ctrl::Controller; rezero::Bool=false) = initMD!(ctrl.md; rezero=rezero)

end # module Whitemage
