'''
분할정복이란?
분할 -> 정복 -> 합치기 순으로 상위 데이터를 작게 나눠서 문제를 해결하는 방식
분할: 원래 문제를 분할하여 비슷한 유형의 더 작은 하위 문제들로 나누기
정복: 하위 문제 각각을 재귀적으로 해결, 하위 문제의 규모가 충분히 작으면 문제를 탈출 조건으로 놓고 해결
합치기: 하위 문제들의 답을 합쳐서 원래 문제 해결
'''



# 1. 병합 정렬
'''
분할. p pp와 r rr의 중간 q qq를 찾습니다. 
이진 검색에서 중간점을 찾았던 것과 같은 방법으로 이 과정을 수행합니다: 
p pp와 r rr을 더해서 2로 나눈 후 내림을 하여 정수로 만듭니다.

정복. 분할 단계에서 만들어진 두 하위 문제 각각에 있는 하위 배열을 재귀적으로 정렬합니다.
즉 하위 배열 array[p..q]를 재귀적으로 정렬하고 또 하위 배열array[q+1..r]을 재귀적으로 정렬합니다.

결합. 정렬된 두 하위 배열을 하나의 정렬된 하위 배열인 array[p..r]로 결합합니다.
'''
def mysum(arr):
    total = 0
    for x in arr: # 큰 리스트에서 원소를 하나씩 꺼내서
        total += x # total에 추가해서
    return total # 모든 원소 순회가 끝나면, total을 리턴한다.
print(mysum([1,2,3,4]))

# 분할 정복
def merge_sort(m):
    if len(m) <= 1:
        return m
    mid = len(m)//2
    left = m[:mid]
    right = m[mid:]
    left = merge_sort(left)
    right = merge_sort(right)
    return merge(left, right)

# 병합
def merge(left, right):
    global cnt
    result = []
    if left[-1] > right[-1]:
        cnt += 1
    l = h = 0
    while len(left) > l and len(right) > h:
        if left[l] <= right[h]:
            result.append(left[l])
            l+=1
            # print(l)
        else:
            result.append(right[h])
            h += 1
            # print(h)
    if len(left) > 0:
        result += left[l:]
    if len(right) > 0:
        result += right[h:]
    return result

for tc in range(1):
    idx = 5
    arr = [7, 5, 4, 1, 2, 10, 3, 6, 9, 8]
    cnt = 0
    arr = merge_sort(arr)
    print(f'#{tc+1} {arr[idx//2]} {cnt}')



# 2. 퀵 정렬
'''
반드시 필요한 배열
- 기준 원소보다 작은 숫자들로 이루어진 하위배열
- 기준 원소
- 기준 원소보다 큰 숫자들로 이루어진 하위배열
'''

def qsort(arr):
    if len(arr) < 2: # 원소개수가 0이나 1이면 이미 정렬이 된 상태이므로 가지치기한다.
        return arr

    else:
        pivot = arr[0] # pivot은 아무 값이나 가능하므로 가장 처음에 있는 인덱스를 기준점을 삼는다.
        # less 와 more 둘다 기준점을 제외한 모든 리스트에있는 원소들을 순회하면서,
        # pivot 이하인경우 less에 추가하고, 이상인경우 more에 추가하는데,
        # 이를 재귀적으로 호출한다.
        less = [i for i in arr[1:] if i <= pivot]
        more = [i for i in arr[1:] if i >= pivot]
        return qsort(less) + [pivot] + qsort(more)

for tc in range(1):
    idx = 5
    arr = [7, 5, 4, 1, 2, 10, 3, 6, 9, 8]
    cnt = 0
    arr = merge_sort(arr)
    print(f'#{tc+1} {arr[idx//2]} {cnt}')
