# 광고배너관리 (Ad Banner Management) Planning Document

> **Summary**: 광고 배너를 등록/수정/삭제하고 노출을 관리하는 어드민 화면 개발
>
> **Project**: wontherads
> **Author**: User
> **Date**: 2026-04-01
> **Status**: Draft

---

## 1. Overview

### 1.1 Purpose

광고 서버에 등록할 배너 광고를 관리하는 어드민 웹 화면을 구축한다.
운영자가 DB를 직접 조작하지 않고도 배너를 등록/수정/삭제/노출관리할 수 있도록 한다.

### 1.2 Background

- 광고용 서버가 구축된 상태에서, 광고 배너를 운영할 관리 도구가 필요
- 배너 이미지 업로드, 노출 기간 설정, 클릭 URL 관리 등 운영 기능 필수
- maddit 프로젝트와 동일한 기술 스택(Spring MVC + MyBatis + MySQL + JSP)으로 통일

### 1.3 Related Documents

- 참고 프로젝트: `C:\projects\maddit` (Spring MVC 6 + MyBatis + MySQL)

---

## 2. Scope

### 2.1 In Scope

- [ ] 배너 목록 조회 (페이징, 검색, 필터)
- [ ] 배너 등록 (이미지 업로드, 메타데이터 입력)
- [ ] 배너 수정/삭제
- [ ] 배너 노출 상태 관리 (활성/비활성/예약)
- [ ] 배너 노출 기간 설정 (시작일~종료일)
- [ ] 배너 미리보기
- [ ] 배너 클릭 URL 관리

### 2.2 Out of Scope

- 광고 노출 API (클라이언트용 배너 조회 API) - 별도 feature로 진행
- 클릭/노출 통계 대시보드 - 후속 feature
- 광고주 계정 관리 - 후속 feature
- 과금/결제 시스템

---

## 3. Requirements

### 3.1 Functional Requirements

| ID | Requirement | Priority | Status |
|----|-------------|----------|--------|
| FR-01 | 배너 목록 조회 (페이징, 상태별 필터, 키워드 검색) | High | Pending |
| FR-02 | 배너 등록 (이미지 업로드 + 메타데이터) | High | Pending |
| FR-03 | 배너 수정 (이미지 교체, 메타데이터 변경) | High | Pending |
| FR-04 | 배너 삭제 (소프트 삭제) | High | Pending |
| FR-05 | 배너 노출 상태 토글 (활성/비활성) | High | Pending |
| FR-06 | 노출 기간 예약 설정 (시작일시~종료일시) | Medium | Pending |
| FR-07 | 배너 미리보기 (등록 전/후 실제 노출 모습 확인) | Medium | Pending |
| FR-08 | 배너 정렬 순서 관리 (드래그 또는 순번 지정) | Low | Pending |

### 3.2 Non-Functional Requirements

| Category | Criteria | Measurement Method |
|----------|----------|-------------------|
| Performance | 목록 조회 응답 < 500ms | 브라우저 네트워크 탭 |
| Performance | 이미지 업로드 최대 5MB 지원 | 파일 크기 제한 검증 |
| Security | 어드민 인증 필수 (로그인한 관리자만 접근) | 세션 기반 인증 체크 |
| Security | 업로드 파일 확장자/MIME 타입 검증 | 서버 측 validation |
| Usability | 반응형 레이아웃 (1024px 이상 최적화) | 수동 테스트 |

---

## 4. Success Criteria

### 4.1 Definition of Done

- [ ] 모든 Functional Requirements 구현 완료
- [ ] 배너 CRUD 정상 동작 확인
- [ ] 이미지 업로드/미리보기 정상 동작
- [ ] 어드민 인증 연동 완료
- [ ] 코드 리뷰 완료

### 4.2 Quality Criteria

- [ ] SQL Injection 방지 (MyBatis 파라미터 바인딩)
- [ ] XSS 방지 (JSP 출력 시 이스케이프)
- [ ] 파일 업로드 보안 검증
- [ ] 빌드 성공 (Maven clean package)

---

## 5. Risks and Mitigation

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| 이미지 업로드 용량 초과 | Medium | Medium | 클라이언트/서버 양쪽에서 5MB 제한 |
| 허용되지 않은 파일 형식 업로드 | High | Medium | 확장자 + MIME 타입 이중 검증 |
| 동시 수정 충돌 (여러 관리자) | Low | Low | 낙관적 잠금 (version 필드) |
| 대량 배너 시 목록 성능 저하 | Medium | Low | 인덱스 + 페이징 처리 |

---

## 6. Architecture Considerations

### 6.1 Project Level Selection

