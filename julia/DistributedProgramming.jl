using SharedArrays
import BenchmarkTools.@btime

function f!(arr::Array)
    for i = 1:10
        arr[i] = i^10
    end
    return arr
end

function f!(arr::SharedArray)
    @distributed for i = 1:10
        arr[i] = i^10
    end
    return arr
end

a = zeros(Int64, 10)
b = SharedArray(zeros(Int64, 10))

@btime begin
    f!(a)
end
@show a
@btime begin
    f!(b)
end
@show b
