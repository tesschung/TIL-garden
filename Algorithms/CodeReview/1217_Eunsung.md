## 1217_Eunsung

### 거듭 제곱

```python
두 개의 숫자 N, M이 주어질 때, N의 M 거듭제곱 값을 구하는 프로그램을 재귀호출을 이용하여 구현해 보아라.
```



### 코드

```python
def jegop(x, n):
    if n == 1:
        return x
    return x * jegop(x, n - 1)

for rounds in range(1,11):
    ro = int(input())
    x, n = map(int,input().split())

    print(f'#{rounds} {jegop(x, n)}')
    
```



**재귀함수**

```python
def jegop(x, n):
    if n == 1:		# n 이 1이 될때까지
        return x
    return x * jegop(x, n - 1)
```

```python
# example x = 4, n = 3
def jegop(4, 3):
    if n == 1:
        return x
    return 4 * jegop(4, 3)

def jegop(4, 3):
    if n == 1:		
        return x
    return 4 * jegop(4, 2)

def jegop(4, 1):
    if n == 1:		# n = 1 
        return 4
    return x * jegop(x, n - 1)

----------------------------------------------------------------------

return 4
return 4 * 4
return 4 * 4 * 4

결과적으로 64가 반환됨
```

