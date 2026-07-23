

@get "/ping" function(req::HTTP.Request)::String
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
    return JSON.json(md.logger.rpos[i])
end