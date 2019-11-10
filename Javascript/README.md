# Javascript

[TOC]

# 기본문법

## pop 

- 안에 넣은 숫자 상관없이 `맨뒤의 원소 pop`



## this

- Javascript(이하 Js)의 this는 python의 self와 다르게 주체적이지 못한 성질이 있다.
- 불리는 곳마다 그 성질이 달라진다.
- 때문에 Js는 this가 불리는 시점을 봐야한다.

```js
button.addEventListener('click', function(event){
  const area = 1
  //
})
```

- Arrow 함수에서 바인드를 풀어버리면 최상단으로 가버린다.

* *vue 에서의 this는 app을 가르킨다. 그래서 항상 바인드가 있어야하는데, Arrow 함수는 그걸 풀어버린다.

- `addEventListener` 두 번째 인자 함수를 기명으로 넣어도 제대로 동작한다.

  this는 클릭하든 button을 가리킨다. 

  this : `function`일 때는 button(불리는 곳의 객체. 수동적)

  arrow일 때는 window/global(불리는 곳(button)의 bind를 풀어버리고 최상단(브라우저에서는 window, node에서는 global 객체)를 가리킨다.)

  python의 self는 주체적 -> 스스로를 가리킴. js는 수동적이어서 불리는 곳을 가리킴.

  vue에서는 항상 `function`을 써라 -> this가 Vue app을 가리켜야하기 때문에 bind를 풀면 안된다.



## JS에서의 null

- `undefined`는 변수 선언만 하고 값을 할당하지 않은 상태, 자료형이 결정되지 않았다. 때문에 typeof로 확인시 `undefined`가 출력된다.
- `null`이라는 빈 값을 할당한 것이다. null값은 객체로 취급해서 object이다. 때문에 typeof로 확인시 `object`가 출력된다.

## {{}} 인터폴레이션

- `{{ }}` 안에 표현할 수 있는 것은 수렴하는 표현이다. 

- expression이 아닌 statement는 하나의 값으로 수렴하지 못하므로 선언문 등은 못 쓴다. 

- 함수의 리턴값으로 쓸 수 있는지 기준으로 판단하면 간단하다.

- Vue template에 표현할 때 `{{ const number = 1 }}`는 불가하다. **함수의 return 값**으로 쓸 수 있는 것들만 쓸 수 있다.



## `v-if` 와 `v-show` 

`v-if` 와 `v-show` 차이는 렌더링 자체 여부가 다름. show를 콘솔로 찍어보면 `display: none`가 나온다.

`v-if` 는 false면 렌더링 자체가 되지 않는다. `v-show`는 렌더링 되고 으로 처리됨.

## Js object 가져오기

- Js object를 가져올땐 `get 메소드는 없다.`



## 기본 문법: Js.pdf summary

### var let const

`전역변수` (global variable)
`지역변수` (local variable)

- var, let, const의 차이점 - rebind, scope 등

  - `var`은 function scope
  - `let` 과 `const`는 block scope

  - 변수 type 지정하지 않으면 global 변수라고 보면 된다.

```js
for (var j=0; j < 1; j++) {
    console.log(j) // 0
}
console.log(j) // 1

for (let i=0; i<1; i++) {
    console.log(i) // 0
}
// console.log(i) // i is not defined

const myfunction = function () {
    for (var k=0; k < 1; k++) {
    console.log(k) // 0
    }
console.log(k) // 1
}
myfunction()
// console.log(k) // k is not defined
```

- `재선언` 여부
  - `var`은 재선언 가능
  - `let`과 `const`는 재선언 불가능

```js
var a = 1
var a = 2

let b = 1
// let b = 2 // SyntaxError

const c = 1
// const c = 2 // SyntaxError
```



- `재할당` 여부
  - `let`은 재할당 가능
  - `const`는 재할당 불가능

```js
let d = 3
d = 5

const e = 5
// e = 3 // TypeError

// 따라서 const는 선언시 반드시 할당을 해야한다.
// const f // SyntaxError

// let은 선언시 할당하지 않고 선언만 해도 된다.
let g
g = 3
```

**const는 선언시 반드시 할당해야한다는 점이 중요**



- 따라서,

