mutable struct Point
    x::Int64; y::Int64;
end

function step!(P, x, y)
    P.x += x
    P.y += y
    return Nothing
end

function distance(P, Q)
    return Int(sqrt((Q.x-P.x)^2 / (Q.y-P.y)^2))
end

function main()
    origin = Point(0, 0)
    p1 = Point(1, 1)
    for n in 1:50
        step!(p1, 1, 1)
        @distance(origin, p1))
    end
end

main()