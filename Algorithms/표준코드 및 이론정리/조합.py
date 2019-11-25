def combi(k, s): # 깊이, 시작숫자
    if k == R:
        print(t)

        for i in range(R-1):
            for j in range(i+1, R):
                print(i,j)

        return
    else:
        for i in range(s, N-R+k):
            t[k] = numbers[i]
            combi(k+1, i+1)

# 조합생성시에는 visit가 없다.
numbers = [1, 2, 3, 4, 5, 6]
N = len(numbers)
R = N//2
t = [0]*R
combi(0, 0)