//  variable = var
//  변수 설정
//  var 에는 name of varialble 이 온다.
//  항상 세미콜론으로 닫아준다.
var y = 23;
// 파이썬의 print와 동일
console.write(y); 

// function에 이름짓기
// funky(매개변수지정)
function funky(){
    // 여기에 코드를 지정하면 funky()가 사용된다.
    // 파이썬에서 함수 만드는거랑 동일
    // funky가 사용되면 alert(프린트문)이 실행된다.
    alert("Hi"); 
}
funky();


// meatball() 괄호안에 매개변수를 지정해준다.
function meatball(x){
    alert("I love" + x);
}
meatball("Bacon");
// I love Bacon 을 반환하게 될 것


// 두개 매개변수를 줄 경우,
function apples(one, two){
    console.write(one+ "is better than add" + two);
}
apples("text one", "text two")


// value를 return해서 쓰기위해서는,
// return value를 프린트문에 넣어줘야 한다. 
function tooeasy(a, b){
    var c = a+b;
    return c;
}
console.write(tooeasy(1, 2));
// 3을 프린트하게 될 것



// 중요! function에서 또 다른 function불러오기
function doFrist(){
    console.write("I am doFirst");
}
function doSecond(){
    console.write("I am doSecond");
}

// 다른 function을 불러올 것
function start(){
    doFrist();
    doSecond();
}
start();

// ++ 사용: +1이 된다. , --사용: -1이 되어 66이 된다.
var chop = 67;
chop++;
console.write(chop); 
// 68이 프린트된다.


var bucky = 24;
bucky += 30;
console.write(bucky);
// 54가 된다. *= /= 등등 가능


// 중요! if statement
var apples = 34;
var hotdogs = 53;
// 만약 if의 ()안이 True라면, {}안의 코드가 실행된다.
if (apples==hotdogs) {
    console.write("hi");
}
// == 하지않으므로 실행되지 않는다. !=, > 논리연산자 사용 가능


//  중요! if/else statement
if (2==2){
    console.write("hi");
}else{
    console.write("i love hi");
}
//  hi가 출력된다.
//  모든 코드는 {} 안에 감싸진다.


//  if 안에서 &&(and) 사용법
var first = "bucky"
var second = "robert"
//  first는 bucky고 second는 robert일때 안의 코드가 실행된다.
if((first=="bucky")&&(second=="robert")){
    console.write("조건이 맞아서 출력됩니다.");
}
// ||(or)


// switch 사용법
var girl = "natalie";
switch(girl){
    case "natalie":
        console.write("매개변수로 들어온 girl은 natalie가 맞습니다.");
        break; 
        // break로 닫아준다.
    case "ashley":
        console.write("매개변수로 들어온 girl은 ashley일때 실행됩니다.");
        break; 
    //  모든 케이스가 맞지 않는 경우 아래 코드를 실행한다.
    default:
        console.write("this is default");
}


// for 사용법
// for 안에 몇번을 돌릴건지 레인지를 정해준다.
// (시작점, 끝점, 몇번을 건너뛰면서)
// x가 10이 될때까지 출력할건데,
// x를 ++(1개씩 늘려가면서) 출력한다.
for(x=0;x<10;x++){
    console.write("hi");
}
// hi가 10번 출력된다.


// while 사용법
var x = 1;
while(x<10){
    console.write(x+"this is about while");
    x++;
}
//  1 this is about while
//  2 this is about while
//  9가 될때까지 반복한다.


//  do while 사용법
var x = 5;
do{
    console.write(x+"lol");
    x++;
}while(x<=20);
// do에 코드를 적고 while 안에 끝나는 조건을 넣는다.
// 그러면 x는 5에서부터 1씩 증가하면서 print를 하게된다.


// 중요! Object Oriented Programming
var tuna = "hey i am tuna";
// tuna가 가진 길이를 반환
// 즉, tuna라는 object가 가진 length property를 반환
console.write(tuna.length);
// 13을 반환
// 즉 object.property 이런식으로 property를 불러올 수 있다.


//  this는 person을 가르킨다. 파이썬의 self와 동일
function person(name, age){
    this.name = name;
    this.age = age;
}
//  new를 써야지 새로운 object를 만들 수 있다. 아래와 같이 두가지 방법 존재
var bucky = new person("버키", 25);
var taylor = new person("테일러", 35);
newbucky = {name:"새로운 버키", age: 34};

console.write(bucky.age);
// 25가 출력됨
console.write(newbucky.age);
// 34가 출력됨



// array생성시 Array()안에 정보를 감싼다.
var people = new Array("bucky", "Tommy", "Sara");
console.write(people[0]);
// bucky가 나올것, people이라는 배열에 인덱스로 접근가능하다.


<<<<<<< HEAD
=======

>>>>>>> 63ca761ca5cbfb3924ed7270e711399c464065e8
// var => function-scope 
// let, const => block-scope 
// let은 재할당 가능
// const는 재할당 불가능

// var는 기존에 할당되는 값을 잃어버린다. 즉, 변수의 유효범위가 함수이므로 블럭으로 감쌌다고 하더라도 함수 스코프가 바뀐것이 아니기 때문에 if 블럭 내에서 재할당한 값을 출력
// 객체를 새로 할당할 특별한 이유(이런 경우는 드물다 생각합니다)가 없다면 되도록 const 를 사용하여 객체를 선언
var a = 1;
a = 2;
console.log(a); // 2
var a = 3;
console.log(a); // 3

// let의 경우
let b = 1;
b = 2;
console.log(b); // 2
let b = 3; // SyntaxError: Identifier 'b' has already been declared

// const의 경우
const c = 1;
c = 2; // TypeError: Assignment to constant variable


var a = 1
let b = 2

if (true) {
    var a = 11
    let b = 22
    console.log('a = ' + a) // 11
    console.log('b = ' + b) // 22
}

console.log('a = ' + a) // 11
console.log('b = ' + b) // 2

function func() {
    var a = 111
    let b = 222
    console.log('a = ' + a) // 111
    console.log('b = ' + b) // 222
}

func()

console.log('a = ' + a) // 11
console.log('b = ' + b) // 2