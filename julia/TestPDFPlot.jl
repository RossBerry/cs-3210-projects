using Plots
println("hello")
x = 1:10
y = rand(10)
p1 = plot(x,y)
p2 = scatter(x,y)
p3 = plot(x,y,label="This one is labelled",lw=3,title="Subtitle")
p4 = histogram(x,y)
p = plot(p1,p2,p3,p4,layout=(2,2),legend=false)
savefig("plot.pdf")
println("Complete")