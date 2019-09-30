import sys
sys.stdin = open('1213.txt', 'r')

# .find() 는 스트링 안에서의 검색 데이터에 대한 위치를 반환한다.

def stringSearch(a, b):
    count = 0
    while True:
        start = b.find(a)
        if start == -1:
            return count
        else:
            b = b[start+len(a):]
            count += 1

tc = input()
target = input()
search = input()
print(tc, target, search)
print(f'#{tc} {stringSearch(target, search)}')
