    
function startTargeter!(ctrl::Controller)
    ctrl.targeter = true

    @info "Starting targeter."

    Threads.@spawn runTargeter(ctrl)

    return
end

function runTargeter(ctrl::Controller)
    @info "Running targeter on thread $(Threads.threadid())."

    while ctrl.targeter
        if ctrl.newtarget
            @info "Moving to new target."

            ctrl.newtarget = false
            ctrl.md.interrupt[] = false
            
            mcTarget(ctrl.md,target)
            mcWait(ctrl.md); sleep(1)

            if ctrl.md.settings.doprecision
                mcTargetP(ctrl.md); sleep(1)
            end

            validateTarget!(ctrl.md)
        end; sleep(1)
    end

    return
end

function stopTargeter!(ctrl::Controller)
    @info "Stopping logger."
    
    ctrl.targeter = false

    return
end

function validateTarget!(md::MultiDevice)
    md.target[] = false

    return
end