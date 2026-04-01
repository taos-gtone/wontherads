# 광고배너관리 (Ad Banner Management) Design Document

> **Summary**: 매체/플랫폼/노출위치별 배너 광고를 관리하는 어드민 CRUD 시스템 설계
>
> **Project**: wontherads
> **Author**: User
> **Date**: 2026-04-01
> **Status**: Draft
> **Planning Doc**: [ad-banner-management.plan.md](../01-plan/features/ad-banner-management.plan.md)

---

## 1. Overview

### 1.1 Design Goals

- maddit 프로젝트와 동일한 Spring MVC + MyBatis + JSP 패턴으로 일관성 유지
- 매체(사이트) → 플랫폼(웹/윈앱/모앱) → 노출위치 계층 구조로 배너 관리
- 가중치(weight) 기반 노출 빈도 조절 지원
- 이미지 업로드/미리보기 기능 포함

### 1.2 Design Principles

- maddit 코드 패턴(Controller → Service → Mapper → VO) 동일 적용
- 소프트 삭제(deleted_yn) 패턴 일관 유지
- 페이징/검색/필터 공통 패턴 재사용

---

## 2. Architecture

### 2.1 Component Diagram

```
┌─────────────┐     ┌──────────────────────────────┐     ┌─────────────┐
│   Browser   │────▶│   Spring MVC Controller      │────▶│    MySQL    │
│  (Admin UI) │     │   + MultipartResolver        │     │  (5 tables) │
│   JSP/JS    │◀────│   + Service + MyBatis Mapper │◀────│             │
└─────────────┘     └──────────────────────────────┘     └─────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  File System     │
                    │  /upload/banner/ │
                    └──────────────────┘
```

### 2.2 Data Flow

```
[배너 등록 흐름]
매체 선택 → 플랫폼 선택 → 노출위치 선택(AJAX 동적 로드) → 배너 정보 입력 + 이미지 업로드 → 저장

[배너 목록 흐름]
목록 조회(필터: 매체/플랫폼/상태) → 페이징 → 상태 토글 → 수정/삭제
```

### 2.3 Dependencies

| Component | Depends On | Purpose |
|-----------|-----------|---------|
| AdBannerController | AdBannerService | 비즈니스 로직 위임 |
| AdBannerService | AdBannerMapper | DB 접근 |
| AdBannerController | AdMediaService | 매체/플랫폼/위치 조회 |
| JSP (form.jsp) | AdBannerController AJAX | 플랫폼별 노출위치 동적 로드 |

---

## 3. Data Model

### 3.1 Entity Relationships

```
ad_media (매체: 사이트A, 사이트B)
    │
    ├──< ad_media_platform >──┤  (매체별 지원 플랫폼)
    │                         │
    │                    ad_platform (웹/윈앱/모앱)
    │                         │
    │                         ├──< ad_placement (플랫폼별 노출 위치)
    │                         │
    └────────┬────────────────┘
             │
        ad_banner (매체 + 플랫폼 + 위치 조합으로 배너 등록)
```

### 3.2 Database Schema

**실제 DB 테이블 (생성 완료)**

| 테이블명 | 설명 | 비고 |
|----------|------|------|
| ADM_LOGIN_INFO | 관리자 접속정보 | 어드민 인증용 |
| ADS_MEDIA | 광고 매체 (배너를 노출할 사이트/앱) | |
| ADS_PLATFORM | 광고 플랫폼 (웹/윈도우앱/모바일앱) | |
| ADS_MEDIA_PLATFORM | 광고 매체별 플랫폼매핑 | |
| ADS_PLACEMENT | 광고 플랫폼별 배너노출위치 | |
| ADS_BANNER | 광고 배너광고 (핵심) | weight 포함 |