위의 `변수 선언 키워드(const, let)를 사용하지 않으면 함수/블록안에서 선언되더라도 무조건 전역변수로 취급`된다.

```js
function myfunction1 () {
    for (p=0; p<1; p++) {
        console.log(p)
    }
    console.log(p)
}
myfunction1()
console.log(p) // 1
```

그래서 무조건 변수 선언 키워드를 작성! const를 기본적으로 사용! let을 사용해야하는 상황에 한하여 변경!


### 자료형

```js
console.log(typeof Boolean) // function
console.log(typeof null) // object
console.log(typeof undefined) // undefined
console.log(typeof Number) // function
console.log(typeof String) // function
let ad = []
console.log(typeof ad) // object
console.log(typeof NaN) // Number
console.log(typeof Infinity) // Number
```

`typeof null` = `object`

- ex. `typeof function() {}`, `typeof "abc"`, `typeof function() { return "hello" } ()`, `typeof typeof function() {}`, `typeof NaN`, `typeof Infinity`

### 조건/반복

`if/ else if/ else`

```js
let adc = 1
if (adc === 1) {
    console.log('adc는 1입니다.') 
}else if (adc !== 1) {
    console.log('adc는 1이 아닙니다.')
} else {
    console.log('adc는 아무것도 아닙니다.')
}
// adc는 1입니다.
```

`while`

```js
value = 0;
while (value < 5) {
    console.log(value + '번째 반복');
    value++;
}
/*
0번째 반복
1번째 반복
2번째 반복
3번째 반복
4번째 반복
*/
```

`for`

```js
var array = ['포도', '사과', '바나나', '망고'];

for (var i = 0; i < array.length; i++) {
    console.log(array[i]);
}
/*
포도
사과
바나나
망고 
*/
```

`for of`

```js
for (const item of array) {
    console.log(item)
}
/*
포도
사과
바나나
망고
 */
```



### 등호

등호 작동방식

- `==` 대신 `===`를 쓰는 이유

== 은 `값`만 비교한다. ( 값이 같으면 true 틀리면 false)

=== 은 `값`뿐만이 아니라 `타입`도 비교한다. (값과 타입이 같으면 true 틀리면 false)

1. ==는 타입과 상관없이 비교하고 ===는 타입까지 비교한다
   "185.3" == 185.3 => true
   "185.3" === 185.3 => false
2. undefined와 null 의 비교
   undefined == null => true
   undefined === null => false



## 배열 - Object

```js
const numbers = [1, 2, 3, 4]

console.log(numbers[0]) // 1
console.log(numbers[-1]) // undefined
console.log(numbers.length) // 4

a = numbers.reverse() // 원본이 바뀐채로 내려온다.
console.log(a) // [ 4, 3, 2, 1 ]
console.log(numbers) // [ 4, 3, 2, 1 ]

numbers.push('a')
console.log(numbers) //[ 4, 3, 2, 1, 'a' ] 맨뒤에 추가된다.
ax = numbers.pop()
console.log(ax) // a 맨뒤의 a가 pop된다.
console.log(numbers) // [ 4, 3, 2, 1 ]

numbers.unshift('a') 
console.log(numbers) // [ 'a', 4, 3, 2, 1 ] 맨앞에 추가된다.

ac = numbers.shift()
console.log(ac) // a 맨앞의 a가 shift된다.
console.log(numbers) // [ 4, 3, 2, 1 ]

// includes : 찾는 원소가 존재하는지 true/false로 반환한다.
ans1 = numbers.includes(1)
console.log(ans1) // true
ans0 = numbers.includes(0)
console.log(ans0) // false


numbers.push('a') // [ 4, 3, 2, 1, 'a']
numbers.push('a') // [ 4, 3, 2, 1, 'a', 'a' ]
console.log(numbers)
numbers.indexOf('a') // 4 처음 찾은 요소의 index를 반환
numbers.indexOf('b') // -1 찾는 요소가 없으면 -1을 반환

newarr = numbers.join()
console.log(newarr) // 4,3,2,1,a,a
console.log(numbers) // [ 4, 3, 2, 1, 'a', 'a' ] 원본 유지

newarr1 = numbers.join('') 
console.log(newarr1) // 4321aa
console.log(numbers) // [ 4, 3, 2, 1, 'a', 'a' ] 원본 유지

newarr2 = numbers.join('-')
console.log(newarr2) // 4-3-2-1-a-a
console.log(numbers) // [ 4, 3, 2, 1, 'a', 'a' ] 원본 유지

console.log(typeof numbers) // object
```



