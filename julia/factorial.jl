function my_factorial(n)
    n = BigInt(n)
    if n == 0
        return 1
    else
        return n * my_factorial(n - 1)
    end
end

for i = 1:50
    println(my_factorial(i))
end