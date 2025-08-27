# 🌱 식꾸 (Plant Growth Diary)
## 📌 프로젝트 개요

식꾸(식물 생육 다이어리)는 식물 키우는 사람들을 위한 맞춤형 다이어리 & 커뮤니티 웹, 앱 플랫폼입니다.
사용자는 자신의 식물 성장 과정을 기록하고, 캘린더로 관리하며, 다른 사용자들과 Q&A 및 리뷰를 공유할 수 있습니다.
또한 MBTI 기반 식물 추천, 구독 결제, 관리자 페이지 등을 제공하여 식물과 함께하는 생활을 더 즐겁고 체계적으로 돕습니다.

## 🛠 기술 스택

### Backend
- Java 21, Spring Boot 4.31
- JPA & MyBatis 혼용
- REST API 설계
- JWT 기반 인증/인가

### Frontend
- JSP (Spring Boot 내장 톰캣 기반)
- Flutter (모바일 앱 버전)
  
### Database
- Oracle DB

### Others
- GitHub & Notion 협업
- Ajax 비동기 통신
- WebSocket (실시간 기능 일부)
- Figma (와이어프레임 설계)

## 🚀 주요 페이지 & 기능

### 회원 시스템
- 회원가입, 로그인, 마이페이지 (프로필 이미지 업로드 지원)
- JWT 토큰 인증 및 보안 처리

### 다이어리 & 캘린더
- 캘린더 기반 식물 생육 기록
- 사진 업로드 및 성장 이력 관리

### 커뮤니티 게시판 & Q&A 게시판
- 자유 게시판
- 갤러리 게시판 (이미지 첨부 가능, 카드형 UI)
- Q&A 게시판 (좋아요, 조회수 증가, 답변 등록 기능)

### 식물도감, MBTI별 추천
- 네이버 API 기반 인기 식물 검색
- 식물도감 정보 제공
- MBTI별 식물 추천

### 기타 기능
- AI 챗봇 (DB 연계 미완성, 향후 개선 예정)
- 구독형 결제 모듈 구현 (테스트 API)

### 관리자 페이지
- 회원 관리
- 신고 게시글 관리 (카드형 UI, 정렬된 테이블)
- 식물도감 정보 관리
- 회원 활동 대쉬보드

## 📷 화면 예시

(여기에는 실제 스크린샷 넣으면 좋아 👍)

### 메인 페이지

### 다이어리 캘린더

### 리뷰 게시판 (카드형 UI)

### 관리자 페이지

## ⚙️ 실행 방법
Backend (Spring Boot)
git clone https://github.com/your-repo/sikku.git
cd sikku
./mvnw spring-boot:run

Database

Oracle DB 스키마 적용 (schema.sql 참고)

application.properties 또는 application.yml에서 DB 설정 변경

Frontend (Flutter)
cd sikku_flutter
flutter pub get
flutter run

## 👥 팀 구성 & 역할

본인(김OO) : 백엔드/풀스택

회원 시스템, 다이어리/게시판 CRUD, 관리자 페이지, API 연동

팀원 A : 프론트엔드 JSP & UI/UX

팀원 B : Flutter 클라이언트

팀원 C : DB 설계 & 서버 배포

## 📈 트러블슈팅 & 배운 점

GitHub 브랜치 전략을 통한 협업 및 충돌 해결 경험

Controller → Service 계층 리팩토링으로 MVC 구조 이해 심화

이미지 업로드 후 실시간 반영 문제 해결 (캐싱 이슈 → 새로고침/파일명 처리 개선)

Naver API (검색·Datalab) 사용 시 키워드 제한 문제를 Python 코드로 보완

## 🔮 향후 개선 계획

AI 챗봇을 사용자 DB와 연계하여 맞춤형 상담 기능 강화

Flutter 앱에서 푸시 알림 및 알림창 기능 추가

결제 모듈 정식 상용화 준비
