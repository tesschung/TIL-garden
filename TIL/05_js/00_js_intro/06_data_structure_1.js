const numbers = [1, 2, 3, 4,]


console.log(numbers[0]) // 1
console.log(numbers[-1]) // undefined : 정확한 양의 정수 index 만 가능
console.log(numbers.length) // 4


// 원본 파괴
console.log(numbers.reverse())
console.log(numbers)
console.log(numbers.reverse())
console.log(numbers)


// push - 배열의 길이를 return 
console.log(numbers.push('a'))
console.log(numbers)


// pop - 배열의 가장 마지막 요소 제거 후 return
console.log(numbers.pop())
console.log(numbers)


// unshift - 배열의 가장 앞에 요소를 추가하고 return 은 배열의 길이
console.log(numbers.unshift('a'))
console.log(numbers)


// shift - 배열의 가장 앞에 요소를 제거 후 return
console.log(numbers.shift())
console.log(numbers)


// boolean return
console.log(numbers.includes(1))
console.log(numbers.includes(0))


console.log(numbers.push('a', 'a'))
console.log(numbers)
console.log(numbers.indexOf('a')) // 4 -> 중복이 존재한다면 처음 찾은 요소의 index 를 return
console.log(numbers.indexOf('b')) // -1 -> 찾고자 하는 요소가 없으면 -1 을 return

// join - 배열의 요소를 join 함수의 인자를 기준으로 이어서 문자열로 return
console.log(numbers.join()) // '1,2,3,4,a,a' -> 아무것도 넣지 않으면 , 를 기준으로 가져옴
console.log(numbers.join('')) // '1234aa'
console.log(numbers.join('-')) // '1-2-3-4-a-a'

console.log(numbers) // 원본은 변화하지 않음
