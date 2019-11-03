'''
문제 5.
표준 입력으로 물품 가격 여러 개가 문자열 한 줄로 입력되고, 각 가격은 ;(세미콜론)으로 구분되어 있습니다.
입력된 가격을 높은 가격순으로 출력하는 프로그램을 만드세요.
# 입력 예시: 300000;20000;10000
'''

prices = input('물품 가격을 입력하세요: ')

# 아래에 코드를 작성해 주세요.
# 문자열 => 리스트로 형변환을 하는게 포인트.
makes = prices.split(';')

boxes = []
for make in makes:
    boxes.append(int(make))
print(boxes)

boxes.sort(reverse=True)

for box in boxes:
    print(box)

# 리스트에 요소를 추가하는 메서드 .append()
# list.append(1) 리스트에 1을 추가한다.