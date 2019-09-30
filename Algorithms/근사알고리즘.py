states_needed = set(["mt", "wa", "or", "id", "nv", "ut", "ca", "az"])

stations = {}
stations["Kone"] = set(["id", "nv", "ut"])
stations["Ktwo"] = set(["wa", "id", "mt"])
stations["Kthree"] = set(["or", "nv", "ca"])
stations["Kfour"] = set(["nv", "ut"])
stations["Kfive"] = set(["ca", "az"])

final_stations = set()

while states_needed: # 방송되어야 하는 states들의 리스트들이 모두 방송될때 while문은 종료된다.
    best_station = None # 방송이 필요한 states들중에 가장 많이 방송 할 수 있는 방송국이 best_station이 된다.
    states_covered = set() # 해당 방송국이 방송을 할 수 있는 states를 넣는다.
    for station, states in stations.items(): # 딕셔너리를 돌면서,
        covered = states_needed & states # 교집합이 가장 큰게 가장 방송을 많이 할 수 있는 방송국이다.
        if len(covered) > len(states_covered):
            best_station = station
            states_covered = covered
    print(best_station)

    # for문이 한 번 끝나면 best_station 과 states_covered에 데이터를 들고 올 것
    states_needed -= states_covered
    final_stations.add(best_station)
print(final_stations)