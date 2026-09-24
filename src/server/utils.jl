
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



@get "/ndisc" function(req::HTTP.Request; context::Controller)
    ctrl = context

    return json(length(ctrl.md))
end

@get "/info" function(req::HTTP.Request; context::Controller)
    ctrl = context

    return json(length(ctrl.md))
end