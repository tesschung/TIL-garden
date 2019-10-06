# 빅스비

Requirement for Bixby project:

`Bixby Language`, `node.js`, `Javascript`, `MySQL`, `Django`, `UI&UX`



발화컨셉->액션->출력액션 하는 모델링정의

---

## 1강

### Action

- action (action name)
- type (action type) : 액션 검색시 힌트
- Input (입력값 지정 부분-> 변수명은 액션에서 사용될 별칭, min&max -> input 몇 개 받을지 결정)

Min(required) -> 반드시 발화안에 없으면 되물음

Max(one, many)

### concepts는 2종류

1. **Primitives** (자료형): simple types, like text or numbers

- `boolean`: A binary variable with two possible values, `true` and `false`.

- `decimal`: A floating-point number, positive or negative. This type allows a decimal part.
- `enum`: An enumeration of a fixed set of possible values (symbols). Use this when it makes sense to list all the possible values in advance. (Also see [structure enums](https://bixbydevelopers.com/dev/docs/dev-guide/developers/modeling.modeling-concepts#structure-enums).)
  - If there is no [vocab](https://bixbydevelopers.com/dev/docs/dev-guide/developers/training.vocabulary) file, the enums will not be recognized by natural language.

- `integer`: A whole number, positive or negative, with no decimals.
- `name`: A Unicode string that is available to Bixby. Use this when the string might be part of natural language input, dialog, or [vocabulary](https://bixbydevelopers.com/dev/docs/dev-guide/developers/training.vocabulary#adding-vocabulary). Examples include business names, menu items, and movie titles.
- `qualified`: A `name` that matches a regular expression. This is a good choice when you want to validate a string, and want it to be visible to Bixby, but can't enumerate every possible value in advance. The regex also makes it easier for Bixby to recognize valid values.
- `text`: A Unicode string that is **not** available for use with [vocabulary](https://bixbydevelopers.com/dev/docs/dev-guide/developers/training.vocabulary#adding-vocabulary), although it can be displayed or passed to external services. This is good for URLs, blocks of XML or JSON, and large blocks of text such as movie or restaurant reviews.

```python
boolean (SeatHasPower) {
  description (콘센트 있는 좌석이야?)
}

decimal (CurrencyValue) {
  description (The value part of the currency.)
}

enum (Season) {
  description (Names of the seasons)
  symbol (Spring)
  symbol (Summer)
  symbol (Autumn)
  symbol (Winter)
}

integer (Quantity) {
  description (How many to buy.)
}

name (BusinessName) {
  description (The name of a business.)
}

qualified (PhoneNumber) {
  description (A string representing a phone number.)
  regex-pattern ("\\+?1? ?-? ?((\\(\\d\\d\\d\\))|\\d\\d\\d)? ?-? ?\\d\\d\\d ?-? ?\\d\\d\\d\\d")
}

text (MapUrl) {
  description (Contains an URL to a map of the business)
  extends (entity.EntityUrl)
}
```



### TEXT

### Child Keys

description
optional
Adds text describing the primitive concept, which is useful in describing how a primitive can be used

equivalence
optional
A primitive equivalence policy specifies how the system should compare two instances of the same concept

extends
optional
Extends a parent concept with a new child concept, which inherits all of the parent properties

features
optional
Marks a concept with special concept features for user preferences, privacy, or security

named-consumer
optional
Named consumers allow explicitly linking a concept to an action

role-of
optional
There are cases where you want to assign a specific role to a feature, but not extend the feature

#### text안의 child-key중 하나 role-of

Role assignment

 can give a concept the `role-of` another concept to change its behavior based solely on context.

특정 라이브러리에서 불러올때, 그 라이브러리가 가지는 concept의 사용방법을 맥락에 따라 바꾸기 위해 role-of 지정

```python
structure (Point) {
  description (위도, 경도를 저장하는 geo 캡슐의 NamedPoint를 복제하였습니다)
  // 참조 (https://bixbydevelopers.com/dev/docs/dev-guide/developers/library.geo#points)
  role-of (geo.NamedPoint)
}
```



1. **Structure**: more complex, representing records with named properties

    -> python에서 OOP하는것과 동일하게 생각하면된다. class짜는것, Primitives는 각 property들이고, 또 다른 것들의 class가 될 수 있다.

- structure가 갖게되는 property또한 스스로 의미를 갖고 있기때문에 concept로 분류한다.
- c의 구조체
- structure안에 property가 있음. structure에서 사용될 concept이름을 지정
- Type: concept이름
- Min&max 해당 structure에서 가질 수 있는 이 concept의 개수



### Extensions

- can `extend` a parent concept with a new child concept. 

### Lazy Properties



### JavascriptAPI/http requests

https://bixbydevelopers.com/dev/docs/reference/JavaScriptAPI/http

### http.getUrl(url, options)

Perform an HTTP GET request. By default, the return value is a string (equivalent to setting the `format`option to `text`); this can be changed by using a different `format` option in the [`options`](https://bixbydevelopers.com/dev/docs/reference/JavaScriptAPI/http#http-options) argument.

**Kind**: Static method of `http`
**Access**: Public

| Param     | Type     | Description                                                  |
| :-------- | :------- | :----------------------------------------------------------- |
| *url*     | `String` |                                                              |
| *options* | `Object` | See [HTTP options](https://bixbydevelopers.com/dev/docs/reference/JavaScriptAPI/http#http-options) |

For an example of using `http.getUrl()`, read [Calling a Web Service from a Local Endpoint](https://bixbydevelopers.com/dev/docs/dev-guide/developers/actions.configuring-endpoints#calling-a-web-service-from-a-local-endpoint).

### 





---

## 2강 1차시

### 빅스비 값 검증 및 처리

- Validation: input 값이 의도대로 저장되었는지를 검증



## 2강 2차시



---

## 6강 Bixby Capsule Endpoints

### 1차시 Bixby Capsule Endpoints

Endpoints: 

- Modeling(Concept, Action)과 Business Logic(JavaScript)를 연결
- `Bixby Language` 사용

Endpoints 종류:

- Local Endpoint: 내부 자바스크립트 파일에서 api호출

액션과 자바스크립트 파일을 연동

- Remote Endpoint :자바스크립트 파일을 거치지 않고 직접 api호출

직접 외부서버 연동



### 2차시 Bixby Capsule로 외부서버 연동하기

api를 호출하여 받아오는 데이터를 출력하는 output 컨셉필요

---

Library capsule

개발팀에서 지원

computed-input -> 사용자에게 보이지 않고 빅스비 내부적으로 사용, 개인민감성 정보

---

Geo Capsule

https://github.com/bixbydevelopers/capsule-sample-earthquake-insights

Geo Library

https://bixby.developer.samsung.com/newsroom/en-us/When-and-Where-Mastering-DateTime-and-Geo-Libraries

https://bixby.developer.samsung.com/newsroom/ko-kr/21/05/2019/Bixby

Centroid: `centroid` in `Address` is [lazily sourced](https://bixbydevelopers.com/dev/docs/dev-guide/developers/modeling.modeling-concepts.lazy-properties) when there is sufficient information in other properties to determine a specific `GeoPoint`.

fetch 가져오는 action

Geo 라이브러리 사용해서

예술의 전당을 검색하면 지도를 주도록 하기



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

http://bixbydeveloperday.developer.samsung.com/asset/images/BixbyDeveloperDay_01.pdf





---

8명

지금

공통: 빅스비 흐름공부

------

- 모델링/명세서작성(concept/action정의) 

  희철 승원 인동

  - 요리보고처럼 concept/action 정리
  - 명세서 정리
  - 모델링 마치면 DB등으로 넘어갈 것
  - 프로젝트 코드들 통합하는 역할
  - github등 모든 팀원들이 서로 코드등 협업하기 편한 협업방법 구상 -> 
  - github 프로젝트 그룹 파야하나? 0
  - 협업하는 방법 정리..?

------

- DB(빅스비httpAPI사용법(크롤링), 외부DB연동법)

  3명 권응 은성 현화

  - Mock api: swagger

    API Reference for Developers(Swagger)

    https://jojoldu.tistory.com/31

  - 빅스비httpAPI사용법(크롤링)

    참고자료

    HttpRequest

    https://bixbydevelopers.com/dev/docs/sample-capsules/samples/http

    https://github.com/bixbydevelopers/capsule-samples-collection/tree/master/http-api-calls

  - .js팀과 후에 같이 작업

  - Mysql

------

- 모델링팀에서 정의한 action에 따라 .js코드 작성 및 endpoints(.js랑 모델링 연동)

  2명 가영 혜준 

  - action에 따른 .js코드 작성법 문법 마크업
  - 에러처리방법 이해



나중

- ui/ux
- 자연어 training



[https://bixby.developer.samsung.com/newsroom/ko-kr/%EA%B3%B5%EC%A7%80%EB%B9%85%EC%8A%A4%EB%B9%84%EC%BA%A1%EC%8A%90%EC%B1%8C%EB%A6%B0%EC%A7%80-%EC%8B%9C%EC%A6%8C2-%EC%9D%91%EB%AA%A8%EA%B0%80%EC%9D%B4%EB%93%9C](https://bixby.developer.samsung.com/newsroom/ko-kr/공지빅스비캡슐챌린지-시즌2-응모가이드)

**3) 캡슐 등록/제출 및 리뷰**

https://drive.google.com/file/d/1oPZ2hY1X2EKgyWcsPU3VZ-DgC4t2_njT/view

1) Bixby Developer Center에 개발된 캡슐 등록
2) Bixby Developer Studio에서 캡슐 제출 (Public Submission)
3) Bixby Developer Center에서 캡슐 리뷰 요청, 리뷰 Fail 시 수정 후 다시 제출 필요
캡슐 리뷰 요청 전, 캡슐 체크리스트를 꼭 확인하세요!

**4) 제안서 제출**
빅스비 개발자 포털 뉴스룸에서 제안서 제출
기간 : 9월 2일 (월) 09:00 ~ 10월 28일 (월) 23:59
[[제안서 제출하러 가기\]](https://bixby.developer.samsung.com/events/ko-kr/캡슐-챌린지-제안서-제출하기)

[빅스비 캡슐 챌린지 시즌2 제안서 제출 정보] 시작

1. 공모 구분: 개인 참가자 (1인 또는 팀) / 법인 참가자 (1개 선택)
2. 법인명:
   (공모 구분에서 ‘법인 참가자’ 항목을 선택한 경우 기재)
3. 대표자명 (팀원 이름 도우 기재):
   ((예시) 홍OO (김OO, 강OO, 박OO))
4. 캡슐 ID:
   (Bixby Developer Studio에서 최종 제출한 캡슐의 캡슐 ID(namespace.capsulename)를 기재하세요.)
5. 제출한 캡슐의 최종 버전:
   (최종 제출한 캡슐의 버전을 입력하세요 (ex.0.1.0))
6. 캡슐 기능 소개:
   (제출한 캡슐의 기능에 대해 간단한 설명을 기재하세요.)
7. 대표 발화 (3개 이상)
   대표 발화#1:
   대표 발화#2:
   대표 발화#3:
   (대표 발화란 ? 제출하는 캡슐의 대표적인 기능들을 작동시킬 수 있는 발화.ex. <내일 날씨 알려줘>, <오늘 미세먼지 어때>, <다음주 일정 알려줘>)

- 참가 신청 접수 : 2019년 9월 2일 ~ 10월 28일
- 개발 및 제안서 제출 : 2019년 9월 2일 ~ 10월 28일
- 내부 심사 : 2019년 10월 29일 ~ 11월 7일
- 입선/결선 진출팀 발표: 2019년11월 8일
- 결선 PT 및 시상식 : 2019년11월 21일



https://www.kopis.or.kr/mob/cs/kopis/kopis.do

Data 수집용







배포방법

1. 팀 등록

   https://bixbydevelopers.com/dev/marketplace

2. 팀원 등록
3. 