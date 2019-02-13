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
        return binary_search_recursive(lst[mid+1:], n)
    elif lst[mid] > n:
        return binary_search_recursive(lst[:mid], n)
    else:
        return True

def binary_search_stack(lst, n):
    """Binary search using a stack to simulate recursion."""
    stack = []
    done_stacking = False
    is_found = False
    while not done_stacking:
        if len(lst) == 1:
            stack.append(lst)
        else:
            mid = len(lst) // 2

        if len(lst) == 1:
            return bool(lst[0] == n)
        

if __name__ == "__main__":
    # Create list of test values
    num_list = [n for n in range(10)]
    for n in range(20):
        print(n, binary_search_recursive(num_list, n))
