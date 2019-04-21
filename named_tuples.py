from collections import namedtuple

Person = namedtuple('Person', 'first_name last_name')
p1 = Person('Ken', 'Berry')

print(p1.first_name)
print(p1.last_name)
