def binary_search(lst, n):
    if len(lst) == 1:
        if lst[0] == n:
            return True
        else:
            return False
    mid = len(lst) // 2
    if lst[mid] < n:
        return binary_search(lst[mid:], n)
    elif lst[mid] > n:
        return binary_search(lst[:mid], n)
    else:
        return True

num_list = [n for n in range(10)]

for n in range(20):
    print(n, binary_search(num_list, n))