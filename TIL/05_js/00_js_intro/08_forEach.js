// Array Helper Method

// 1. .forEach(callback()))
// 주어진 callback 을 배열에 있는 각 요소에 대해 오름차순으로 한번씩 실행
// 아무것도 return 하지 않는다. (undefined)
// 콜백함수 - 인자로 다른 함수에 전달 된 함수.

// ES5
var colors = ['red', 'blue', 'green']

for (var i = 0; i < colors.length; i++) {
  console.log(colors[i])
}

// ES6
const COLORS = ['red', 'blue', 'green']

COLORS.forEach(function (color) {
  console.log(color)
})

COLORS.forEach( color => console.log(color))

const result = COLORS.forEach( color => console.log(color))
console.log(result) // undefined


// 1-1 연습
function handlePosts() {
  const posts = [
    { id: 23, title: 'News' },
    { id: 52, title: 'Code City' },
    { id: 102, title: 'Python' },
  ]

  // for (let i = 0; i < posts.length; i++) {
  //   console.log(posts[i])
  //   console.log(posts[i].id)
  //   console.log(posts[i].title)
  // }

  posts.forEach(function(post){
    console.log(post)
    console.log(post.id)
    console.log(post.title)
  })
}

handlePosts()


// 1-2 연습
// images 배열안에 있는 정보를 곱해서 넓이를 구하여 areas 라는 배열에 저장하시오.
const images = [
  { height: 10, width: 30 },
  { height: 20, width: 90 },
  { height: 54, width: 32 },
]

const areas = []

images.forEach(function (image){
  areas.push(image.height * image.width)
})

console.log(areas)

