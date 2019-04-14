

struct MyNum
    value::Int128
end


f(x, y) = x^y
g(x) = x^x
f(x::MyNum, y::MyNum) = x.value^y.value
g(j::MyNum) = j.value^j.value

println()
w = Int128(2)
@show w
x = 2
@show x
y = MyNum(2)
@show y.value
z = MyNum(10)
@show z.value
println()
@show f(w, x)
@show g(f(w, x))
@show eval(Meta.parse("f(y, z) |> g"))
@show f(y, y)
@show g(f(y, y))
@show g(z)

# println("a = ", a)
# println("b = ", b)
# println("c = ", c)
# println("d = ", d)
# println("e = ", e)

# println(z + z)