## Object

```js
// Key-Value로 이뤄져있는 데이터 구조이다.
const endGame = {
    title: 'avengers: End Game',
    'my-lovers': [
        {name: 'iron man', actor: '로다주'},
        {name: '헐크', actor: '마크 러팔로'}
    ]
}
// 아래와 같이 두 가지 방법으로 값을 불러올 수 있다.
console.log(endGame.title) // avengers: End Game
console.log(endGame['title']) // avengers: End Game
// console.log(endGame.my-lovers) // error

console.log(endGame['my-lovers']) // [ { name: 'iron man', actor: '로다주' }, { name: '헐크', actor: '마크 러팔로' } ]
console.log(endGame['my-lovers'][0].name) // iron man
```



```js
// Object Literal (ES6+)
const comics = {
    'DC': ['Aquaman', 'SHAZAM'],
    'Marvel': ['Captain Marvel', 'Avengers']
}
const magazines = null
const bookShop = {
    comics,
    magazines,
}

console.log(bookShop)

/* 
{
  comics: {
    DC: [ 'Aquaman', 'SHAZAM' ],
    Marvel: [ 'Captain Marvel', 'Avengers' ]
  },
  magazines: null
}
*/
```



### method

```js
// object의 value에 함수를 할당한다.
const me = {
    name: 'kim',
    greeting: function(message) {
        return `${this.name}: ${message}`
    }
}
me.greeting('hi') // kim : hi
me.name = 'John'
me.greeting('hello') // John : hello
console.log(me)
```



```js
// 아래와 같이 위에서 선언된 method를 object안에서 지역변수로서 사용 가능하다.
const greeting1 = function(message) {
    return `${this.name} : ${message}`
}
const you = {
    name: 'Yu',
    greeting1,
    bye() {
        return 'bye'
    }
}
you.greeting1('hi') // Yu : hi
you.name = 'Jane'
you.greeting1('hello') // Jane : hello
you.bye() // bye
```

- method 정의시에는 `arrow function`을 사용하지 않는다.



## JSON

JSON은 JS object와 같지 않다. 생김새가 비슷할 뿐.

때문에 실제로  object처럼 사용하기 위해서는 js에서 parsing하는 작업이 필요하다.



## 함수

```js

// 함수 선언식
function myFunc1 (name) {
    console.log('happy hacking')
    console.log(`${name}`)
}
console.log(myFunc1('lora'))  // undefined

// 함수 표현식
const myFunc2 = function (name){
    console.log('happy hacking')
    console.log(`${name}`)
}
console.log(myFunc2('lora'))  // undefined

typeof myFunc1 // function
typeof myFunc2 // function

// arrow function
const myFunc3 = (name) => {
    console.log('happy hacking')
    console.log(`${name}`) // lora
}
console.log(myFunc3('lora'))  // undefined
```



## syntactic sugar



- return 문이 한 개인 경우

// 작성필



- 인자가 없는 경우

// 작성필



- 인자가 하나인 경우

// 작성필



## Array Helper Methods

- forEach

```js
let fruits1 = ['apple', 'banana', 'peach', 'blue berry'];
fruits1.forEach(function(fruit) {
    console.log(fruit)
})
// apple
// banana
// peach
// blue berry
```

- `map`

```js
let fruits2 = ['apple', 'banana', 'peach', 'blue berry'];
// 새로운 변수에 담는다.
let juice = fruits2.map(function(fruit) {
    return fruit + ' juice'
})
console.log(juice) // [ 'apple juice', 'banana juice', 'peach juice', 'blue berry juice' ]
```

- `filter`

```js
let datas = [
    { id: 3, type: 'comment', content: '굿 모닝' },
    { id: 6, type: 'post', content: '좋은 아침이네요' },
    { id: 10, type: 'comment', content: '아침에는 시원한 물 한잔' },
    { id: 6, type: 'post', content: '공부하기 싫어요' }];
let filteredDatas = datas.filter( data => {
    return data.type === 'post'
})
console.log(filteredDatas)
// [
//     { id: 6, type: 'post', content: '좋은 아침이네요' },
//     { id: 6, type: 'post', content: '공부하기 싫어요' }
// ]
```