```
ADM_LOGIN_INFO
─────────────────────────────────────────────────
admin_id         varchar     관리자아이디 (PK)
admin_pw         varchar     관리자비밀번호(bcrypt)
adm_email_id     varchar     관리자이메일아이디
adm_email_addr   varchar     관리자이메일주소
last_login_at    datetime    최종로그인시간
create_ts        timestamp   등록시간
update_ts        timestamp   수정시간

ADS_MEDIA
─────────────────────────────────────────────────
media_id         bigint(20)  매체ID (PK, AI)
media_name       varchar(100) 매체명
media_url        varchar(500) 매체 대표 URL
description      varchar(500) 매체 설명
use_yn           char(1)     사용여부
created_at       datetime    등록시간
updated_at       datetime    수정시간

ADS_PLATFORM
─────────────────────────────────────────────────
platform_id      bigint(20)  플랫폼ID (PK, AI)
platform_code    varchar(20) 플랫폼코드 (WEB, WIN_APP, MOBILE_APP)
platform_name    varchar(50) 웹, 윈도우앱, 모바일앱
use_yn           char(1)     사용여부
created_at       datetime    등록시간

ADS_MEDIA_PLATFORM
─────────────────────────────────────────────────
media_platform_id bigint(20) 매체플랫폼ID (PK, AI)
media_id          bigint(20) 매체ID (FK)
platform_id       bigint(20) 플랫폼ID (FK)
use_yn            char(1)    사용여부
created_at        datetime   등록시간

ADS_PLACEMENT
─────────────────────────────────────────────────
placement_id     bigint(20)  위치ID (PK, AI)
platform_id      bigint(20)  플랫폼ID (FK)
placement_code   varchar(50) 위치코드
placement_name   varchar(100) 위치명
width            int(11)     권장 가로 px
height           int(11)     권장 세로 px
description      varchar(500) 설명
use_yn           char(1)     사용여부
created_at       datetime    등록시간

ADS_BANNER
─────────────────────────────────────────────────
banner_id        bigint(20)  배너ID (PK, AI)
media_id         bigint(20)  매체ID (FK)
platform_id      bigint(20)  플랫폼ID (FK)
placement_id     bigint(20)  위치ID (FK)
title            varchar(200) 배너 제목
image_path       varchar(500) 배너 이미지 경로
click_url        varchar(1000) 클릭 시 이동 URL
alt_text         varchar(200) 이미지 대체 텍스트
status           enum('ACTIVE','INACTIVE','SCHEDULED')
weight           int(11)     노출 가중치 (1~100)
sort_order       int(11)     노출 우선순위
start_date       datetime    노출 시작일시
end_date         datetime    노출 종료일시
created_at       datetime    등록시간
updated_at       datetime    수정시간
deleted_yn       char(1)     삭제여부
```

---

## 4. API Specification (Controller Endpoints)

### 4.1 배너 관리 (AdBannerController)

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| GET | /admin/banner | 배너 목록 (필터/페이징) | Admin |
| GET | /admin/banner/write | 배너 등록 폼 | Admin |
| POST | /admin/banner/write | 배너 등록 처리 | Admin |
| GET | /admin/banner/view/{bannerId} | 배너 상세 조회 | Admin |
| GET | /admin/banner/edit/{bannerId} | 배너 수정 폼 | Admin |
| POST | /admin/banner/edit/{bannerId} | 배너 수정 처리 | Admin |
| POST | /admin/banner/delete | 배너 삭제 (AJAX, 소프트삭제) | Admin |
| POST | /admin/banner/toggle-status | 상태 토글 (AJAX) | Admin |

### 4.2 AJAX Endpoints (JSON 응답)

| Method | Path | Description | Request | Response |
|--------|------|-------------|---------|----------|
| GET | /admin/banner/api/placements | 플랫폼별 노출위치 조회 | `?platformId=1` | `[{placementId, placementName, width, height}]` |
| GET | /admin/banner/api/platforms | 매체별 플랫폼 조회 | `?mediaId=1` | `[{platformId, platformCode, platformName}]` |
| POST | /admin/banner/delete | 배너 삭제 | `bannerId=123` | `{success: true}` |
| POST | /admin/banner/toggle-status | 상태 토글 | `bannerId=123` | `{success: true, status: 'ACTIVE'}` |

### 4.3 Detailed Specification

#### `POST /admin/banner/write`

**Request (multipart/form-data):**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| mediaId | long | Y | 매체 ID |
| platformId | long | Y | 플랫폼 ID |
| placementId | long | Y | 노출위치 ID |
| title | String | Y | 배너 제목 |
| imageFile | MultipartFile | Y | 배너 이미지 파일 |
| clickUrl | String | N | 클릭 URL |
| altText | String | N | 대체 텍스트 |
| status | String | Y | ACTIVE/INACTIVE/SCHEDULED |
| weight | int | N (default 1) | 노출 가중치 1~100 |
| sortOrder | int | N (default 0) | 정렬 순서 |
| startDate | String | N | 노출 시작일시 (yyyy-MM-dd HH:mm) |
| endDate | String | N | 노출 종료일시 (yyyy-MM-dd HH:mm) |

