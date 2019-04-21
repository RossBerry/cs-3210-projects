using Plots

# define the Lorenz attractor
mutable struct Object
    dt; x; y; z; a; b; c
end

function step!(o::Object)
    o.x += 1
    o.y -= 1
    o.z += 1
end

plot_object = Object((dt = 0.5, x =1., y = 1., z = 1, a = 1., b = 1., c = 1.)...)


# initialize a 3D plot with 1 empty series
plt = plot3d(1, xlim=(-25,25), ylim=(-25,25), zlim=(0,50),
                title = "Object Plot", marker = 2)

# build an animated gif by pushing new points to the plot, saving every 10th frame
@gif for i=1:1500
    step!(plot_object)
    push!(plt, plot_object.x, plot_object.y, plot_object.z)
end every 10
