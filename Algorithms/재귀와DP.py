# # 다익스트라 알고리즘을 통해서 최소 비용(가중치) 구하기
# # 입력: 가중치가 있는 그래프
# # 출력: start부터 fin까지의 최소거리
#
# infinity = float('inf')
#
# graph = {} # 정점들을 연결하고, 그 이웃의 가중치 표시
# graph['you'] = ['alice', 'bob', 'claire']
# graph['start'] = {}
# graph['start']['a'] = 6
# graph['start']['b'] = 2
# graph['a'] = {}
# graph['a']['fin'] = 1
# graph['b'] = {}
# graph['b']['a'] = 3
# graph['b']['fin'] = 5
# graph['fin'] = {}
# print(graph)
#
# costs = {} # 출발점부터 fin까지의 가격을 나타냄
# costs['a'] = 6
# costs['b'] = 2
# costs['fin'] = infinity
#
# parents = {} # 부모를 위한 해시테이블
# parents['a'] = 'start'
# parents['b'] = 'start'
# parents['fin'] = None
#
# processed = []
#
# print(costs) #{'a': 6, 'b': 2, 'fin': inf}
# print(parents) #{'a': 'start', 'b': 'start', 'fin': None}
# def find_lowest_cost_node(costs):
#     lowest_cost = float('inf')
#     lowest_cost_node = None # None으로 초기화해주어야 return값이 None이 나옴
#
#     for node in costs:
#         cost = costs[node]
#         if cost < lowest_cost and node not in processed:
#             lowest_cost = cost
#             lowest_cost_node = node
#
#     return lowest_cost_node
#
# node = find_lowest_cost_node(costs)
# print(node)
# while node is not None:
#     cost = costs[node]
#     neighbors = graph[node]
#     for n in neighbors.keys():
#         new_cost = cost + neighbors[n]
#         if costs[n] > new_cost:
#             costs[n] = new_cost # 최소 costs를 업데이트
#             parents[n] = node
#     processed.append(node)
#     node = find_lowest_cost_node(costs)
#
#
# print(costs) #{'a': 5, 'b': 2, 'fin': 6}
# print(parents) #{'a': 'b', 'b': 'start', 'fin': 'a'}
# print('min_cost', cost)
# print('parents', parents)


# 재귀 기본 연습

# def countdown(n):
#     print(n)
#     if n <= 1: # n이 1이되면 재귀호출 중단
#         return
#     countdown(n-1) # n-1을 하면서 호출한다.
# countdown(5)

#
# def countup(n):
#     print(n)
#     if n >= 10:
#         return
#     countup(n+1)
# countup(5)

# # 재귀사용
# def factor(n):
#     print(n)
#     if n <= 1:
#         return 1
#     else:
#         return n * factor(n-1)
# num = factor(5)
# print(num)


# 해시를 사용하여 중복 제거
cache = {}

def factorial_recursive(n):
    global cache
    if n in cache:
        return cache[n]
    elif n <= 1:
        return 1
    else:
        cache[n] = n * factorial_recursive(n-1)
        return cache[n]

res = factorial_recursive(5)
res = factorial_recursive(7)
print(cache)
print(res)


