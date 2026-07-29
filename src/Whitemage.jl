
module Whitemage

using Oxygen, HTTP, JSON, Blackmage

include("logger.jl")
include("server.jl")

function main()
    md = MultiDevice()

    addMockLog_(md)

    interrupt = false

    @Threads.spawn begin

    end


    startLogger!(md)

    s = serve(; host="127.0.0.1",port=2000,async=true)
    # HTTP.get("http://127.0.0.1:2000/rpos/1")

    return
end



end # module Whitemage