| Level | Characteristics | Recommended For | Selected |
|-------|-----------------|-----------------|:--------:|
| **Starter** | Simple structure | Static sites | |
| **Dynamic** | Feature-based modules, BaaS integration | Web apps with backend | **O** |
| **Enterprise** | Strict layer separation, DI, microservices | High-traffic systems | |

### 6.2 Key Architectural Decisions

| Decision | Options | Selected | Rationale |
|----------|---------|----------|-----------|
| Backend Framework | Spring MVC / Spring Boot | **Spring MVC 6** | maddit 프로젝트와 동일 스택 유지 |
| ORM | MyBatis / JPA | **MyBatis 3.5** | maddit과 동일, SQL 직접 제어 |
| Database | MySQL / PostgreSQL | **MySQL** | maddit과 동일 |
| Template Engine | JSP / Thymeleaf | **JSP** | maddit과 동일 |
| Frontend | Vanilla JS / React | **Vanilla JS** | maddit과 동일, 별도 빌드 불필요 |
| Styling | CSS / Tailwind | **Pure CSS** | maddit과 동일 |
| Build Tool | Maven / Gradle | **Maven** | maddit과 동일 |
| 파일 업로드 | commons-fileupload / Spring MultipartResolver | **Spring MultipartResolver** | Spring 6 기본 지원 |
| Packaging | WAR / JAR | **WAR** | Tomcat 10+ 배포 |

### 6.3 Clean Architecture Approach

```
Selected Level: Dynamic

Folder Structure (maddit 구조 기반):
┌─────────────────────────────────────────────────────┐
│ src/main/java/com/wontherads/                       │
│   ├── controller/                                   │
│   │   └── AdBannerController.java                   │
│   ├── service/                                      │
│   │   └── AdBannerService.java                      │
│   ├── mapper/                                       │
│   │   └── AdBannerMapper.java                       │
│   └── vo/                                           │
│       └── AdBannerVO.java                           │
│                                                     │
│ src/main/resources/                                  │
│   └── mappers/                                      │
│       └── AdBannerMapper.xml                        │
│                                                     │
│ src/main/webapp/                                     │
│   ├── WEB-INF/views/admin/banner/                   │
│   │   ├── list.jsp        (배너 목록)               │
│   │   ├── form.jsp        (등록/수정 폼)            │
│   │   └── preview.jsp     (미리보기)                │
│   ├── css/admin/                                    │
│   │   └── banner.css                                │
│   ├── js/admin/                                     │
│   │   └── banner.js                                 │
│   └── upload/banner/      (업로드 이미지 저장)      │
└─────────────────────────────────────────────────────┘
```

---

## 7. Convention Prerequisites

### 7.1 Existing Project Conventions

maddit 프로젝트 컨벤션을 따름:

- [ ] Controller: `@Controller` + `@RequestMapping`
- [ ] Service: 인터페이스 없이 구현 클래스 직접 사용
- [ ] VO: getter/setter 기반 Java Bean
- [ ] Mapper: MyBatis XML 기반 SQL 매핑
- [ ] JSP: JSTL + EL 사용
- [ ] JavaScript: Vanilla JS, fetch API
- [ ] CSS: 커스텀 변수 기반, BEM 유사 구조

### 7.2 Conventions to Define/Verify

| Category | Current State | To Define | Priority |
|----------|---------------|-----------|:--------:|
| **Naming** | maddit 기반 | Controller/Service/Mapper/VO 네이밍 통일 | High |
| **Folder structure** | maddit 기반 | admin/banner/ 하위 구조 | High |
| **URL pattern** | maddit 기반 | /admin/banner/* | High |
| **이미지 저장 경로** | 미정 | upload/banner/ 또는 외부 경로 | High |
| **Error handling** | maddit 기반 | 공통 에러 페이지 | Medium |

### 7.3 Database Schema (예상)

```sql
CREATE TABLE ad_banner (
    banner_id     BIGINT AUTO_INCREMENT PRIMARY KEY,
    title         VARCHAR(200) NOT NULL,
    image_path    VARCHAR(500) NOT NULL,
    click_url     VARCHAR(1000),
    status        ENUM('ACTIVE', 'INACTIVE', 'SCHEDULED') DEFAULT 'INACTIVE',
    sort_order    INT DEFAULT 0,
    start_date    DATETIME,
    end_date      DATETIME,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_yn    CHAR(1) DEFAULT 'N'
);
```

---

## 8. Next Steps

1. [ ] Design 문서 작성 (`/pdca design ad-banner-management`)
2. [ ] DB 테이블 생성
3. [ ] 구현 시작

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 0.1 | 2026-04-01 | Initial draft | User |
