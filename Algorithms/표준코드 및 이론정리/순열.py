'''
순열: 순서가 있는 나열
'''

def perm(K):
    if K == N:
        print(new)
        return
    else:
        for i in range(0, N):
            if vis[i] == True:
                continue
            new[K] = numbers[i]
            vis[i] = True
            perm(K+1)
            vis[i] = False
N = 3
new = [0]*N
vis = [False]*N
numbers = [1, 2, 3]
perm(0)

# def perm(K):
#     if K == N:
#         print(new)
#         return
#     else:
#         for i in range(0, N):
#             if vis[i] == True:
#                 continue
#             new[K] = numbers[i]
#             vis[i] = True
#             perm(K+1)
#             vis[i] = False
# N = 3
# new = [0]*N
# vis = [False]*N
# numbers = [1, 2, 3]
# perm(0)