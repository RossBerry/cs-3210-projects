using Plots

function ECC(x, a, b)
    return sqrt(Complex(x^3 + a*x + b))
end

x = -10:10
a = 0
b = 7

p1 = plot(x, ECC.(x, a, b))
p2 = plot(x, x.^2)
p3 = plot(x, x.^3)
p4 = plot(x, x.^4)

plot(p1, p2, p3, p4, layout=(2, 2), legend=false)
