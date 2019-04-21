struct ImmutablePoint
    x::Int64; y::Int64;
end

mutable struct MutablePoint
    x::Int64; y::Int64;
end

function step!(point::MutablePoint, step_x::Int64, step_y::Int64)
    point.x = point.x + step_x
    point.y = point.y + step_y
    return Nothing
end

function distance(P, Q)
    if P.x == 0 && P.y == 0
        return Int(round(sqrt(Q.x + Q.y)))
    else
        return Int(round(sqrt((Q.x-P.x)^2 / (Q.y-P.y)^2)))
    end
end

function main()
    origin = ImmutablePoint(0, 0)
    point1 = MutablePoint(0, 0)
    for n in 1:50
        step!(point1, 1, 1)
        @show point1
        println(distance(origin, point1))
    end
end

main()
