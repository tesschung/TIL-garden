

## 14_200520

> 공지











## JDBC(Java Database Connectivity)

자바에서 데이터베이스를 표준화된 방법으로 접속할 수 있는 클래스



![image-20200520150720878](images/image-20200520150720878.png)



*JDBC 드라이버 관리자(ojdbc(버전).jar)가 해당 추상클래스를 뜻함

 



## JDBC API

![image-20200520151153698](images/image-20200520151153698.png)



DriverManager - 아이피/포트/아이디/패스워드에 접속할 DBMS 설정

Connection - 연결을 도와준다.



## JDBC 프로그램 순서



![image-20200520151543779](images/image-20200520151543779.png)



## JDBC 프로그램 단계

![image-20200520151746826](images/image-20200520151746826.png)



OracleDriver라는 Class를 DriverManager가 만든다.

```java
package kr.ac.kopo.day15.jdbcLesson;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class InsertMain02 {

	public static void main(String[] args) {
	
		// *********키보드 입력 받아서 저장하기**********
		Scanner sc = null;
		Statement stat = null;
		Connection conn = null;
		
		try {
			
			// 1단계 : JDBC 드라이버 로딩
			Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("1단계 드라이버 로딩 성공");
			
			// 2단계: DriverManager를 이용한 DB 접속, Connection 객체 얻기 
			String url 		= "jdbc:oracle:thin:@172.16.88.120:1521:dink";
			String user 	= "scott";
			String password = "tiger";
				
			conn = DriverManager.getConnection(
					url, // jdbc:oracle:thin:@localhost:1521:xe
					user,
					password);
			System.out.println("2단계 DriverManager로 Connection 성공 "+conn);
			
			// 3단계 : SQL문 실행(Statement)
			stat = conn.createStatement();
			sc = new Scanner(System.in);
			System.out.println("등록할 아이디를 입력하세요 : ");
			String id = sc.nextLine();
			
			System.out.println("등록할 이름을 입력하세요 : ");
			String name = sc.nextLine();
			
			// semi-colon이 붙지않는다.
			String 	sql = "insert into t_test01(id, name) "; // 뒤에 항상 공백 추가
					sql += "values(\'"+id+"\',\'"+name+"\') ";
					
			// 4단계 : 실행 및 결과 도출 executeQuery(), 완료한 행 개수 반환
			int cnt = stat.executeUpdate(sql);
			System.out.println("4단계 총 "+ cnt+ "개 행 삽입 완료");
			
		} catch (Exception e) {
			e.getStackTrace();
		} finally {
			// 5단계: 접속 종료
			// stack 방식으로 삭제
			if (stat != null) {
				try {
					stat.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}		
	}
}
```







![image-20200521104457332](images/image-20200521104457332.png)

마지막에 rs`.next()`를 호출하면 false가 리턴된다.

`.next()` 레코드 별로 조회

getInt -> 정수형으로

getStirng ->  문자열형으로

`.getInt("no")` 컬럼명을 넣는 경우, 혹은 `.getInt(1)` 같이 순서를 넣는 경우(항상 1부터 시작한다)