struct MyNum
    value::Int128
end

f(x, y) = x^y
g(x) = x^x
f(x::MyNum, y::MyNum) = x.value^y.value
g(j::MyNum) = j.value^j.value
#+(x::MyNum, y::MyNum) = x.value + y.value

w = Int128(2)
x = 2
y = MyNum(2)
z = MyNum(10)

a = f(w, x)
b = g(f(w, x))
c = f(y, y)
d = g(f(y, y))
e = g(z)

# println("a = ", a)
# println("b = ", b)
# println("c = ", c)
# println("d = ", d)
# println("e = ", e)

# println(z + z)