- find

```js
let datas1 = [
    { id: 3, type: 'comment', content: '굿 모닝', like: 1 },
    { id: 6, type: 'comment', content: '좋은 아침이네요', like: 5 },
    { id: 7, type: 'comment', content: '공부하기 싫어요', like: 30 },
    { id: 10, type: 'comment', content: '아침에는 시원한 물 한잔', like: 10 },
    { id: 15, type: 'comment', content: '저는 공부가 좋은데요?', like: 0 },
    { id: 16, type: 'comment', content: '여기 이상한 사람이 있어요', like: 15 }];
let ret = datas1.find(data => {
  	// 안에서 for문이 돈다고 생각하면 된다.
    return data.id === 10
})
console.log(ret)
// { id: 10, type: 'comment', content: '아침에는 시원한 물 한잔', like: 10 }
```

- every

```js
let scores = [
    { subject: '국어', point: '100' },
    { subject: '영어', point: '90' },
    { subject: '수학', point: '80' },
    { subject: '컴퓨터', point: '10' }];
let pass = scores.every(score => {
    return score.point > 70
})
console.log(pass) // false
```

- some

```js
let pass1 = scores.some( score => {
    return score.point > 70
})
console.log(pass1) // true
```

- reduce

```js
// 배열의 각 원소에 대해서 
// 첫번째 원소부터 마지막 원소 순으로 연산한 값이 줄도록 함수를 적용합니다.
let scores2 = [1, 2, 3, 4, 5]
let sum = scores2.reduce((sum, number) => sum + number, 0)
console.log(sum) // (((( 1 + 2 ) + 3 ) + 4 ) + 5) 15
```



## Dom

### EventListener

차이점 등 대략적으로 알아두기

![스크린샷 2019-11-08 오후 5.03.05](Javascript_summary.assets/스크린샷 2019-11-08 오후 5.03.05.png)



### DOM selector

querySelector() 

querySelectorAll()



### EventListener 예시

```js
// Dom element를 어떻게 한다.
const button = document.querySelector('#some-button')

button.addEventListener('click', function(event) {
  const area = document.querySelector('#my')
  area.innerHTML = '<h1>뿅</h>'
  console.log(this) // this는 본인(=> button)을 가르킨다. 
})
// 이벤트 리스너에서의 콜백함수는 arrow function을 사용하지 않는다.
```



### 기본활용법

```js
axios.get('/posts/')
.then(function(response) {
    console.log(response)
})
const data = {title: 'title', content: 'content'}
axios.post('/posts/', data)
.then(function(response){
    console.log(response)
})
```

- 파이썬 blocking과 자바스크립트 non-blocking의 차이점은 호출할때 알 수 있다. => 파이썬이랑 완전 다르게 동작한다.
  - 파이썬은 부르는 순서대로 출력한다면, Js는 그렇지 않다.

- `axios`는 `promise`객체를 반환하여 `.then` 을 통해 해당하는 작업이 완료된 경우 로직을 구현할 수 있다.(.catch에서는 reject된 결과를 받아서 처리할 수 있다.) - 콜백지옥을 해결
- 브라우저는 싱글쓰레드에서 `event driven 이벤트 기반` 방식으로 실행된다.
- `Call stack` : 함수가 호출되면 순차적으로 call stack에 쌓이고 순차적으로 실행된다. task가 종료되기 전까지는  다른 task를 수행할 수 없다.
- `Callback queue`: 비동기 처리 함수의 콜백, 타이머, 이벤트핸들러 들이 기록되는 곳으로 이벤트 루프에 의해 특정시점에 콜스택으로 이동되어 실행됨
- `event loop`: 콜 스택과 콜백 큐에 작업이 실행될 함수가 있는지 확인하며 작업을 실행
- promise는 빡세게 안나온다. `.then` 쓰는 방법만 대충 나온다.
- 개념 확인하기도 빡세게 안나오니까 가볍게 살펴볼 것.

