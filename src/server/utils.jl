
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
