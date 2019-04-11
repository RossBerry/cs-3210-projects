
expression1 = :(a + b + c)
expression2 = "f(a, b, c) = a + b + c"
expression3 = "function g(a, b, c)
        return a + b + c
        end"


a = b = c = 1

evaluation = eval(expression1)
println(evaluation)

myFunction = eval(Meta.parse(expression2))
println(myFunction(a, b, c))
println(eval(Meta.parse(expression3))(a, b, c))

a = b = c = 2

println(eval(expression1))
println(f(a, b, c))
println(eval(Meta.parse(expression3))(a, b, c))