- 맨 마지막 페이지 링크에서 비동기처리에 대해 살펴볼 수 있다.("Hi!" -> "Welcome")



## Ajax 및 django

- `Ajax(Asynchronous Javascript and XML, 에이잭스)`란 비동기적인 웹 애플리케이션의 제작을 위해 아래와 같은 조합을 이용하는 웹 개발기법이다. => `페이지의 요청 없이 특정 데이터 부분만 Javascript를 통해 바꾸는 기법` => 실시간으로 요청이 바뀌면서 표현가능하다.

  - 조합
    - 표현 정보를 위한 HTML/CSS
    - 동적인 화면 출력 및 표시 정보와 상호작용을 위한 DOM, JS
- Ajax 애플리케이션은 `필요한 데이터`만 웹서버에 요청해서 받은 후 클라이언트에서 데이터에 대한 처리를 할 수 있다.

- 웹서버 응답을 처리하기 위해서 `클라이언트 쪽에서는 자바스크립트`를 쓴다. 웹서버에서 전적으로 처리되던 데이터 처리의 일부분이 클라이언트 쪽에서 처리되므로 웹브라우저와 웹 서버 사이에 교환되는 데이터량과 웹서버의 데이터 처리량도 줄어들기때문에 애플리케이션의 `응답성이 좋아진다.`
- 한편, 웹 개발자들은 때때로 Ajax를 단순히 `웹 페이지의 일부분을 대체하기 위해 사용`한다. 비 Ajax 사용자가 전체페이지를 불러오는 것에 비해 Ajax 사용자는 `페이지의 일부분만 불러올 수가 있다`. 이것으로 개발자들이 비 ajax 환경에 있는 사용자의 접근성을 포함한 경험을 보호할 수 있다. 그리고 적절한 브라우저를 이용하는 경우, 전체 페이지를 불러오는 일 없이 응답성을 향상시킬 수 있다.



## 동등 연산자

```js
'0' == [] // false
0 == '0' // true
0 == [] // true
```





# Arrow function VS Function



- pdf 보면서 공부



## Javascript and Vue Points

- `let`, `const` vs `var`
```js
for (let i=0; i<1; i++) {
    console.log(i) // 0
}
// console.log(i) // i is not defined
```
:star:`block` 안에 `let`을 선언했기 때문에 block을 벗어나면 존재하지 않는 변수가 되어 오류발생

```js
let k = 3
const printK = () => {
    let k = 5
    function innerPrintK() {
        var k = 2
        console.log(k)
    }
    innerPrintK()
}
printK() // 2
```

:star: `2` 출력

```js
const test
test = 20
console.log(test) // SyntaxError: Missing initializer in const declaration
```

:star: 상수(`const`)인 test에 대해 처음부터 값을 할당하지 않아서 나타나는 에러

- `==` vs `===`
```js
0 == [] // true
'0' == [] // false
```

`==` 값만 비교

`===` 값뿐만 아니라 타입도 비교

:star: `0 == []` 중요

- array helper

forEach

```js
let fruits1 = ['apple', 'banana', 'peach', 'blue berry'];
fruits1.forEach(function(fruit) {
    console.log(fruit)
})
// apple
// banana
// peach
// blue berry
```

:star:`map`

```js
let fruits2 = ['apple', 'banana', 'peach', 'blue berry'];
// 새로운 변수에 담는다.
let juice = fruits2.map(function(fruit) {
    return fruit + ' juice'
})
console.log(juice) // [ 'apple juice', 'banana juice', 'peach juice', 'blue berry juice' ]
```

:star:`filter`

```js
let datas = [
    { id: 3, type: 'comment', content: '굿 모닝' },
    { id: 6, type: 'post', content: '좋은 아침이네요' },
    { id: 10, type: 'comment', content: '아침에는 시원한 물 한잔' },
    { id: 6, type: 'post', content: '공부하기 싫어요' }];
let filteredDatas = datas.filter( data => {
    return data.type === 'post'
})
console.log(filteredDatas)
// [
//     { id: 6, type: 'post', content: '좋은 아침이네요' },
//     { id: 6, type: 'post', content: '공부하기 싫어요' }
// ]
```

find