**Success:** `redirect:/admin/banner/view/{bannerId}`
**Error:** form 페이지로 돌아가며 에러 메시지 표시

---

## 5. UI/UX Design

### 5.1 배너 목록 화면 (list.jsp)

```
┌────────────────────────────────────────────────────────────────┐
│  Header (admin layout)                                         │
├────────────────────────────────────────────────────────────────┤
│  📋 배너 광고 관리                              [+ 배너 등록]  │
├────────────────────────────────────────────────────────────────┤
│  [매체 ▼] [플랫폼 ▼] [상태 ▼] [검색어____] [검색]            │
├────────────────────────────────────────────────────────────────┤
│  번호 │ 매체 │ 플랫폼 │ 위치 │ 제목 │ 상태 │ 가중치 │ 기간   │ 관리  │
│  ─────┼──────┼────────┼──────┼──────┼──────┼────────┼────────┼───── │
│  5    │사이트A│ 웹     │상단  │봄세일│ ✅   │  70    │04/01~  │수정 삭제│
│  4    │사이트B│모바일  │하단  │이벤트│ ⏸️   │  30    │03/15~  │수정 삭제│
│  ...                                                           │
├────────────────────────────────────────────────────────────────┤
│                    ‹ 1 2 3 4 5 ›                               │
└────────────────────────────────────────────────────────────────┘
```

### 5.2 배너 등록/수정 화면 (form.jsp)

```
┌────────────────────────────────────────────────────────────────┐
│  📝 배너 등록 (수정)                                           │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  매체 선택:     [사이트A ▼]                                    │
│  플랫폼 선택:   [웹 ▼]          ← 매체 선택 시 AJAX 로드      │
│  노출 위치:     [상단 배너 ▼]   ← 플랫폼 선택 시 AJAX 로드    │
│                 권장 사이즈: 1200 x 120 px                     │
│                                                                │
│  ─────────────────────────────────────────────                 │
│  배너 제목:     [________________________]                     │
│  클릭 URL:      [https://_________________]                    │
│  대체 텍스트:   [________________________]                     │
│                                                                │
│  배너 이미지:   [파일 선택]                                    │
│                 ┌──────────────────┐                           │
│                 │   미리보기 영역   │                           │
│                 │   (선택한 이미지) │                           │
│                 └──────────────────┘                           │
│                                                                │
│  노출 상태:     ○ 비활성  ○ 활성  ○ 예약                      │
│  노출 가중치:   [___50___] (1~100, 높을수록 자주 노출)         │
│  정렬 순서:     [____0___] (낮을수록 먼저)                     │
│  시작일시:      [2026-04-01 00:00]                             │
│  종료일시:      [2026-04-30 23:59]                             │
│                                                                │
│            [취소]  [미리보기]  [저장]                           │
└────────────────────────────────────────────────────────────────┘
```

### 5.3 User Flow

```
목록 → [+ 배너 등록] → 매체 선택 → 플랫폼 선택(AJAX) → 위치 선택(AJAX)
     → 정보 입력 + 이미지 업로드 → [저장] → 상세 조회 → 목록
```

### 5.4 Component List

| Component | Location | Responsibility |
|-----------|----------|----------------|
| list.jsp | WEB-INF/views/admin/banner/ | 배너 목록, 필터, 페이징 |
| form.jsp | WEB-INF/views/admin/banner/ | 배너 등록/수정 폼 (공용) |
| view.jsp | WEB-INF/views/admin/banner/ | 배너 상세 조회 |
| banner.css | css/admin/ | 배너 관리 스타일 |
| banner.js | js/admin/ | AJAX 동적 로드, 이미지 미리보기, 폼 검증 |

---

## 6. File Structure (Implementation)

### 6.1 Java Layer

```
src/main/java/com/wontherads/
├── controller/
│   └── AdBannerController.java        # 배너 CRUD + AJAX endpoints
├── service/
│   ├── AdBannerService.java           # 배너 서비스 인터페이스
│   ├── AdBannerServiceImpl.java       # 배너 서비스 구현
│   ├── AdMediaService.java            # 매체/플랫폼/위치 서비스 인터페이스
│   └── AdMediaServiceImpl.java        # 매체/플랫폼/위치 서비스 구현
├── mapper/
│   ├── AdBannerMapper.java            # 배너 MyBatis Mapper
│   └── AdMediaMapper.java             # 매체/플랫폼/위치 Mapper
└── vo/
    ├── AdBannerVO.java                # 배너 VO
    ├── AdMediaVO.java                 # 매체 VO
    ├── AdPlatformVO.java              # 플랫폼 VO
    └── AdPlacementVO.java             # 노출위치 VO
```

