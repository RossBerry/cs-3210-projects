# x = [1, -1, -2, 3]
# for i in range(len(x)):
#     if x[i] < 0:
#         del x[i]
# print(x)

x = [1, -1, -2, 3]
for n in x:
    print(n)
    if n < 0:
        x.remove(n)
print(x)

x = [1, -1, -2, 3]
for i, n in enumerate(x):
    if x[i] < 0:
        x.remove(x[i])
print(x)