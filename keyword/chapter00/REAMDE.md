- IP
    - IP - Internet Protocal. 인터넷 상에서 상대를 식별할 수 있는 수단.
    - 클라이언트는 요청을 보낼 때 패킷에 IP 주소로 대상을 식별
    - 패킷을 받은 라우터는 네트워크 레이어에서 패킷 안에 있는 IP를 확인 후 다음 라우터로 전송. 최종적으로 네트워크 엣지(클라이언트)에 도착하면 다음 Transport Layer로 이동.
        - 용어 정리
            - Network Core - 네트워크의 중앙에 위치하여 데이터를 전송하는 역할. 수많은 라우터들이 얽혀있는 구조로 이루어진다. 패킷을 교환하며 Forwarding과 Routing의 과정을 수행한다.
            - Access network - 네트워크에 접근하기 위한 네트워크. End system (서버, 클라이언트) 들이 인터넷에 연결할 수 있도록 길을 만들어주는 네트워크. 와이파이 접속, 랜선 접속이 액세스 네트워크 접속이라고 할 수 있다.
            - Network Edge - 네트워크의 가장자리. end system (서버, 클라이언트 등의 호스트) 들이 존재한다.
    - IPv4, IPv6이 존재
    
    https://ddongwon.tistory.com/69
    
- PORT
    - 같은 IP 내에서 프로세스를 구분하는데 사용하는 번호. HTTP의 80, HTTPS의 443 등이 존재함.
    - TCP/IP를 사용할 때 네트워크 상의 특정 서버 프로그램을 지정하는 방법이다.
    - 0 ~ 65535까지 사용할 수 있다.
    - 0 ~ 1023번까지는 Well-known port로, 주요 통신 규약에 따라 이미 정해져 있는 포트이므로 사용하지 않는 것을 권장한다.
        - 21 - FTP
        - 23 - Telnet
        - 25 - SMTP
        - 80 - HTTP
        - 443 - HTTPS
    - 1024 ~ 49151번까지는 Registered port로, 특정 프로토콜이나 어플리케이션에서 사용하는 번호이다. 특정 용도로 사용되기 위한 포트번호이지만 강제적으로 지정된 것이 아니므로 다른 용도로도 사용 가능하다.
        - 1433 - MSSQL
        - 3306 - MySQL
        - 3389 - 원격 접속
        - 8080 - HTTP(80) 대체용
    - 49152 ~ 65535는 Dynamic port로, 어플리케이션에서 사용하거나 임시로 사용하는 번호이다.
    
    https://blog.alyac.co.kr/1218
    
- CIDR
    - CIDR - Classless Inter-Domain Routing
    - 클래스 없는 도메인간 라우팅 기법…
    - 기존에 사용하던 클래스 구분 대신 Inter-Domian 형태이다.
    
    ![1.png]
    
    - 각 네트워크 대역을 구분하고 구분된 네트워크간 통신을 위한 주소 체계이다.
    - IPv4 뒤에 /8, /16, /24 로 네트워크 주소를 구분한다. /뒤에 있는 숫자가 네트워크 주소의 비트 수 이다.
    - 예를 들어 192.0.2.0/24는 앞의 24비트가 네트워크 주소, 즉 192.0.2가 네트워크 주소가 된다. /16이라면 192.0이 된다.
    - 비효율적인 클래스 방식에 비해 유연하게 IP 주소 할당이 가능해졌다.
    - 불필요한 서브넷을 통일하고 더 짧은 경로로 데이터가 목표에 도달 가능하다.
    - VPC를 생성하여 클라우드 내에서 프라이빗 디지털 동간을 사용할 수 있게 된다.
    
    https://aws.amazon.com/ko/what-is/cidr/
    
    https://kim-dragon.tistory.com/9
    
- TCP와 UDP 차이
    - TCP - Transmission Control Protocol
        - 3 way handshake 방식으로 수신자와 발신자의 연결 상태를 먼저 점검 후에 데이터 전송
        - 데이터를 받고 나서 데이터를 잘 받았는지 응답함.
        - 데이터가 끊어져서 보내지면 sequence number로 정보 순서를 알려줌.
    - UDP - User Datagram Protocol
        - 데이터를 데이터그램 단위로 처리하는 프로토콜.
        - 정보를 주고 받을 때 보내거나 받는다는 신호절차를 거치지 않는다.
        - UDP 헤더의 CheckSum 필드를 통해 최소한의 오류만 검출
        - 신뢰성이 낮지만 TCP보다 속도가 빠르다.
    
    ![2.png]
    
    https://mangkyu.tistory.com/15
    
- Web Server와 WAS의 차이
    - Web Server - 정적 리소스 (html, css, 이미지)를 처리하는 서버.
    - WAS - 동적 리소스(DB 조회, 다양한 로직 처리)를 처리하는 서버.