```js

let datas1 = [
    { id: 3, type: 'comment', content: '굿 모닝', like: 1 },
    { id: 6, type: 'comment', content: '좋은 아침이네요', like: 5 },
    { id: 7, type: 'comment', content: '공부하기 싫어요', like: 30 },
    { id: 10, type: 'comment', content: '아침에는 시원한 물 한잔', like: 10 },
    { id: 15, type: 'comment', content: '저는 공부가 좋은데요?', like: 0 },
    { id: 16, type: 'comment', content: '여기 이상한 사람이 있어요', like: 15 }];
let ret = datas1.find(data => {
  	// 안에서 for문이 돈다고 생각하면 된다.
    return data.id === 10
})
console.log(ret)
// { id: 10, type: 'comment', content: '아침에는 시원한 물 한잔', like: 10 }
```

every

```js
let scores = [
    { subject: '국어', point: '100' },
    { subject: '영어', point: '90' },
    { subject: '수학', point: '80' },
    { subject: '컴퓨터', point: '10' }];
let pass = scores.every(score => {
    return score.point > 70
})
console.log(pass) // false
```

some

```js
let pass1 = scores.some( score => {
    return score.point > 70
})
console.log(pass1) // true
```

reduce

```js
// 배열의 각 원소에 대해서 
// 첫번째 원소부터 마지막 원소 순으로 연산한 값이 줄도록 함수를 적용합니다.
let scores2 = [1, 2, 3, 4, 5]
let sum = scores2.reduce((sum, number) => sum + number, 0)
console.log(sum) // (((( 1 + 2 ) + 3 ) + 4 ) + 5) 15
```

- `shift()` vs `pop()`

  :star:`shift()`는 맨 앞의 값을 뺀다.

  :star:`pop()`은 무슨 수가 들어가든 맨 뒤를 뺀다.

- :star: JS는 `get`이란 명령어가 없다

- `keypress`

  keypress는 :star:`누르고있는 동안` 발생

- typeof null === 'null'

```js
console.log(typeof null === 'null') // false
console.log(typeof null) // object
console.log('null') // null
```

​     `typeof null === 'null'`

​	 object type이므로 위 조건은 false이다.



- 인터폴레이션( `{{ 이것이 인터폴레이션 }}` )의 올바른 사용법

   `{{ const number = 1 }}` => :star: 불가능 
   
   인터폴레이션 안에 쓸 수 있는 것은 딱 결과가 찍히는 것만 입력이 가능 선언문은 사용할 수 없다.
   
   
   
- `v-on:click` 과 `@click`

```html
<div class="todo-list">
      <h2>취업준비</h2>
      <input type="text" v-model="newTodo1">
      <button __빈칸___="addTodo1">+</button>
      <li v-for="todo in todos1" v-bind:key="todo.id">
        <span>{{ todo.content }}</span>
        <button v-on:click="removeTodo1(todo.id)">x</button>
      </li>
    </div>
```

:star: `v-on:click`, `@click` 둘 다 가능



- 다음 코드의 실행결과

```js
const people = [
    {
        name: 'pkch',
        age: 27
    },
    {
        name: 'silverlyjoo',
        age: 30
    },
    {
        name: 'SM',
        age: 29
    }
]

for (let person of people){
    console.log(person.name)
}

/*
pkch
silverlyjoo
SM
*/
```

```js
const result = '1' === 1 ? 'YES' : 'NO'
console.log(result)
// NO
```

```js
const temp = [1, 3, 5, 7, 9]
list = temp.map(num => num ** 2)
console.log(list)
// [ 1, 9, 25, 49, 81 ]
```

- `callback`, `filter`

콜백함수(callback) - 인자로 다른 함수에 전달 된 함수.

```js
function doSomething(subject, callback) {
    console.log(`이제 ${subject} 과목평가 준비를 시작해볼까?`)
    callback()
}

// 콜백 함수로 사용 됨
function alertFinish() {
    console.log('며칠 안남았는데?')
}

console.log(doSomething('django', alertFinish))

/*
이제 django 과목평가 준비를 시작해볼까?
며칠 안남았는데?
undefined
*/
```

:star: `.filter(callback())`

