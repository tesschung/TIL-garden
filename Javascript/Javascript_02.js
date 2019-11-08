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

var a = 1
var a = 2

let b = 1
// let b = 2 // SyntaxError

const c = 1
// const c = 2 // SyntaxError


let d = 3
d = 5

const e = 5
// e = 3 // TypeError

// 따라서 const는 선언시 반드시 할당을 해야한다.
// const f // SyntaxError

// let은 선언시 할당하지 않고 선언만 해도 된다.
let g
g = 3


function myfunction1 () {
    for (p=0; p<1; p++) {
        console.log(p)
    }
    console.log(p)
}
myfunction1()
console.log(p) // 1
// console.log(window.p) // window is not defined




console.log(typeof Boolean) // function
console.log(typeof null) // object
console.log(typeof undefined) // undefined
console.log(typeof Number) // function
console.log(typeof String) // function
let ad = []
console.log(typeof ad) // object


let adc = 1
if (adc === 1) {
    console.log('adc는 1입니다.') 
}else if (adc !== 1) {
    console.log('adc는 1이 아닙니다.')
} else {
    console.log('adc는 아무것도 아닙니다.')
}
// adc는 1입니다.

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

for (const item of array) {
    console.log(item)
}
/*
포도
사과
바나나
망고
 */


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
console.log(ax) // 맨뒤의 a가 pop된다.
console.log(numbers) // [ 4, 3, 2, 1 ]

numbers.unshift('a') 
console.log(numbers) // [ 'a', 4, 3, 2, 1 ] 맨앞에 추가된다.

ac = numbers.shift()
console.log(ac) // 맨앞의 a가 shift된다.
console.log(numbers) // [ 4, 3, 2, 1 ]

ans1 = numbers.includes(1)
console.log(ans1) // true
ans0 = numbers.includes(0)
console.log(ans0) // false

numbers.push('a')
numbers.push('a')
console.log(numbers)
numbers.indexOf('a') // 4 처음 찾은 요소의 index를 반환
numbers.indexOf('b') // -1 찾는 요소가 없으면 -1을 반횐

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



// Key-Value로 이뤄져있는 데이터 구조이다.
const endGame = {
    title: 'avengers: End Game',
    'my-lovers': [
        {name: 'iron man', actor: '로다주'},
        {name: '헐크', actor: '마크 러팔로'}
    ]
}
console.log(endGame.title) // avengers: End Game
console.log(endGame['title']) // avengers: End Game
// console.log(endGame.my-lovers) // error
console.log(endGame['my-lovers']) // [ { name: 'iron man', actor: '로다주' }, { name: '헐크', actor: '마크 러팔로' } ]
console.log(endGame['my-lovers'][0].name) // iron man


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


let fruits1 = ['apple', 'banana', 'peach', 'blue berry'];
fruits1.forEach(function(fruit) {
    console.log(fruit)
})
// apple
// banana
// peach
// blue berry

let fruits2 = ['apple', 'banana', 'peach', 'blue berry'];
let juice = fruits2.map(function(fruit) {
    return fruit + ' juice'
})
console.log(juice) // [ 'apple juice', 'banana juice', 'peach juice', 'blue berry juice' ]


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


let datas1 = [
    { id: 3, type: 'comment', content: '굿 모닝', like: 1 },
    { id: 6, type: 'comment', content: '좋은 아침이네요', like: 5 },
    { id: 7, type: 'comment', content: '공부하기 싫어요', like: 30 },
    { id: 10, type: 'comment', content: '아침에는 시원한 물 한잔', like: 10 },
    { id: 15, type: 'comment', content: '저는 공부가 좋은데요?', like: 0 },
    { id: 16, type: 'comment', content: '여기 이상한 사람이 있어요', like: 15 }];
let ret = datas1.find(data => {
    return data.id === 10
})
console.log(ret)
// { id: 10, type: 'comment', content: '아침에는 시원한 물 한잔', like: 10 }


let scores = [
    { subject: '국어', point: '100' },
    { subject: '영어', point: '90' },
    { subject: '수학', point: '80' },
    { subject: '컴퓨터', point: '10' }];
let pass = scores.every(score => {
    return score.point > 70
})
console.log(pass) // false

let pass1 = scores.some( score => {
    return score.point > 70
})
console.log(pass1) // true

// 배열의 각 원소에 대해서 
// 첫번째 원소부터 마지막 원소 순으로 연산한 값이 줄도록 함수를 적용합니다.
let scores2 = [1, 2, 3, 4, 5]
let sum = scores2.reduce((sum, number) => sum + number, 0)
console.log(sum)