# def factorials(n):
#     global cash
#     print(n)
#     if n in cash: # cash에 현재의 n을 키로 가진 것이 있는가?
#         # 있다면,
#         return cash[n]
#     elif n <= 1: # 위가 만족하지 않고, 해당 부분이 만족한다면 1 리턴
#         return 1
#     elif n not in cash and n > 1: # n이 cash에 없고, 1보다 n이 크다면 해시에 키:값 쌍으로 추가한다.
#         cash[n] = n * factorials(n-1)
#         return cash[n] # cash에 추가하고 해당 결과를 반환하는 부분
#     else:
#         if n <= 1:
#             return 1
#         else:
#             return n * factorials(n-1)
#
# cash = {}
# mynum = factorials(5)
# print(mynum)
# print(cash)
#
# # 최대상금
# # 주어진 숫자(number)을 주어진횟수(depth) 만큼 변경해줬을때 최대값을 구하는 함수.
# def max_prices(depth, number):
#     # 만약 주어진 depth가 문제에서 정한 횟수(K)와 같다면 모든 계산이 끝난것이다.
#     # 따라서 지금 계산된 값을 반환해준다. 앞으로 이 함수는 무조건 계산이 끝난 후 최대값을 반환해준다 (우리가 찾는 값이 최대값이므로)
#     if depth == K:
#         return number
#
#     # 아래가 DP를 사용한 상황. 만약 지금 현재 횟수에서, 주어진 숫자를 계산했었다면. 해당 값을 꺼내어 가져와서 리턴한다(한번더 할필요가없다.)
#     # cache가 2차원 구조인데 depth 는 현재 전환횟수를 인덱스로, number은 현재 숫자를 키값으로 하는 리스트/딕셔너리에넣어서
#     # 저장해놓았다.
#
#     # 만약 저장해놓은 값이있다면 그 값을 바로 리턴함으로써 다시 계산하는 일이 없도록한다.
#     if cache[depth].get(number) != None:
#         res = cache[depth][number]
#         return res
#
#     # 저장해놓지 않았다면 구해야하므로, res(결과값=> 최대상금값)를 초기화
#     res = 0
#     for [x, y] in change_cases:  # 밖에서 구한, 모든 가능한 전환결과에 대해서 체크를하여
#         temp = changelist(list(number), x, y)  # 전환을하고
#         res = max(res, int(max_prices(depth + 1, temp)))  # 그 값을 depth를 1증가시키면서 넣는다.
#         '''
#         여기서 맥스값은 바로 다음 깊이의 맥스값을 구하는 것이아니다.
#         여기서 불러온 함수내에서 다시 깊이를 증가시켜서 함수를 넣고, 그 함수에서 다시 깊이를 증가시켜서 함수에 넣어서
#         최종적으로 함수 가장위에있는 depth == K일때 리턴값을 비교하여주는것이다.
#         ==> 즉 여기서는 '123'에서 가능한 모든 전환 가능한 경우 6가지에 대해서
#         각각 모두 최대깊이까지 내려가서(물론 다음 깊이에서도 6가지 경우씩 6 * 6 * 6 * 6 *.... 뎁스번  반복하여 깊이가 증가할수록
#         경우의 수가 기하급수적으로 증가한다) 모든 경우를 다비교하여 최대값을 넣는것이다.
#         이를 dP없이 한다면 계산을 못한다 3자리 수만하더라도 6 ** depth 만큼 계산이 필요하기때문에
#         '''
#
#     cache[depth][number] = res
#     # 계산을 다했다면 현재 깊이와 숫자에 대해서 계산결과값을 저장소에 저장하고
#     # 결과를 리턴한다.
#     return res
#
#
# '''
# 리스트(숫자 ex '7','2','1','2')를 받아서 원하는 자리를 바꿔주고 스트링으로 반환하는 함수
# ex_ change(['7','2','1','2'],c1 = 1, c2 = 2) => '7122'로 바꿔준다.
# '''
#
#
# def changelist(arr, c1, c2):
#     arr[c1], arr[c2] = arr[c2], arr[c1]
#     arr = ''.join(arr)
#     return arr
#
#
# '''
# 나오는 결과는 스트링 문자열(출력하기 쉬울라고)
# '''
#
# for round in range(int(input())):
#     number, K = input().split()
#     '''
#     number(숫자열)과 K(변환 횟수)를 받아오는데, number은 숫자의 자리를 변경해줘야하므로 인트형보다는
#     스트링 혹은 리스트가 편해서 map사용 안함.
#     '''
#     K = int(K)  # 얘는 숫자로 필요하니 인트로 바꿔줍니다. '교환횟수'
#
#     '''
#     숫자의 길이를 파악해둔다. 숫자의 길이에따라서 숫자 자리수 변화 '경우의수'가 다르기때문에
#     ex) 123 은 인덱스(0,1) (0,2) (1,2) 세개의 자리수변화가 있을수있고 3C2 = 3
#     1234는 인덱스(0,1)(0,2)(0,3)(1,2)(1,3)(2,3) 이렇게 6개의 변화가 가능하다. 4C2 = 4
#     숫자의 길이에 따라서 변환시켜줘야하는 경우의수가 달라지기때문에 자주쓰여서 가독성 좋고 쓰기편하게 바꿔줌.
#     '''
#     length = len(number)
#
#     '''
#     아래의 digits는 숫자내의 각각의 자리수(인덱스)를 숫자로 나타낸것이다
#     ex) '123' 에서 1은 0의 인덱스, 2는 1의 인덱스, 3은 2의 인덱스를 가지고
#     changelist 함수가 인덱스를 갖고 변환을 시키기때문에 인덱스들만을 모은 리스트를 만든것.
#     근데 한번쓰이고 안씀.
#     '''
#     digits = list(range(length))  # 자리수.
#     '''
#     위에 작성한것처럼 자리수를 바꿔줘야 하는 경우의수가 있다.
#     그것을 구하는과정이고
#     모든 경우의수 를 change_cases에 넣는다
#     [ex) 123일경우 change_cases= [[0,1] [0,2] [1,2]] =< cases안의 []안의 숫자는 인덱스를 의미. 각 자리의 값이 아님
#     '''
#     change_cases = []  # 자리바꿀수있는경우의수
#     '''
#     모든 경우의 수를 넣는과정은 인덱스의 집합(위의 digits 리스트)의 부분집합을 구하는 것과 같은데
#     부분집합중 요소의 갯수가 2개인것만 골라낸다.
#     '''
#     for i in range(1 << length):  # 모든 부분집합을 구하는데, E.g. 1 << 3 means 1*2*2*2
#         bubun = []  # 부분집합(자리변환경우의수 중 하나)를 넣을 리스트
#         for j in range(length):
#             if i & (1 << j): # bit 단위로 and연산, E.g. bit이 아닌 값을 전달
#                 bubun.append(digits[j])  # 부분집합에 인덱스를 넣는다
#         if len(bubun) == 2:  # 부분집합중에서 길이가 2인것만을 골라 ('123' 중 1,2 인덱스 이렇게 두자리만 변화하기때문에 두개만필요해서)
#             change_cases.append(bubun)  # change_cases에 넣는다.
#         # 모든 포문이 돌면 change_cases가 완성된다 ex) [[0,1] [0,2] [1,2]]
#     '''
#     위는 계산을위한 준비과정.ㅡ
#     알고리즘은 위의 함수
#     dp는 아래 리스트와 위의 함수 일부입니다.
#     '''
#
#     '''
#     이 부분이 DP 의 시작점.
#     DP는 피보나치 수열을 예로 들어서 생각하면 편한데.
#
#     피보나치수열에서 5번째 수열을 계산하려면, 3,4 계산 => 1,2 계산 2,3, 계산 => 1,2계산 등으로 1,2와 같이 중복해서 계산되는것이많다.
#     ##우리 시험에서 피보나치수열 f(5)를 계산하려면 f(1)은 볓번 계산해야하고 f(2)는 몇번 계산해야하는가문제와같이##
#     이는 숫자가 커지면 커질수록 1,2,는 물론 3,4,5 등의 숫자도 반복이 엄청되고 이때마다 똑같은 계산을 하는것을 불필요하다고 생각한것이
#     DP.
#     DP는 앞서 말한 피보나치수열에서 f(1)의 값을 한번 계산하면, 앞으로 더이상 계산하지 않도록 특정한 곳에 저장을 해놓고
#     f(1)을 또 계산할 일이 있다면 저장한 곳에서 f(1)이 있는지 찾아보고, 있다면 해당값을꺼내온다.
#     없다면 계산하면 그뿐
#     이렇게 한번계산한 것은 다시 계산하지 않도록 하는게 DP이다.
#     '''
#     cache = [{} for _ in
#              range(K + 1)]  # 이것이 DP를 사용하기위한 저장소. 이 cache리스트에는 필요한 깊이만큼의 {}, 사전이 존재한다. 이 사전내에 필요한 데이터를 저장할예정.
#
#     print(f'#{round + 1} {max_prices(0,number)}')