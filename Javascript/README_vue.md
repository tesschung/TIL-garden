

[TOC]



공부 순서

- Vue pdf
- README_vue



```
## vue과목평가

#### 수업내용 + vue 공식문서 읽어보기
• 보간법 (Interpolation), 디렉티브, 약어 등 템플릿 문법
• Computed, watch 등 vue 속성들과 특징
• 기타 vue 기초부터 유튜브 전까지의 모든 범위를 평가 (유튜브 미 포함) (edited) 
- vue 인스턴스의 속성
- 템플릿 문법
- 디렉티브
- computed와 watch
- 조건부 렌더링
- 리스트 렌더링
- 이벤트 핸들링
- 폼 입력 바인딩
- 컴포넌트 구조, props, emit

#### 프로젝트

- pjt09, youtube browser 프로젝트에서 props와 emit 이해하기
```



### Vue pdf









### README_vue

1. `watch`가 답

2. v-bind
   - `속성`을 다룰 때 사용

3. v-show
   - 디렉티브 v-show는 조건과 관계없이 항상 렌더링된다. `v-show`는 렌더링 되고 `display: none`으로 처리된다.
4. v-if
   - v-if 는 조건문을 만족할 경우에만 렌더링된다. 즉, `v-if` 는 false면 렌더링 자체가 되지 않는다.
5.  v-for, v-if 를 묻는 문제 답은 `124578`

6. `v-model`
   - `input/textarea`와 같은 요소에서 사용자 입력과 `양방향 데이터 바인딩`을 공유
   - html의 초기값인 `value, checked, selected`를 무시

7. {{}} 인터폴레이션/보간법
  
   - `{{ }}` 안에 표현할 수 있는 것은 수렴하는 표현이다. 
   
   - expression이 아닌 statement는 하나의 값으로 수렴하지 못하므로 선언문 등은 못 쓴다.
   - 함수의 리턴값으로 쓸 수 있는지 기준으로 판단하면 간단하다.
   - Vue template에 표현할 때 `{{ const number = 1 }}`는 불가하다. 함수의 return 값으로 쓸 수 있는 것들만 쓸 수 있다.
8. 파라미터로 함수를 넘겨줄 수 있는 개념이 들어간 것. 답은 `7`
9. 답은 `post.content.data`로 시작하지 않아요. -> post.data.content 일듯

7. 안에 H1태그가 있기 때문에 적용하려면 `V-HTML` 명령어를 쓴다. 답은 `V-HTML`. 

```html
<template>
<div id="app">
  <p v-html="message"></p>
</div>
</template>

<script>
export default {
  name: 'app',
  data () {
    return {
      message: '<h1>hi</h1>',
    }
  }
}
</script>
```

**hi**

8. 답은 `app.$el.` 엘리먼트 가져올려면 달라만 된다.

9. `v-on:click`으로 method 실행하는 방법
- `@click`
  - @dbclick
  - @mouseover
  - @mousedown
  - @mouseup
  - @keydown
  - @keyup
  - @keypress
  - @change
  - @input
  - @submit
  - @reset
  - @select
  - @focus
  - @blur
  
10. v-for

  - data에서 값을 가져와서 어떻게 반복문을 사용하는지
  - for 반복문을 구현한다. `v-bind:key`가 필요!

11. data

   - Vue 인스턴스의 data 속성에 어떻게 접근하는지
   - props!

12. props로 자식파일에서 부모파일이  넘겨준 데이터 저장하는 방법

	- 부모파일에 export default안 components에 자식파일 추가후 html태그에 <Movieitem :movie="movie"> 이런식으로 하여 전달하고, 해당 이름을 자식파일에서 props로 등록한다.
13. v-bind:  속성

