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


file_data = open("test") do file
    read(file, String)
end

data = strip_new_line(file_data)
data = split(data)
size = parse(Int64, data[1])
println(size)

#t = [size][size][2]