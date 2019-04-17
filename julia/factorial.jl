import Base.factorial

function factorial(n::BigInt)
    (n == 0) ? 1 : n * factorial(n - 1)
end

# for n in 0:50
#     f = (n < 21) ? factorial(n) : factorial(BigInt(n))
#     println(f)
# end

A = [factorial(n) if (n<21) else factorial(BigInt(n)) for n in 0:50]
foreach(println, [factorial(n) if n<21 else factorial(BigInt(n)) for n in 0:50])

l = [1, 2, 3, 4, 5]
a = ['yes' if v == 1 else 'no' if v == 2 else 'idle' for v in l]
