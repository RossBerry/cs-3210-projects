import Base.factorial

function factorial(n::BigInt)
    if n == 0
        return 1
    else
        return n * factorial(n - 1)
    end
end

for n in 0:50
    if n < 21
        # Use Base.factorial(n::Int)
        println(factorial(n))
    else
        # Use factorial(n::BigInt)
        println(factorial(BigInt(n)))
    end
end
