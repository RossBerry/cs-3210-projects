using Plots

unicodeplots()

x = -10:10

p1 = plot(x, x)
p2 = plot(x, x.^2)
p3 = plot(x, x.^3)
p4 = plot(x, x.^4)

plot(p1, p2, p3, p4, layout=(2, 2), legend=false)
