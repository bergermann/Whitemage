



@get "/interrupt" function(req::HTTP.Request; context::Controller)
    ctrl = context
    ctrl.md.interrupt[] = true

    return "Interrupting."
end



@get "/goto/{idx}" function(req::HTTP.Request,idx::Int; context::Controller)
    ctrl = context

    setNewTarget!(ctrl,idx)
    ctrl.newtarget = true

    return "Going to position $i."
end

@get "/goto_i/{idx}" function(req::HTTP.Request,idx::Int; context::Controller)
    ctrl = context

    setNewTarget!(ctrl,idx)
    ctrl.newtarget = true; ctrl.md.interrupt[] = true

    return "Going to position $i, forcing interrupt."
end



@get "/gonext" function(req::HTTP.Request; context::Controller)
    ctrl = context; @assert 0 <= ctrl.idx "No valid positions loaded."
    
    if ctrl.idx == size(ctrl.positions,2); @info "Reached end, going back to start."; end

    ctrl.idx = ctrl.idx%size(ctrl.positions,2)+1; setNewTarget!(ctrl,ctrl.idx)
    ctrl.newtarget = true

    return "Going to next position: $(ctrl.idx)."
end

@get "/gonext_i" function(req::HTTP.Request; context::Controller)
    ctrl = context; @assert 0 <= ctrl.idx "No valid positions loaded."
    
    if ctrl.idx == size(ctrl.positions,2); @info "Reached end, going back to start."; end

    ctrl.idx = ctrl.idx%size(ctrl.positions,2)+1; setNewTarget!(ctrl,ctrl.idx)
    ctrl.newtarget = true; ctrl.md.interrupt[] = true

    return "Going to next position: $(ctrl.idx). Forcing interrupt"
end



function setNewTarget!(ctrl::Controller,idx::Int)
    @assert 0 <= ctrl.idx "No valid positions loaded."
    @assert 0 <= idx <= size(ctrl.positions,2) "Position index ouf of bounds."

    ctrl.idx = idx
    if idx == 0
        ctrl.target .= 0. 
    else
        copyto!(ctrl.target,ctrl.positions[:,idx])
    end

    return
end