
@get "/rpos/{device}" function(req::HTTP.Request,device::Int; context::Controller)
    ctrl = context
    @lock ctrl.md.logger json(ctrl.md.logger[].rpos[device])
end

@get "/rpos/{device}/{axis}" function(req::HTTP.Request,device::Int,axis::Int; context::Controller)
    ctrl = context
    @lock ctrl.md.logger json(ctrl.md.logger[].rpos[device][axis])
end



@get "/apos/{device}" function(req::HTTP.Request,device::Int; context::Controller)
    ctrl = context
    @lock ctrl.md.logger json(ctrl.md.logger[].apos[device])
end

@get "/apos/{device}/{axis}" function(req::HTTP.Request,device::Int,axis::Int; context::Controller)
    ctrl = context
    @lock ctrl.md.logger json(ctrl.md.logger[].apos[device][axis])
end



@get "/signal/{device}" function(req::HTTP.Request,device::Int; context::Controller)
    ctrl = context
    @lock ctrl.md.logger json(ctrl.md.logger[].signal[device])
end

@get "/signal/{device}/{axis}" function(req::HTTP.Request,device::Int,axis::Int; context::Controller)
    ctrl = context
    @lock ctrl.md.logger json(ctrl.md.logger[].signal[device][axis])
end



@get "/time" function(req::HTTP.Request; context::Controller)
    ctrl = context
    @lock ctrl.md.logger json(ctrl.md.logger[].timestamp)
end

@get "/context" function(req::HTTP.Request; context::Controller)
    ctrl = context
    @lock ctrl.md.logger json(UInt8(ctrl.md.logger[].context))
end



@get "/target" function(req::HTTP.Request; context::Controller)
    ctrl = context

    return json(ctrl.md.target[][])
end