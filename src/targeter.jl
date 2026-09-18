    
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
            mcWait(md); sleep(1)
            mcTargetP(md); sleep(1)
            
            md.interrupt[] = false
        end
    end

    return
end

function stopTargeter!(md::MultiDevice,ctrl::Controller)
    @info "Stopping logger."
    
    ctrl.targeter = false

    return
end