### 6.2 MyBatis XML

```
src/main/resources/mappers/
├── AdBannerMapper.xml
└── AdMediaMapper.xml
```

### 6.3 View Layer

```
src/main/webapp/
├── WEB-INF/views/admin/banner/
│   ├── list.jsp                       # 목록
│   ├── form.jsp                       # 등록/수정 공용 폼
│   └── view.jsp                       # 상세 조회
├── css/admin/
│   └── banner.css
├── js/admin/
│   └── banner.js
└── upload/banner/                     # 이미지 저장 디렉토리
```

---

## 7. VO Design

### 7.1 AdBannerVO

```java
public class AdBannerVO {
    // DB 컬럼
    private long      bannerId;
    private long      mediaId;
    private long      platformId;
    private long      placementId;
    private String    title;
    private String    imagePath;
    private String    clickUrl;
    private String    altText;
    private String    status;          // ACTIVE, INACTIVE, SCHEDULED
    private int       weight;          // 노출 가중치 1~100
    private int       sortOrder;
    private String    startDate;       // yyyy-MM-dd HH:mm
    private String    endDate;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String    deletedYn;

    // JOIN 필드
    private String    mediaName;       // ad_media.media_name
    private String    platformName;    // ad_platform.platform_name
    private String    platformCode;    // ad_platform.platform_code
    private String    placementName;   // ad_placement.placement_name
    private int       placementWidth;  // ad_placement.width
    private int       placementHeight; // ad_placement.height

    // getter/setter 전체
}
```

### 7.2 AdMediaVO

```java
public class AdMediaVO {
    private long      mediaId;
    private String    mediaName;
    private String    mediaUrl;
    private String    description;
    private String    useYn;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    // getter/setter
}
```

### 7.3 AdPlatformVO

```java
public class AdPlatformVO {
    private long      platformId;
    private String    platformCode;
    private String    platformName;
    private String    useYn;
    private Timestamp createdAt;
    // getter/setter
}
```

### 7.4 AdPlacementVO

```java
public class AdPlacementVO {
    private long      placementId;
    private long      platformId;
    private String    placementCode;
    private String    placementName;
    private int       width;
    private int       height;
    private String    description;
    private String    useYn;
    private Timestamp createdAt;
    // getter/setter
}
```

---

## 8. MyBatis SQL Design

### 8.1 AdBannerMapper.xml (주요 쿼리)

