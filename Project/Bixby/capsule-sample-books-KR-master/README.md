<p align="Center">
  <img src="https://bixbydevelopers.com/dev/docs-assets/resources/dev-guide/bixby_logo_github-11221940070278028369.png">
  <br/>
  <h1 align="Center">Bixby Book Search Sample Capsule</h1>
</p>

## Overview

간단한 구글 Book API를 이용한 책 검색 캡슐입니다.
해당 캡슐을 통하여 Bixby OAuth 설정법, Image library, $vivContext 등의 사용법을 알아볼 수 있습니다.

## Example Flow 예시

```
알고리즘 책 찾아줘
```

## Google OAuth 등록 및 사용
1. https://console.developers.google.com/ 접속
2. 사용자 인증 정보로 이동
3. OAuth 동의 화면으로 이동 및 필요한 부분의 데이터 채우기 및 저장
    - Google API의 범위 https://www.googleapis.com/auth/books 추가 (참조: https://developers.google.com/identity/protocols/googlescopes?hl=ko)
    - 승인된 도메인 aibixby.com 추가
    - 테스트용 OAuth 사용: 어플리케이션 이름, 범위 변경 및 승인된 도메인만 작성하고 저장만 진행하여도 100개의 계정의 한하여 OAuth를 사용가능
4. 사용자 인증 정보 만들기 -> OAuth 클라이언트 ID
5. 웹 어플리케이션 선택
6. 승인된 리디렉션 URI에 https://example-books.oauth.aibixby.com/auth/external/cb 등록 및 저장
    - 리디렉션 URI의 경우 아래의 규칙을 따른다
      - https:// + Team Name + - + Capsule Name + .oauth.aibixby.com/auth/external/cb 
      - (ex] https://example-books .oauth.aibixby.com/auth/external/cb)
7. authorization.bxb에 필요 정보 작성 (참조: https://developers.google.com/identity/protocols/OAuth2WebServer?hl=ko) & Developer Center에서 capsule의 Confing & Secrets에 OAuth Secrets 저장

---

## Additional Resources

### Bixby에 대한 모든 것
* [Bixby Developer Center](http://bixbydevelopers.com) - Bixby 캡슐을 시작하기 위한 모든 것이 있습니다.

### Guides & Best Practices
* [Quick Start Guide](https://bixbydevelopers.com/dev/docs/get-started/quick-start) - Bixby의 첫 캡슐을 만들어보세요.
* [Design Guides](https://bixbydevelopers.com/dev/docs/dev-guide/design-guides) - Bixby 캡슐을 디자인하기 위한 Best practices들을 배워보세요.
* [Developer Guides](https://bixbydevelopers.com/dev/docs/dev-guide/developers) - Bixby 캡슐을 만들기 위하여 필요한 A-Z를 배울 수 있습니다.

### Video Guides
* [Bixby Developer Day Korea 2018](https://www.youtube.com/playlist?list=PL7PfK8Mp1rLH0vLvT0yv5VXh_3x2bCUHl) - Bixby Developer Day Korea에서 진행되었던 세션들을 만나보실 수 있습니다.

### 도움이 필요하신가요?
* 기능을 추가하고 싶으신가요? [Support Community](https://support.bixbydevelopers.com/hc/en-us/community/topics/360000183273-Feature-Requests)에 기능을 건의하여 주세요. 동일한 내용을 다른 분들이 이미 올렸다면, Vote 기능을 통해 추천을 해 주세요.
* 기술적인 지원이 필요하신가요? support@bixbydevelopers.zendesk.com으로 이메일을 통하여 질문하여 주시거나 또는 [Stack Overflow](https://stackoverflow.com/questions/tagged/bixby)에 “bixby” 태그와 함께 질문하여 주세요.
