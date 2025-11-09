
from collections import deque
from bisect import bisect_left

class FilaMentorias:
    def __init__(self):
        self.q = deque()
    def chegar(self, nome):
        self.q.append(nome)
    def atender(self):
        return self.q.popleft() if self.q else None
    def __len__(self):
        return len(self.q)

def busca_sequencial(arr, alvo):
    for i, x in enumerate(arr):
        if x == alvo: return i
    return -1

def busca_binaria(arr, alvo):
    i = bisect_left(arr, alvo)
    return i if i < len(arr) and arr[i] == alvo else -1

def merge_sort(arr):
    if len(arr) <= 1: return arr
    mid = len(arr)//2
    left = merge_sort(arr[:mid]); right = merge_sort(arr[mid:])
    out = []
    i=j=0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            out.append(left[i]); i+=1
        else:
            out.append(right[j]); j+=1
    out.extend(left[i:]); out.extend(right[j:])
    return out
