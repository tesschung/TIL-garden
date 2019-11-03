def ssafy1(x):
    return x + 1

lambda x: x + 1
ssafy2 = lambda x: x + 1
ssafy2(2)


list(map(ssafy1, [1, 2, 3])) # [2, 3, 4]
list(map(lambda x: x+1, [1, 2, 3]) # [2, 3, 4]
