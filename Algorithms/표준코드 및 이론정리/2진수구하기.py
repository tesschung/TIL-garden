message = ['C']
mycandidate = ""
for i in range(len(message)):
    ms = ord(message[i]) # 아스키코드값을 구한다.
    binary = ""
    # 2로 나눠가면서 나머지를 binary에 넣는데,
    # 남은 숫자가 0이 될때까지 반복하고,
    # 0이 되면 나머지들을 역순으로 출력하여 mycandidate에 추가한다.
    while ms > 0:
        remainder = ms % 2
        binary += str(remainder)
        #ms = ms // 2
        ms = ms >> 1 # 위와 동일하게 작동한다.
        # 모든 비트를 1비트씩 오른쪽으로 이동한다는 뜻이다.
        print(ms)

    if len(binary) == 6:
        binary += '0'
    mycandidate += binary[::-1]
# print(mycandidate)
# 앞이랑 바로 뒤랑 비교

myres = ""
pre_bit = "" # 비교 대상이 될 문자열
for idx in range(len(mycandidate)):
    if mycandidate[idx] != pre_bit:  # 1 != ''  # 0 != 1 # 0 != 0
        if mycandidate[idx] == '0':  # 0 == 0
            myres += ' 00 '  # 0 0 00
        elif mycandidate[idx] == '1':  # 1
            myres += ' 0 '
    myres += '0'  # 0 0 # 0 0 00 0 # 0 0 00 00
    pre_bit = mycandidate[idx]  # 1 # 0
print(myres[1:])



# 4 >> 2 나누기 연산
# 2 << 1 곱하기 연산
f = 4 >> 2
print(f)
s = 2 << 1
print(s)