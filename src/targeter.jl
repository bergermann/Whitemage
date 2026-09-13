    
function startTargeter!(md::MultiDevice,ctrl::Controller)
    ctrl.targeter = true

    @info "Starting targeter."

    Threads.@spawn runTargeter(md,ctrl)

    return
end

function runTargeter(md::MultiDevice,ctrl::Controller)
    while ctrl.targeter
        if ctrl.new_target
            ctrl.new_target = false
            
            mcTarget(md,target)
            waitForTarget(md)

            sleep(1)
            

            new_target = false; interrupt = false
        end
    end

    return
end

function stopTargeter!(md::MultiDevice)
    @info "Stopping logger."
    
    md.logger.active = false

    return
end