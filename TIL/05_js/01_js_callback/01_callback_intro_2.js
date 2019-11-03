function doSomething(subject, callback) {
  console.log(`이제 ${subject} 과목평가 준비를 시작해볼까?`)
  callback()
}

// 콜백 함수로 사용 됨
function alertFinish() {
  console.log('며칠 안남았는데?')
}

doSomething('django', alertFinish)
