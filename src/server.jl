

@get "/ping" function(req::HTTP.Request)
    return "pong"
end

@get "/test" function(req::HTTP.Request)
    return [1]
end

@get "/echo" function(req::HTTP.Request)
    display(req.body)

    return "echo"
end



@get "/rpos/{i}" function(req::HTTP.Request,i::Int)
    return json(md.logger.rpos[i])
end



@get "/goto/{i}" function(req::HTTP.Request,i::Int)
    setNewTarget!(target,positions,i)
    
    newtarget[] = true

    return "Going to position $i."
end

@get "/goto_i/{i}" function(req::HTTP.Request,i::Int)
    setNewTarget!(target,positions,i)
    
    newtarget[] = true; interrupt[] = true

    return "Going to position $i, forcing interrupt."
end



@get "/gonext" function(req::HTTP.Request)
    @assert 0 <= idx[] "No valid positions loaded."

    newtarget[] = true
    
    # if idx[] == size(positions,2); @info "Reached end, going back to start"; end
    idx[] = idx[]%size(position,2)+1
    setNewTarget!(target,positions,idx[])

    return "Going to next position: $i."
end

@get "/gonext_i" function(req::HTTP.Request)
    @assert 0 <= idx[] "No valid positions loaded."
    
    # if idx[] == size(positions,2); @info "Reached end, going back to start"; end
    idx[] = idx[]%size(position,2)+1
    setNewTarget!(target,positions,idx[])

    newtarget[] = true; interrupt[] = true

    return "Going to next position: $i. Forcing interrupt"
end



function setNewTarget!(target::Vector{Float64},positions::Matrix{Float64},idx_::Int)
    @assert 0 <= idx[] "No valid positions loaded."
    @assert 0 < idx_ < size(positions,2) "Position index ouf of bounds."

    idx[] = idx_; target .= positions[idx]

    return
end