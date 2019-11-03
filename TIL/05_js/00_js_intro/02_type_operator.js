const a = 13
const b = -3
const c = 3.14 // float
const d = 2.998e8 // 2.998 * 10^8 = 299,800,000
const e = Infinity
const f = -Infinity
const g = NaN

console.log(a, b, c, d, e, f, g)

// 문자열
const sentence1 = 'sentence'
const sentence2 = "sentence"
const sentence3 = `sentence`

// backtick
// const word = "안녕
// 하세요"
// console.log(word)

const word1 = "안녕 \n하세요"
console.log(word1)

const word2 = `안녕
하세요`
console.log(word2)

// Template Literal
// JS 에서 문자열을 입력하는 방식.
const age = 10
const message = `홍길동은 ${age}
세입니다.`
console.log(message)


const happy = 'hello'
const hacking = 'world' + 'lol' + '!!!'
console.log(happy, hacking)


// Number.isNaN() 함수는 값이 NaN 인지 여부를 판별.
// 주어진 값의 유형이 Number 이고 값이 NaN 이면 true
// 아니면 false
Number.isNaN(null) // false
Number.isNaN(undefined) // false
