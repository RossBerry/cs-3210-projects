using Plots

P = [0.4 0.6; 0.2 0.8]
b = 0.97
A = P + sum([b^i * P^i for i = 1:200])
@show A
