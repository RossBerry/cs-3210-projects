function strip_new_line(string)
    new_string = ""
    for char in string
        if char != '\r' && char != '\n'
            new_string = new_string * char
        else
            new_string = new_string * ' '
        end
    end
    return new_string
end

function readFile(filename)
    #table::Array{Int}(undef, size, size)
    dataString = open(filename) do file
        read(file, String)
    end
    size = parse(Int64, split(dataString)[1])
    data = [parse(Int64, c) for c in split(dataString) if c != '\n' || c != '\r']
    data = data[2,]
    println(data)
end

readFile("test")