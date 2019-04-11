import LinearAlgebra.transpose!
import Base.Threads.@threads

function readTableFile(filename)
    #table::Array{Int}(undef, size, size)
    dataString = open(filename) do file
        read(file, String)
    end
    intArray = [parse(Int64, c) for c in split(dataString) if c != '\n' || c != '\r']
    size = intArray[1]
    intTable = reshape(intArray[2:end], size, size)
    t = Array{Int}(undef, size, size)
    transpose!(t, intTable)
    return t
end

function printTable(table::Array{Int, 2})
    n = size(table)[1]
    for r in 1:n
        for c in 1:n
            print(table[r, c], ' ')
        end
        println()
    end
end

function printTable(table::Array{Int, 3})
    n = size(table)[1]
    for r in 1:n
        for c in 1:n
            print(table[r, c, 1], ' ')
        end
        println()
    end
    println()
    for r in 1:n
        for c in 1:n
            print(table[r, c, 2], ' ')
        end
        println()
    end
end

function floyd(t)
    n = size(t)[1]
    d = zeros(Int, n, n, 2)
    d[:, :, 1] = t
    for k in 1:n
        for r in 1:n
            for c in 1:n
                if r != k || c != k
                    if d[r, k, 1] != -1 && d[k, c, 1] != -1
                        if d[r, k, 1] + d[k, c, 1] < d[r, c, 1] || d[r, c, 1] == -1
                            d[r, c, 1] = d[r, k, 1] + d[k, c, 1]
                            d[r, c, 2] = k
                        end
                    end
                end
            end
        end
    end
    return d
end

function route(t::Array{Int, 3}, start::Int, stop::Int)
    w = t[start, stop, 1]
    route = zeros(Int, 0)
    push!(route, start)
    while t[start, stop, 2] != 0
        temp = t[start, stop, 2]
        if t[start, temp, 2] != 0
            start = t[start, temp, 2]
        else
            start = temp
        end
        push!(route, start)
    end
    push!(route, stop)
    route = Tuple(route)
    return (w, route)
end

println("Reading table from file")
@time begin
    fileTable = readTableFile("test")
end

println()
println("Printing Original Table")
printTable(fileTable)

println()
println("Calculating Distances")
@time begin
    floydTable = floyd(fileTable)
end

println()
println("Printing New Table")
printTable(floydTable)

println()
println("Calculating Best Route")
@time begin
    best = route(floydTable, 2, 1)
end
println(best)


s = 5000
big = [rand(Int, 100) for n in 1:s^2]
big = reshape(big, s, s)
@time begin
    bigFloyd = floyd(big)
end