

function startLogger!(md::MultiDevice; interval::Real=1.)
    md.logger.active = true

    @info "Starting logger."
    
    if getMeasurementEnabled()
        Threads.@spawn begin
            runLogger!(md,interval)
        end
    end
end

function runLogger!(md::MultiDevice,interval::Real=1.)
    @info "Running logger."

    while md.logger.active
        lock(md.logger.lock) do
            updateLog_(md); sleep(interval)
        end
    end

    @info "Stopped logger."

    return
end

function stopLogger!(md::MultiDevice)
    @info "Stopping logger."
    
    md.logger.active = false

    return
end