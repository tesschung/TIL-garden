# 빅스비

Requirement for Bixby project:

`Bixby Language`, `node.js`, `Javascript`, `MySQL`, `Django`, `UI&UX`



발화컨셉->액션->출력액션 하는 모델링정의

---

## 1차시

### action

- action (action name)
- type (action type) : 액션 검색시 힌트
- Input (입력값 지정 부분-> 변수명은 액션에서 사용될 별칭, min&max -> input 몇 개 받을지 결정)

Min(required) -> 반드시 발화안에 없으면 되물음

Max(one, many)

### concept

1. Primitives (자료형)

- boolean
- decimal
- integer
- Enum (열거가능한문자열을 저장하는 타입)
- name (짧은 문자열을 저장하는 타입)

1. Structure

- c의 구조체
- structure안에 property가 있음. structure에서 사용될 concept이름을 지정
- Type: concept이름
- Min&max 해당 structure에서 가질 수 있는 이 concept의 개수

---

## 2차시

### 빅스비 값 검증 및 처리

- Validation: input 값이 의도대로 저장되었는지를 검증







---

Private info.:

https://docs.google.com/spreadsheets/d/1NyRZ04q9c5ARa5Qfyf7C0l_EuzT47-w4-envIep8hDo/edit?userstoinvite=heecheol1508%40gmail.com&ts=5d845dff&actionButton=1#gid=1599666184

---

Reference:

https://bixby.developer.samsung.com/

https://www.youtube.com/watch?v=R3-0qvLlfRk&list=PL7PfK8Mp1rLHfo34qdadoAEUdL3Ns-HSx&index=19

https://github.com/bixef/document/tree/master/190605

https://github.com/node-schedule/node-schedule

https://github.com/bixbydevelopers/capsule-sample-books-KR/blob/master/code/GetBooks.js

https://schema.org/docs/full.html