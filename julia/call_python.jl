using PyCall

pushfirst!(PyVector(pyimport("sys")."path"), "")
functions = pyimport("my_functions")

x = functions.test_add()

println(x)