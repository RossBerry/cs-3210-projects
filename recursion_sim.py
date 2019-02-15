"""
recursion_sim.py

Simulates a recursive function using a stack.
"""

__author__ = "Kenneth Berry"


def binary_search_recursive(lst, n):
    """Recursive binary search."""
    if len(lst) == 1:
        return bool(lst[0] == n)
    mid = len(lst) // 2
    if lst[mid] < n:
        return binary_search_recursive(lst[mid + 1:], n)
    elif lst[mid] > n:
        return binary_search_recursive(lst[:mid], n)


def binary_search_stack(lst, n):
    """Binary search using a stack to simulate recursion."""
    print("looking for", n)
    stack = []
    search_lst = lst
    done_stacking = False
    is_found = False
    while not done_stacking:
        if len(search_lst) == 1:
            done_stacking = True
            is_found = bool(search_lst[0] == n)
        mid = len(search_lst) // 2
        if search_lst[mid] < n:
            search_lst = search_lst[mid + 1:]
        elif search_lst[mid] > n:
            search_lst = search_lst[:mid]
        else:
            done_stacking = True
            is_found = True
        stack.append(search_lst)
    for item in stack:
        print(item)
        stack.pop()
    return is_found


if __name__ == "__main__":
    # Create list of test values
    num_list = [n for n in range(10)]
    # print("Recursive function:")
    # for n in range(20):
    #     print(n, binary_search_recursive(num_list, n))


    print("Stack function:")
    for n in range(20):
        print(n, binary_search_stack(num_list, n))
