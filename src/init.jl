
function initMD!(md::MultiDevice; rezero::Bool=false)
    if !getMeasurementEnabled(md)
        startMeasurement(md)
    end

    if rezero
        mcZero(md)
        resetAxes(md)
    end

    updateLog!(md,LC_IDLE_INIT)
    p = @lock md.logger [sum(md.logger[].rpos[i])/3 for i in sort!(collect(keys(md.devices)))]

    mcTarget(md,p,:pm)

    return
end

initMD!(ctrl::Controller; rezero::Bool=ctrl.config.rezero) = initMD!(ctrl.md; rezero=rezero)
