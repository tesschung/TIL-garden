
'''
5
1 2 4 4 5
'''
n = int(input())
temp = list(map(int, input().split()))
pre_t = 0
myloss = 0
# print(temp)
for t in temp:  # 앞에서 부터 진행하는데,
    if pre_t < t:  # 큰게 나타날때마다 갱신해주고,
        pre_t = t

    elif pre_t > t and myloss > t - pre_t:  # pre_t가 더 크고, 저장된 loss 가 뺀거보다 크다면,
        myloss = t - pre_t
print(myloss)