```xml
<!-- 공통 검색 WHERE 절 -->
<sql id="searchWhere">
    AND b.deleted_yn = 'N'
    <if test="mediaId != null and mediaId > 0">
        AND b.media_id = #{mediaId}
    </if>
    <if test="platformId != null and platformId > 0">
        AND b.platform_id = #{platformId}
    </if>
    <if test="status != null and status != ''">
        AND b.status = #{status}
    </if>
    <if test="searchKeyword != null and searchKeyword != ''">
        AND b.title LIKE CONCAT('%', #{searchKeyword}, '%')
    </if>
</sql>

<!-- 목록 조회 (JOIN) -->
<select id="selectBannerList" resultType="AdBannerVO">
    SELECT
        b.banner_id, b.title, b.image_path, b.status,
        b.weight, b.sort_order, b.start_date, b.end_date,
        b.created_at, b.updated_at,
        m.media_name,
        p.platform_name, p.platform_code,
        pl.placement_name, pl.width AS placement_width, pl.height AS placement_height
    FROM ADS_BANNER b
    LEFT JOIN ADS_MEDIA m ON m.media_id = b.media_id
    LEFT JOIN ADS_PLATFORM p ON p.platform_id = b.platform_id
    LEFT JOIN ADS_PLACEMENT pl ON pl.placement_id = b.placement_id
    WHERE 1=1
    <include refid="searchWhere"/>
    ORDER BY b.sort_order ASC, b.banner_id DESC
    LIMIT #{pageSize} OFFSET #{offset}
</select>

<!-- 건수 -->
<select id="selectBannerCount" resultType="int">
    SELECT COUNT(*)
    FROM ADS_BANNER b
    WHERE 1=1
    <include refid="searchWhere"/>
</select>

<!-- 단건 조회 -->
<select id="selectBanner" resultType="AdBannerVO">
    SELECT
        b.*, m.media_name, p.platform_name, p.platform_code,
        pl.placement_name, pl.width AS placement_width, pl.height AS placement_height
    FROM ADS_BANNER b
    LEFT JOIN ADS_MEDIA m ON m.media_id = b.media_id
    LEFT JOIN ADS_PLATFORM p ON p.platform_id = b.platform_id
    LEFT JOIN ADS_PLACEMENT pl ON pl.placement_id = b.placement_id
    WHERE b.banner_id = #{bannerId}
      AND b.deleted_yn = 'N'
</select>

<!-- 등록 -->
<insert id="insertBanner" useGeneratedKeys="true" keyProperty="bannerId">
    INSERT INTO ADS_BANNER
        (media_id, platform_id, placement_id, title, image_path,
         click_url, alt_text, status, weight, sort_order, start_date, end_date)
    VALUES
        (#{mediaId}, #{platformId}, #{placementId}, #{title}, #{imagePath},
         #{clickUrl}, #{altText}, #{status}, #{weight}, #{sortOrder}, #{startDate}, #{endDate})
</insert>

<!-- 수정 -->
<update id="updateBanner">
    UPDATE ADS_BANNER SET
        media_id     = #{mediaId},
        platform_id  = #{platformId},
        placement_id = #{placementId},
        title        = #{title},
        <if test="imagePath != null and imagePath != ''">
        image_path   = #{imagePath},
        </if>
        click_url    = #{clickUrl},
        alt_text     = #{altText},
        status       = #{status},
        weight       = #{weight},
        sort_order   = #{sortOrder},
        start_date   = #{startDate},
        end_date     = #{endDate},
        updated_at   = NOW()
    WHERE banner_id  = #{bannerId}
      AND deleted_yn = 'N'
</update>

<!-- 소프트 삭제 -->
<update id="deleteBanner">
    UPDATE ADS_BANNER
       SET deleted_yn = 'Y', updated_at = NOW()
     WHERE banner_id = #{bannerId}
</update>

<!-- 상태 토글 -->
<update id="toggleBannerStatus">
    UPDATE ADS_BANNER
       SET status = CASE WHEN status = 'ACTIVE' THEN 'INACTIVE' ELSE 'ACTIVE' END,
           updated_at = NOW()
     WHERE banner_id = #{bannerId}
       AND deleted_yn = 'N'
</update>
```

### 8.2 AdMediaMapper.xml (주요 쿼리)

```xml
<!-- 활성 매체 목록 -->
<select id="selectMediaList" resultType="AdMediaVO">
    SELECT * FROM ADS_MEDIA WHERE use_yn = 'Y' ORDER BY media_name
</select>

<!-- 매체별 플랫폼 목록 -->
<select id="selectPlatformsByMedia" resultType="AdPlatformVO">
    SELECT p.*
    FROM ADS_PLATFORM p
    INNER JOIN ADS_MEDIA_PLATFORM mp ON mp.platform_id = p.platform_id
    WHERE mp.media_id = #{mediaId}
      AND mp.use_yn = 'Y'
      AND p.use_yn = 'Y'
    ORDER BY p.platform_id
</select>

<!-- 플랫폼별 노출위치 목록 -->
<select id="selectPlacementsByPlatform" resultType="AdPlacementVO">
    SELECT * FROM ADS_PLACEMENT
    WHERE platform_id = #{platformId}
      AND use_yn = 'Y'
    ORDER BY placement_id
</select>

<!-- 전체 플랫폼 목록 (필터용) -->
<select id="selectAllPlatforms" resultType="AdPlatformVO">
    SELECT * FROM ADS_PLATFORM WHERE use_yn = 'Y' ORDER BY platform_id
</select>
```

---

## 9. Controller Design

### 9.1 AdBannerController

