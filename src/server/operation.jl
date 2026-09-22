



@get "/interrupt" function(req::HTTP.Request; context::Controller)
    ctrl = context
    ctrl.md.interrupt[] = true

    return "Interrupting."
end



@get "/goto/{i}" function(req::HTTP.Request,i::Int; context::Controller)
    ctrl = context

    setNewTarget!(ctrl,i)
    ctrl.newtarget = true

    return "Going to position $i."
end

@get "/goto_i/{i}" function(req::HTTP.Request,i::Int; context::Controller)
    ctrl = context

    setNewTarget!(ctrl,i)
    ctrl.newtarget = true; ctrl.interrupt = true

    return "Going to position $i, forcing interrupt."
end



@get "/gonext" function(req::HTTP.Request; context::Controller)
    ctrl = context; @assert 0 <= ctrl.idx "No valid positions loaded."
    
    # if idx[] == size(positions,2); @info "Reached end, going back to start"; end
    ctrl.idx = ctrl.idx%size(ctrl.positions,2)+1
    setNewTarget!(ctrl,ctrl.idx)

    ctrl.newtarget = true

    return "Going to next position: $i."
end

@get "/gonext_i" function(req::HTTP.Request; context::Controller)
    ctrl = context; @assert 0 <= ctrl.idx "No valid positions loaded."
    
    # if idx[] == size(positions,2); @info "Reached end, going back to start"; end
    ctrl.idx = ctrl.idx%size(ctrl.positions,2)+1
    setNewTarget!(ctrl,ctrl.idx)

    ctrl.newtarget = true; ctrl.interrupt = true

    return "Going to next position: $i. Forcing interrupt"
end



function setNewTarget!(ctrl::Controller,idx_::Int)
    @assert 0 <= ctrl.idx "No valid positions loaded."
    @assert 0 < idx_ < size(ctrl.positions,2) "Position index ouf of bounds."

    ctrl.idx = idx_; copyto!(ctrl.target,ctrl.positions[idx_])

    return
end