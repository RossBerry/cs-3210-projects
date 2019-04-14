import Base.factorial

function factorial(n::BigInt)
    if n == 0
        return 1
    else
        return n * factorial(n - 1)
    end
end
