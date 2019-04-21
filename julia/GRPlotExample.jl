using Plots

# Test data
global_temperatures = [14.4, 14.5, 14.8, 15.2, 15.5, 15.8]
pirate_population = [45000, 20000, 15000, 5000, 400, 17]

# Use GR plotting backend
gr()

plot(pirate_population, global_temperatures, label="line")
scatter!(pirate_population, global_temperatures, label="points")

xlabel!("Number of Pirates [Approximate]")
ylabel!("Global Temperature (C)")
title!("Influence of pirate population on global warming")

xflip!()
