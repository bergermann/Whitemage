

function startLogger!(md::MultiDevice)
    md.logger.active = true
    
    if getMeasurementEnabled()
        Threads.@spawn begin
            runLogger!(md)
        end
    end
end

function runLogger!(md::MultiDevice)
    while md.logger.active
        lock(md.logger.lock) do
            updateLog_(md); sleep(1)
        end
    end

    return
end