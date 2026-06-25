
using Whitemage, Blackmage

const md::MultiDevice = MultiDevice()

addMockLog_(md)

Threads.@spawn begin
    server = listen(2000)

    socket = accept(server)

    Threads.@spawn while isopen(socket)
        r = readline(socket)

        
        write(socket,0)
        
    end
end

