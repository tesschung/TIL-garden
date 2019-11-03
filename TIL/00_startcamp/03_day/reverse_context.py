# DOCstring
"""
다음과 같은 내용의 파일 quest.txt 가 있다.
0
1
2
3

이 파일의 내용을 다음과 같이 역순으로 reverse_quest.txt 라는 파일로 저장하시오.
3
2
1
0

"""

# 1. 읽고
with open('quest.txt', 'r') as f:
    lines = f.readlines()

# 2. 뒤집고
lines.reverse()

# 3. 작성하고
with open('reverse_quest.txt', 'w') as f:
    for line in lines:
        f.write(line)

with open('reverse_quest.txt', 'w') as f:
    f.writelines(lines)