import Base.factorial
include("BigFactorial.jl")

for n in 0:50
    if n < 21
        # Use Base.factorial(n::Int)
        println(factorial(n))
    else
        # Use factorial(n::BigInt)
        println(factorial(BigInt(n)))
    end
end