```java
@Controller
@RequestMapping("/admin/banner")
public class AdBannerController {

    private static final int PAGE_SIZE = 15;
    private static final int PAGE_BTN  = 5;

    @Autowired private AdBannerService bannerService;
    @Autowired private AdMediaService mediaService;
    @Value("${file.upload.base-path}") private String basePath;

    // GET  ""           → 목록 (필터: mediaId, platformId, status, searchKeyword)
    // GET  "/write"     → 등록 폼 (매체 목록 로드)
    // POST "/write"     → 등록 처리 (MultipartFile imageFile)
    // GET  "/view/{id}" → 상세 조회
    // GET  "/edit/{id}" → 수정 폼
    // POST "/edit/{id}" → 수정 처리 (MultipartFile newImageFile)
    // POST "/delete"    → @ResponseBody 소프트 삭제
    // POST "/toggle-status" → @ResponseBody 상태 토글

    // AJAX endpoints
    // GET  "/api/platforms?mediaId="    → @ResponseBody 매체별 플랫폼
    // GET  "/api/placements?platformId=" → @ResponseBody 플랫폼별 위치
}
```

### 9.2 이미지 업로드 처리 로직

```
1. 확장자 검증: jpg, jpeg, png, gif, webp만 허용
2. MIME 타입 검증: image/* 만 허용
3. 파일 크기: 5MB 이하
4. 저장 경로: {basePath}/banner/{yyyyMMdd}/{UUID}.{ext}
5. DB 저장: 상대 경로 /banner/{yyyyMMdd}/{UUID}.{ext}
6. 수정 시: 새 이미지 업로드되면 기존 파일 삭제 후 교체
```

---

## 10. JavaScript Design (banner.js)

### 10.1 매체/플랫폼/위치 연동 (Cascading Select)

```javascript
// 매체 변경 → 플랫폼 목록 AJAX 로드
// 플랫폼 변경 → 노출위치 목록 AJAX 로드 + 권장 사이즈 표시
// fetch API 사용 (maddit 패턴)
```

### 10.2 이미지 미리보기

```javascript
// FileReader.readAsDataURL() → img.src에 적용
// 파일 크기 5MB 초과 시 alert + 초기화
// 확장자 검증 (클라이언트 측)
```

### 10.3 폼 검증

```javascript
// 필수 필드: mediaId, platformId, placementId, title, imageFile(등록시)
// weight: 1~100 범위 검증
// 날짜: startDate < endDate 검증
```

---

## 11. Error Handling

### 11.1 Error Scenarios

| Code | Message | Cause | Handling |
|------|---------|-------|----------|
| 400 | 필수 항목 누락 | 폼 검증 실패 | 폼 페이지로 에러 메시지 반환 |
| 400 | 허용되지 않은 파일 형식 | 이미지 확장자/MIME 오류 | alert 표시 |
| 400 | 파일 크기 초과 (5MB) | 업로드 제한 초과 | alert 표시 |
| 401 | 로그인 필요 | 세션 만료 | 로그인 페이지로 redirect |
| 404 | 배너를 찾을 수 없음 | 삭제된 배너 접근 | 목록으로 redirect |
| 500 | 서버 오류 | 파일 저장 실패 등 | 에러 페이지 표시 |

---

## 12. Security Considerations

- [x] MyBatis #{} 파라미터 바인딩 (SQL Injection 방지)
- [x] JSP에서 HtmlUtils.htmlEscape() 출력 (XSS 방지)
- [x] 업로드 파일 확장자 + MIME 타입 이중 검증
- [x] 업로드 파일명 UUID 변환 (경로 탐색 공격 방지)
- [x] Admin 세션 인증 체크 (Interceptor)
- [x] 5MB 파일 크기 제한

---

## 13. Implementation Order

1. [ ] **DB**: 테이블 5개 생성 + 초기 데이터 INSERT
2. [ ] **VO**: AdBannerVO, AdMediaVO, AdPlatformVO, AdPlacementVO
3. [ ] **Mapper**: AdBannerMapper.java/xml, AdMediaMapper.java/xml
4. [ ] **Service**: AdBannerServiceImpl, AdMediaServiceImpl
5. [ ] **Controller**: AdBannerController (CRUD + AJAX endpoints)
6. [ ] **JSP**: list.jsp, form.jsp, view.jsp
7. [ ] **CSS/JS**: banner.css, banner.js (AJAX 연동, 이미지 미리보기)
8. [ ] **Spring 설정**: component-scan, multipart, resources mapping 추가
9. [ ] **테스트**: 전체 CRUD + 이미지 업로드 + 상태 토글 동작 확인

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 0.1 | 2026-04-01 | Initial draft | User |
