import Base.Threads.@threads

cube(x) = x^3
A = [1, 2, 3]
@threads for cube.(A)
end

@show A