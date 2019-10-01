from collections import deque

# deque 생성
thisisdeque = deque()
thisisdeque.append((1, 2))
thisisdeque.append((3, 2))
thisisdeque.append((5, 2))
thisisdeque.append((3, 7))
print(thisisdeque) # deque([(1, 2), (3, 2)])

mypop = thisisdeque.pop()
print(mypop) # (3, 7)

mypopleft = thisisdeque.popleft()
print(mypopleft) # (1, 2)

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
from itertools import product, combinations, permutations

mylist = [(1, 2), (2, 4), (6, 7)]

myproduct = list(product(mylist, repeat=4)) # 중복있는 조합
print(myproduct)

mycombinations = list(combinations(mylist, 2)) # 여러개중 몇 개의 중복없는 조합
print(mycombinations)

mypermutations = list(permutations(mylist, 3)) # 중복없는 조함
print(mypermutations)

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# adj_list 생성

# 무방향 그래프
# 3
# 6 5
# 1 4
# 1 3
# 2 3
# 2 5
# 4 6
# 1 6
# 7 4
# 1 6
# 2 3
# 2 6
# 3 5
# 1 5
# 9 9
# 2 6
# 4 7
# 5 7
# 1 5
# 2 9
# 3 9
# 4 8
# 5 3
# 7 8
# 1 9
adj_list = [[] for i in range(length)]
for e in range(E):
    s, g = map(int, input().split())
    adj_list[s].append(g)
    adj_list[g].append(s)

# 방향 그래프
# 24 2
# 1 17 3 22 1 8 1 7 7 1 2 7 2 15 15 4 6 2 11 6 4 10 4 2
adj_list = [[] for i in range(length)]
for i in range(length):
    if i%2 == 0:
        adj_list[data[i]].append(data[i+1])
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# visit 생성
visited = [[False]*N for _ in range(N)]

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# 빠른 deepcopy
new = [i[:] for i in old]

'''''''''''''''''''''''''''''''''''''''''''''''''''''''

'==================== 라이브러리 순열, 중복순열, 조합, 중복조합 ========================='
from itertools import permutations
per = permutations([1,2,3],2)
print(list(per))
#[(1, 2), (1, 3), (2, 1), (2, 3), (3, 1), (3, 2)]

from itertools import product
per = product([1,2,3],repeat=2)
print(list(per))
#[(1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3), (3, 1), (3, 2), (3, 3)]


from itertools import combinations
print(list(combinations([1,2,3],2) ) )
#[(1, 2), (1, 3), (2, 3)]

from itertools import combinations_with_replacement
print( list ( combinations_with_replacement([1,2,3],2) ) )
#[(1, 1), (1, 2), (1, 3), (2, 2), (2, 3), (3, 3)]


print('--------------------------------------------------------')

'==================== 순열 ========================='
def perm_i():
    for i1 in range(1, N + 1):
        for i2 in range(1, N + 1):
            if i2 != i1:
                print(i1, i2)
''' 
1 2 
1 3 
2 1 
2 3 
3 1 
3 2 
'''

def perm_r(k):
    if k == R :
        print(t[0], t[1])
    else:
        for i in range(N):
            if visited[i]: continue
            t[k] = i + 1
            visited[i] = 1
            perm_r(k + 1)
            visited[i] = 0
''' 
1 2 
1 3 
2 1 
2 3 
3 1 
3 2 
'''


'==================== 조합 ========================='


def comb_i():
    for i in range(N - 1):
        for j in range(i + 1, N):
            print(a[i], a[j])

''' 
1 2 
1 3 
2 3 
'''

def comb_r(k, s):
    if k == R:
        print(t[0], t[1])
    else:
        for i in range(s, N + (k - R) + 1):
            t[k] = a[i]
            comb_r(k + 1, i + 1)
''' 
1 2 
1 3 
2 3 

'''


'===================== 중복 순열 ========================='

def pi_i():
    for i in range(N):
        for j in range(N):
            print(a[i], a[j])

''' 
1 1 
1 2 
1 3 
2 1 
2 2 
2 3 
3 1 
3 2 
3 3 
'''

def pi_r(k):
    if k == R:
        print(t[0], t[1])
    else:
        for i in range(N):
            t[k] = a[i]
            pi_r(k + 1)

''' 
1 1 
1 2 
1 3 
2 1 
2 2 
2 3 
3 1 
3 2 
3 3 
'''


'====================== 중복 조합 ========================'

def H_i():
    for i in range(N):
        for j in range(i, N):
            print(a[i], a[j])

''' 
1 1 
1 2 
1 3 
2 2 
2 3 
3 3 
'''

def H_r(k, s):
    if k == R:
        print(t[0], t[1])
    else:
        for i in range(s, N):
            t[k] = a[i]
            H_r(k + 1, i)
''' 
1 1 
1 2 
1 3 
2 2 
2 3 
3 3 
'''

'====================== 호출 ========================'
N = 3
R = 2
a = [1, 2, 3]
t = [0] * R


t = [0] * N
visited = [0] * N
print()
print("순열")
perm_i()
print("----------")
perm_r(0)
print("----------")

print()
print('조합')
comb_i()
print("----------")
comb_r(0, 0)

print()
print("중복 순열")
pi_i()
print("----------")
pi_r(0)

print()
print("중복 조합")
H_i()
print("----------")
H_r(0, 0)