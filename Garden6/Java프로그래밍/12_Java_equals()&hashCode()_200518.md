

## 12_200518

> 공지

172.16.88.129



## 과제



리스트에 Member을 저장해서 만들것

Map으로 하지말고

기능 클래스가 아닌이상 기본으로 `toString(), equals(), hashCode()` 을 만들어줘야 한다.

```java
public Member {

    private String id;
    private String password;

}

public Main {
    public static void main() {
        List<Member> list = new ArrayList<>();
    }
}
```





---

:star: 교수님 풀이! `equals()` 와 `hashCode()`

*Member.java*

```java
package kr.ac.kopo.day14.lesson.homework;

public class Member {

	
	private String id;
	private String password;
	
	
	public Member() {

	}
	
	// 비교시 사용하는 생성자
	public Member(String id) {
		this.id = id;
	}
	
	public Member(String id, String password) {
		this.id = id;
		this.password = password;
	}
	
	public String getId() {
		return id;
	}
	
	public void setId(String id) {
		this.id = id;
	}
	
	public String getPassword() {
		return password;
	}
	
	public void setPassword(String password) {
		this.password = password;
	}

	@Override
	public String toString() {
		return "Member [id=" + id + ", password=" + password + "]";
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		return result;
	}

	// id만 가지고 비교
    // id만 선택해서 source에서 가져와서 작성
    // id만 같고, hashCode도 같으면 동일한 객체로 인식한다.
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Member other = (Member) obj; // Member객체로 변환
		if (id == null) { // 이부분 중요
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id)) // 이부분 중요, false -> true
			return false; // false 리턴
		return true; // 위 모든걸 거치지 않았다면 동일한 객체라는 의미다.
	}
	
}
```



*MemberMain.java*

```java
package kr.ac.kopo.day14.lesson.homework;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;

public class MemberMain {

	public static void main(String[] args) {
	
		Scanner sc = new Scanner(System.in);
		
		List<Member> memberList = new ArrayList<>();
		memberList.add(new Member("aaa", "1111"));
		memberList.add(new Member("bbb", "2222"));
		
		System.out.println("패스워드 변경 서비스 입니다. ");
		System.out.println("아이디를 입력하세요. ");
		String id = sc.nextLine();
		
		Member user = new Member(id);
		
		boolean bool = memberList.contains(user); // [중요] 맴버객체끼리 비교
		
//		boolean bool = false;
//		for (Member m : memberList) {
//			if(m.equals(user)) { // [중요] 맴버객체끼리 비교
//				System.out.println("찾았습니다.");
//				bool = true;
//				break;
//			}
//		}

		if (bool) {
			System.out.println("아이디 존재");
		} else {
			System.out.println("아이디 존재하지 않음");
			System.out.println("[ " + id + " ] 는 존재하지 않습니다.");
			System.exit(0);
		}
		
		System.out.println("현재 패스워드를 입력하세요.");
		String password = sc.nextLine(); // indexOf() -- 해당하는 오브젝트에 대한 인덱스 위치를 반환
		int index = memberList.indexOf(user); // 현재 인덱스 반환 

		Member realUser = memberList.get(index);
		
		if (!realUser.getPassword().equals(password)) {
			System.out.println("패스워드가 동일 하지않습니다.");
			System.exit(0);
		} else {
			System.out.println("패스워드가 동일 합니다.");
		}
		System.out.println("변경할 패스워드를 입력하세요.");
		String newPassword = sc.nextLine();
		realUser.setPassword(newPassword);
		
		System.out.println("<전체 회원 목록>");
		Iterator<Member> ite = memberList.iterator();
		while(ite.hasNext()) {
			System.out.println(ite.next());
		}
		
	}
	
}

```













**Lotto01, Lotto02**

방법1





방법2





방법3

리스트로 생성

`.contains` 함수를 사용하여 존재 여부 확인 후 없으면 추가



방법4

HashSet을 사용

개수가 다 차면 while문 break



방법5

리스트로 생성

1~45까지 채운다.

Collections`.shuffle(리스트) `순서를 가진 데이터들을 섞어주는 메소드를 사용해서 섞은 후

인덱스 0부터 6까지 잘라서 전달



**Lotto03**

숫자가 하나씩 나오도록

*LottoMain*

- MC를 실행



*Machine* 

- 숫자공을 가지고 있음

- 객체 생성시 공 리스트에 숫자를 추가한다.

- .start하면 Collections.shuffle을 통해 섞어준다.



*MC*

- Machine을 가동시킨다.

- 6개의 볼을 뽑는다.



*Ball*

- 번호를 가진 Ball 객체

```java
Thread.sleep(3000); // 3초 정지, 이런식으로 sleep을 통해 프로그램을 특정시간동안 멈추게할 수 있다.
// 해당 메소드를 사용하면 컴파일 시점에 에러가 발생 할 수 있으므로 예외처리를 해줘야 한다.
```











## Stack and Queue

Stack: **후입선출**(LIFO)

맨 마지막에 입력한 것 부터 삭제

*실행취소, 뒤로가기, 메소드 호출(재귀형식), 백업과 복원(이벤트뷰어, 로그파일)



Queue: **선입선출**(FIFO)

맨 처음에 입력한 것 부터 삭제

*주문, 우선순위스케쥴링



|       | 입력   | 삭제  |
| ----- | ------ | ----- |
| stack | push() | pop() |
| queue | put()  | get() |





