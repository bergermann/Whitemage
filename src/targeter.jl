    
function startTargeter!(ctrl::Controller)
    ctrl.targeter = true

    @info "Starting targeter."

    Threads.@spawn runTargeter(ctrl)

    return
end

function runTargeter(ctrl::Controller)
    while ctrl.targeter
        if ctrl.newtarget
            ctrl.newtarget = false
            
            mcTarget(ctrl.md,target)
            mcWait(ctrl.md); sleep(1)
            mcTargetP(ctrl.md); sleep(1)
            
            ctrl.md.interrupt[] = false
        end
    end

    return
end

function stopTargeter!(ctrl::Controller)
    @info "Stopping logger."
    
    ctrl.targeter = false

    return
end