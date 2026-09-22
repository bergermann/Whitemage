

function startLogger!(md::MultiDevice; interval::Real=1.)
    md.logger.value.active = true

    @info "Starting logger."
    
    if Blackmage.getMeasurementEnabled(md)
        # updateLog_(md); sleep(interval)
        updateLog!(md); sleep(interval)

        Threads.@spawn begin
            runLogger!(md,interval)
        end
    else
        @info "IDS measurement not enabled."; stopLogger!(md)
    end

    return
end

startLogger!(ctrl::Controller; interval::Real=1.) = startLogger!(ctrl.md; interval=interval)

function runLogger!(md::MultiDevice,interval::Real=1.)
    @info "Running logger on thread $(Threads.threadid())."

    while md.logger.value.active
        # updateLog_(md); sleep(interval)
        updateLog!(md); sleep(interval)
    end

    @info "Stopped logger."

    return
end

function stopLogger!(md::MultiDevice)
    @info "Stopping logger."
    
    md.logger.value.active = false

    return
end

stopLogger!(ctrl::Controller) = stopLogger!(ctrl.md)