## Tree

이진탐색

Binary Tree







MapMain02.java

:star: 기능 클래스가 아닌이상 기본으로 `toString(), equals(), hashCode()` 을 만들어줘야 한다.

```java
package kr.ac.kopo.day13.lesson;

import java.util.HashMap;
import java.util.Map;

class Member{
	
	private String name;
	private String phone;
	
	public Member(String name, String phone) {
		this.name = name;
		this.phone = phone;
	}
	
/*
	@Override // Source - Override/Implements Methods
	public boolean equals(Object obj) { // 재정의
		// 이 안에서 name과 phone비교
		// obj 는 묵시적 형변환이 되어있다. 때문에 맴버형으로 명시적 형변환이 필요하다.
		Member m = (Member) obj;
		if (m.getName() == null && m.getPhone() == null) {
			System.out.println("잘못된 사용자 입니다.");
			return false;
		}
		
		if (this.getName().equals(m.getName())) {
			System.out.println("새로운 전화번호로 변경되었습니다.");
			this.phone = m.getPhone();
			return true;
		}
		System.out.println("등록되지 않은 사용자 입니다.");
		
		return false;
	}

	@Override
	public int hashCode() {
		return ((int)(this.name.hashCode()));
	}
*/
	

	public String getName() {
		return name;
	}
	
	public String getPhone() {
		return phone;
	}
	
	// Source - hashCode() and equals()
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((phone == null) ? 0 : phone.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Member other = (Member) obj;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (phone == null) {
			if (other.phone != null)
				return false;
		} else if (!phone.equals(other.phone))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "Member " + this.getName() + "   " + this.getPhone() ;
	}

}


class Car{
	
	private String name;
	private String id;
	
	public Car(String name, String id) {
		this.name = name;
		this.id = id;
	}
	
	public String getName() {
		return name;
	}
	
	public String getId() {
		return id;
	}
}



// toString(), equals(), hashCode()
public class MapMain02 {

	public static void main(String[] args) {
		
		
		Map<Member, Car> list = new HashMap<>();
		
		list.put(new Member("홍길동", "010-1111-2222"), new Car("소나타", "34거1456"));
		list.put(new Member("윤길동", "010-1341-2222"), new Car("모닝", "34거1356"));
		
		list.put(new Member("홍길동", "010-1111-2222"), new Car("벤츠", "34거1456")); // 2대라고 나오지 않고 3대라고 나온다.
		// 이렇게 객체는 참조객체 이므로 서로 다른 주소를 가르킨다.
		System.out.println(list.size() + " 대"); // 등록된 차량 개수 => 3대
		// [중요] 1. equals(내용이 같고)가 true이면서  2. 해시코드가 같아야 같은 객체로 인식한다.
		// hashcode()와 equals()를 수정해서 고칠 수 있다.
		

		Member m = new Member("홍길동", "010-1111-2222");
		Member m2 = new Member("홍길동", "010-1331-2222");
		System.out.println(m == m2); // 주소값 비교, false
		System.out.println((m.equals(m2))); // String화된 주소값 비교 false
		System.out.println(m.getName().equals(m2.getName())&&m.getPhone().equals(m2.getPhone())); // true
		System.out.println(m.getName() + " " + m.getPhone());

		// 모든 클래스는 object를 상속 받는데, object는 객체와 객체를 비교하는 메소드를 갖고있다.
		/*
		 *     public boolean equals(Object anObject) {
		        if (this == anObject) { // 주소값을 비교한다.
		            return true; 
		        }
		 */
		
		String str = "hello";
		String str2 = new String("hello");
		System.out.println(str == str2); // false 주소값 비교 
		// 해시코드는 가상의 메모리 주소이므로 주소값하고 다르다. (사용자가 임의로 해시코드를 수정할 수 있다. 임의 식별자)
		System.out.println(str.equals(str2)); // true 내용 비교
		System.out.println(str.hashCode()); // 99162322
		System.out.println(str2.hashCode()); // 99162322 => int형
		System.out.println(str.hashCode() == str2.hashCode()); // true
		
		
	}
}
```





Auto-boxing

Auto-unboxing

WrapperMain.java

```java
package kr.ac.kopo.day13.lesson;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/*
 * Wrapper Class(기본 자료형 8가지를 참조 자료형으로 인식하게 만들어준다) java.lang
 * 기본 자료형을 참조형으로 감싸는 클래스
 * 	
 * 	boolean		Boolean
 * 	byte		Byte	
 * 	char		Character
 * 	short		Short
 * 	int			Integer
 * 	long		Long	
 * 	float		Float	
 * 	double		Double
 */


/*
 * class Integer {
 * 		private int value
 * }
 */

public class WrapperMain {
	
	public static void main(String[] args) {
	
		List<Integer> list = new ArrayList<>();
		list.add(new Integer(100));
		list.add(new Integer(200));
		
		System.out.println(Arrays.deepToString(list.toArray()));
		
		int i = 10;
		Integer i2 = new Integer(100);
		Integer i3 = 130; // auto boxing
		int i4 = new Integer(200); // auto unboxing
		
		System.out.println(i2);
		
		char c = 'a';
		Character c2 = new Character('c');
		Character c3 = 'b';
		char c4 = new Character('d');
		
		System.out.println(c4);
	}

}

```





