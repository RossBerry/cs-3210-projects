import BenchmarkTools.@btime

struct Person
    firstname::String
    lastname::String
end

macro person_str(fullname)
    nameparts = split(fullname, " ")
    Person(nameparts[1], nameparts[end])
end

macro person_macro(fullname)
    nameparts = split(fullname, " ")
    Person(nameparts[1], nameparts[end])
end

function person_constructor(fullname)
    nameparts = split(fullname, " ")
    Person(nameparts[1], nameparts[end])
end

@btime begin
    name1 = person"Kenneth Berry"
end
@time begin
    name1 = person"Kenneth Berry"
end

@btime begin
    name2 = person_constructor("Kenneth Berry")
end
@time begin
    name2 = person_constructor("Kenneth Berry")
end
