# 1. 변수에 만들고 싶은 파일을 open() 해야 한다.
# open() 할때 r: 읽기 / w: 쓰기(+덮어씌워짐) / a: 추가
f = open('ssafy.txt', 'w')
for i in range(10):
    f.write(f'This is line {i+1}.\n')
f.close()

# with 구문 (context manager)
with open('with_ssafy.txt', 'w') as f:
    for i in range(10):
        f.write(f'This is line {i+1}.\n')

# writelines() : list 를 넣어주면, 요소 하나당 한 줄씩 작성한다.
with open('ssafy.txt', 'w') as f:
    f.writelines(['0\n', '1\n', '2\n', '3\n'])


# 이스케이프 문자
# \n : 개행문자(다음 줄 이동)
# \t : 탭문자
# \\ : 백슬래쉬를 사용하기 위해
# \' : 따옴표
# \" : 쌍따옴표