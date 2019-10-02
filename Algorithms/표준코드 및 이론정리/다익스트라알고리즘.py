'''
https://m.blog.naver.com/PostView.nhn?blogId=baeusa1&logNo=221241404090&proxyReferer=https%3A%2F%2Fwww.google.com%2F
'''

# 다익스트라 알고리즘을 통해서 최소 비용(가중치) 구하기
# 입력: 가중치가 있는 그래프
# 출력: start부터 fin까지의 최소거리

infinity = float('inf')
graph = {} # 정점들을 연결하고, 그 이웃의 가중치 표시
graph['you'] = ['alice', 'bob', 'claire']
graph['start'] = {}
graph['start']['a'] = 6
graph['start']['b'] = 2
graph['a'] = {}
graph['a']['fin'] = 1
graph['b'] = {}
graph['b']['a'] = 3
graph['b']['fin'] = 5
graph['fin'] = {}
costs = {} # 출발점부터 fin까지의 가격을 나타냄
costs['a'] = 6
costs['b'] = 2
costs['fin'] = infinity
parents = {} # 부모를 위한 해시테이블
parents['a'] = 'start'
parents['b'] = 'start'
parents['fin'] = None
processed = []

def find_lowest_cost_node(costs):
   lowest_cost = float('inf')
   lowest_cost_node = None # None으로 초기화해주어야 return값이 None이 나옴
   for node in costs:
       cost = costs[node]
       if cost < lowest_cost and node not in processed:
           lowest_cost = cost
           lowest_cost_node = node
   return lowest_cost_node
node = find_lowest_cost_node(costs)

while node is not None:
   cost = costs[node]
   neighbors = graph[node]
   for n in neighbors.keys():
       new_cost = cost + neighbors[n]
       if costs[n] > new_cost:
           costs[n] = new_cost # 최소 costs를 업데이트
           parents[n] = node
   processed.append(node)
   node = find_lowest_cost_node(costs)
print('min_cost', cost)
print('parents', parents)