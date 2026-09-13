    
function startTargeter!(md::MultiDevice,ctrl::Controller)
    ctrl.targeter = true

    @info "Starting targeter."

    Threads.@spawn runTargeter(md,ctrl)

    return
end

function runListener(md::MultiDevice,ctrl::Controller)
    while ctrl.targeter
        if new_target
            if interrupt; md.interrupt = true; end

            waitForAvailable(md; timeout=timeout_av)

            sleep(1)
            
            mcTarget(md,target)

            new_target[] = false; interrupt[] = false
        end
    end

    return
end