
# using Whitemage, 
using Oxygen, HTTP, JSON, Blackmage

const md::MultiDevice = MultiDevice()

addMockLog_(md)

Threads.@spawn begin
    md.logger.active = true

    while md.logger.active
        lock(md.logger.lock) do
            updateLog_(md); sleep(1)
        end
    end
end

@get "/ping" function(req::HTTP.Request)
    return true
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



s = serve(; host="127.0.0.1",port=2000,async=true)
# HTTP.get("http://127.0.0.1:2000/rpos/1")