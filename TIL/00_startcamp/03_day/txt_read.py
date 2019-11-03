# read() : 개행문자를 포함한 하나의 문자열
with open('with_ssafy.txt', 'r') as f:
    all_text = f.read()
    print(all_text)

# readlines() : 파일의 모든 라인을 읽어서 각각의 줄을 요소로 갖는 list 로 만들어냄
with open('with_ssafy.txt', 'r') as f:
    lines = f.readlines()
    for line in lines:
        print(line.strip())
        # print(dir(line))