```js

// 주어진 함수의 테스트를 통과한 모든 요소를 모아 새로운 배열로 반환한다.
// 즉, 주어진 콜백 함수로 원하는 요소만 filtering 할 수 있다.
// map 과 마찬가지로 원본은 유지.

// filter
const PRODUCTS = [
  { name: 'cucumber', type: 'vegetable' },
  { name: 'banana', type: 'fruit' },
  { name: 'carrot', type: 'vegetable' },
  { name: 'apple', type: 'fruit' },
]

const FRUIT_PRODUCTS = PRODUCTS.filter( function(product) {
  return product.type === 'fruit'
  // 해당 조건이 true 를 만족할 경우에 return
})

// const FRUIT_PRODUCTS = PRODUCTS.filter( product => product.type === 'fruit')

console.log(FRUIT_PRODUCTS)


// 3-1 연습
// users 배열에서 admin 레벨이 true 인 user object 들만 filteredUsers 에 저장하고 
// filteredUsers 배열의 두번째 유저의 이름을 출력
const users = [
  { id: 1, admin: false, name: 'justin'},  
  { id: 2, admin: false, name: 'harry' },
  { id: 3, admin: true, name: 'tak' },
  { id: 4, admin: false, name: 'jason' },
  { id: 5, admin: true, name: 'juan' },
]

const filteredUsers = users.filter( user => user.admin === true)

console.log(filteredUsers)
console.log(filteredUsers[1].name)
```

- < `img` v-bind:src ="imageUrl"> 중간에 인터폴레이션 쓸 수 `없다.`

- `axios`를 이용하여 여러코드를 동시에 실행할 수 있는 이유는 `Javascript가 비동기로 동작`하기 때문이다.

  **동기방식 (Synchronous)**

  요청을 보낸 후 응답(=결과)를 받아야지만 다음 동작이 이뤄지는 방식

  어떠한 일을 처리할 동안 다른 프로그램은 정지

  실제 cpu가 느려지는 것은 아니지만 시스템의 전체적인 효율이 저하된다

  **비동기 방식 (Asynchronous)**

  요청을 보낸  후 응답(=결과)와는 상관없이 다음방식이 동작하는 방식

  결과가 주어지는데 시간이 걸리더라도 그 시간 동안 다른 작업을 할 수 있으므로 자원을 효율적으로 사용할 수 있다.

  비동기식은 비동기식 처리를 요청할 때 할일 이 끝난 후 처리결과를 알려주는 콜백이라는 함수를 함께 알려준다.

  비동기식 처리를 요청하였을 때 호출받은 함수는 바로 응답(=확인)을 수행한다.

  이 응답은 처리 결과에 대한 응답이 아니라 요청에 대한 확인 동작일 뿐이다.

  호출받은 함수는 처리가 끝나면 요청한 함수를 호출하여 처리 결과를 전달하게 된다.

  이러한 함수 호출의 흐름은 사용자가 아닌 일을 마친 시스템이 호출하는 형태이기 때문에 콜백이라고 불린다.

  이미 응답을 했기 때문에 처리결과를 함수 호출이라는 형태로 전달하는 것이다.

  비동기 방식은 DOS같은 단일 운영체제에서는 불가능하며 windows 같은 multitask 환경에서만 가능하다.

  (ajax에서는 success, error, complete 을 콜백함수라고 할 수 있다.)

  

- addEventListener

  `addEventListener` 두 번째 인자 함수를 기명으로 넣어도 제대로 동작한다. 

  this는 클릭하는 button을 가리킨다. this : `function`일 때는 button(불리는 곳의 객체. 수동적)

  arrow일 때는 window/global(불리는 곳(button)의 bind를 풀어버리고 최상단(브라우저에서는 window, node에서는 global 객체)를 가리킨다.)

- v-if

  v-if 는 조건문을 만족할 경우에만 렌더링된다. 즉, `v-if` 는 false면 렌더링 자체가 되지 않는다.

  디렉티브 v-show는 조건과 관계없이 항상 렌더링된다. `v-show`는 렌더링 되고 `display: none`으로 처리된다.



- a() === typeof c

```js
function a() {
    console.log('practice')
}
const c = 'practice'
console.log(a() === typeof c)
/*
practice
false
*/
```

:star: a() === typeof c => type 비교

- `v-model`













