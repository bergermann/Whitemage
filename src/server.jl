

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
    newtarget = true

    return 
end

@get "/goto_i/{i}" function(req::HTTP.Request,i::Int)
    

    return 
end