# 🌱 남부그린팝 월간 근무표 자동 편성 도구 (NambuGreenPop Scheduler)

> 노인일자리 공동체사업 전용 공정 배정 알고리즘 & Supabase 클라우드 연동 월간 근무표 자동 편성 및 이력 관리 시스템

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Web%20Browser-success.svg)]()
[![Database: Supabase](https://img.shields.io/badge/Database-Supabase%20Cloud-3ECF8E.svg)](https://supabase.com)
[![Architecture: Dual Storage](https://img.shields.io/badge/Storage-LocalStorage%20%2B%20Cloud-orange.svg)]()

---

## 📌 프로젝트 소개

**남부그린팝 월간 근무표 자동 편성 도구**는 남부그린팝 노인일자리 공동체사업단(18명 정원)의 월간 근무 스케줄을 공정하고 신속하게 편성할 수 있도록 개발된 웹 애플리케이션(SPA)입니다.

복잡한 백엔드 서버 구축 없이 웹 브라우저(Chrome, Edge 등)에서 바로 실행되며, **Supabase 클라우드 데이터베이스**와의 완벽한 연동을 지원하여 여러 담당자 또는 다양한 PC에서 실시간으로 데이터(참여자 명단, 월간 근무표, 변경기록 대장)를 동기화하고 보관할 수 있습니다. (Supabase 미연동 시 브라우저 로컬 저장소로 100% 정상 작동)

---

## ✨ 핵심 기능

### 1. ☁️ Supabase 클라우드 DB 연동 & 양방향 동기화
- **실시간 클라우드 자동 저장**: 참여자 정보, 월별 근무표, 휴무 설정, 변경기록 대장 등록 시 Supabase PostgreSQL 테이블에 자동 동기화
- **이중 저장소 아키텍처 (Dual-Storage)**: 네트워크가 끊기거나 Supabase가 설정되지 않아도 브라우저 LocalStorage를 캐시로 사용하여 100% 오프라인 작동 보장
- **원클릭 마이그레이션**:
  - `⬆️ 로컬 데이터 전체 -> Supabase 업로드`: 기존에 작업한 데이터 전체를 클라우드로 한 번에 백업/이전
  - `⬇️ Supabase 데이터 전체 -> 로컬 내려받기`: 다른 PC나 동료가 수정한 최신 데이터를 즉시 로컬로 동기화
- **헤더 상태 배지 & 퀵 모달**: 상단 배지를 통해 연결 상태(🟢 연결됨 / 🟡 로컬 모드 / 🔴 오류)를 실시간 확인하고 어디서나 1초 만에 설정 변경 가능

### 2. ⚡ 스마트 자동 편성 알고리즘
- **필수 인원 충족**:
  - 오전 (09:30~12:30): 판매 1~2명
  - 오후 (13:00~16:00): 기계 1명, 판매 1~2명, 생산 1~4명 (금요일은 판매 1~2명만 운영)
- **1인당 월 8회 균등 배정**: 참여자 18명 기준 총 144회 목표를 공정하게 분배
- **제약 조건 철저 준수**:
  - 1일 1인 1회 배정 원칙
  - 본인 배정 근무반(오전반/오후반) 준수
  - 개인별 참여 불가 일자 완전 배제
  - 직무별(판매/생산/기계) ‘불가’ 직무 배제 및 ‘선호’ 직무 우선 반영
- **공정성 보장 & 경합 우선권**:
  - 동일 슬롯 지원자 경합 시 현재 배정 횟수가 적은 인원 우선 배정
  - 과거 탈락 횟수 기반 우선권 부여로 특정인 편중 방지

### 3. 📅 직관적인 근무표 검토 (표 & 달력 뷰)
- 일자별·슬롯별 배정 인원을 한눈에 확인 가능한 **표(Table) 뷰**와 직관적인 **달력(Calendar) 뷰** 전환 지원
- 필수 인원 미달 및 기계 공석 발생 시 시각적 경고 배지 즉시 표기
- 요약 대시보드를 통해 총 배정률, 8회 목표 달성률, 필수 인원 충족률 실시간 집계

### 4. ✍️ 스마트 수동 조정 & 추천
- 불가피한 결원이나 일정 변경 시 클릭 한 번으로 배정/취소 가능
- 빈자리가 발생했을 때 배정 가능한 최적의 참여자 목록 및 점수 추천

### 5. 📝 변경이력 감사 대장 (Audit Trail)
- 수동 수정 내역(일시, 변경 전/후 대상자, 사유, 담당자)을 투명하게 기록
- 감사 및 보고용으로 언제든지 이력 추적 가능하며 Supabase `change_history`에 영구 보존

### 6. 👥 18인 참여자 프로필 관리
- 참여자별 고유 ID, 성명, 근무반, 희망 요일, 불가 일자, 직무 선호도 관리
- 엑셀 일괄 업로드 및 템플릿 다운로드 기능 내장

### 7. ⚙️ 월별 설정 & 휴무일 자동 계산
- 대상 연월 선택 시 법정 공휴일 및 주말 자동 감지
- 사업단 자체 임시 휴무일 자유 추가/해제

### 8. 📥 엑셀 내보내기 & ZIP 일괄 다운로드
- **전체 월간 근무표**: `남부그린팝_전체근무표_YYYY-MM.xlsx` (종합표 + 참여자별 배정 통계 시트)
- **개인별 근무표**: `남부그린팝_개인근무표_YYYY-MM_성명.xlsx` (개인별 18개 엑셀 파일을 ZIP으로 한 번에 압축 다운로드)

---

## ⚡ Supabase 클라우드 데이터베이스 연동 가이드

### Step 1. Supabase 프로젝트 생성
1. [supabase.com](https://supabase.com)에 로그인하고 **[New Project]**를 클릭합니다.
2. 프로젝트 이름(예: `nambu-greenpop`)과 데이터베이스 비밀번호를 지정하고 리전을 `Seoul (ap-northeast-2)`로 선택한 뒤 생성합니다.

### Step 2. 데이터베이스 테이블 생성 (SQL 실행)
1. Supabase 좌측 메뉴에서 **SQL Editor**로 이동합니다.
2. 본 저장소의 **[`supabase_schema.sql`](supabase_schema.sql)** 파일 전체 내용을 복사하여 SQL Editor에 붙여넣습니다.
3. 우측 하단의 **[Run]** 버튼을 클릭합니다.
   > 5개 테이블(`participants`, `monthly_schedules`, `monthly_settings`, `change_history`, `app_settings`), 익명 RLS 정책, 초기 18인 기본 명단이 한 번에 자동 생성됩니다.

### Step 3. 웹앱에서 API 키 연결
1. Supabase 좌측 메뉴 하단의 **Project Settings (톱니바퀴) > Data API**로 이동합니다.
2. 아래 2가지 값을 복사합니다:
   - **Project URL** (예: `https://abcdefghijklmn.supabase.co`)
   - **Project API keys**의 `anon` `public` 키 (예: `eyJhbGciOi...`)
3. 근무표 웹앱을 열고 상단 **[☁️ 클라우드 DB]** 탭(또는 상단 헤더의 DB 버튼)을 클릭합니다.
4. `Project URL`과 `Anon Public API Key`를 붙여넣고 **[🔗 연결 및 저장]** 버튼을 누릅니다.
5. 연결 성공 후 **[⬆️ 로컬 데이터 전체 -> Supabase로 업로드]**를 한 번 눌러주시면 모든 기존 데이터가 클라우드로 복제됩니다.

---

## 🚀 빠른 시작 (Getting Started)

별도의 Node.js, Python 또는 백엔드 서버 설치가 필요하지 않습니다.

1. 이 저장소를 로컬 컴퓨터에 다운로드(Clone 또는 ZIP 다운로드)합니다.
2. 폴더 내의 **`근무표작성도구_실행.bat`** 파일을 더블 클릭하여 실행하거나, **`index.html`** 파일을 웹 브라우저로 엽니다.
3. 상단에서 **편성 대상 연월**을 선택하고 **[⚡ 자동 편성 실행]** 버튼을 클릭합니다.
4. 배정 상태를 검토한 뒤 **[📥 확정 및 엑셀 다운로드]** 탭에서 최종 근무표를 출력합니다.

---

## 📂 프로젝트 구조

```text
├── index.html                           # 메인 SPA 앱 (UI + 스케줄링 엔진 + Supabase 연동 + 엑셀 생성)
├── supabase_schema.sql                  # Supabase 테이블/RLS/초기 데이터 원클릭 생성 SQL 스크립트
├── DESIGN.md                            # UI 디자인 시스템 가이드 및 토큰 명세 (Perplexity Theme)
├── 남부그린팝_월간근무표_자동편성_PRD.md  # 제품 요구사항 정의서 (기획 및 제약조건)
├── 근무표작성도구_실행.bat                # 윈도우 원클릭 브라우저 실행 배치 파일
└── README.md                            # 프로젝트 안내 및 사용자 매뉴얼
```

---

## 🛠️ 기술 스택 (Tech Stack)

- **Frontend**: Pure HTML5, Modern CSS3 (Flexbox/Grid/CSS Variables), Vanilla JavaScript (ES6+)
- **Database & Cloud**: [Supabase](https://supabase.com/) (`@supabase/supabase-js v2`), PostgreSQL
- **Libraries**:
  - [SheetJS (xlsx)](https://sheetjs.com/): 엑셀 파일 파싱 및 스타일 서식 생성
  - [JSZip](https://stuk.github.io/jszip/): 18인 개인별 근무표 ZIP 일괄 압축 패키징
  - [FileSaver.js](https://github.com/eligrey/FileSaver.js): 크로스 브라우저 파일 다운로드
- **Design System**: Perplexity Style Reference 기반의 가독성 높은 따뜻한 페이퍼 톤 UI (`DESIGN.md`)

---

## 📋 운영 기준 요약

| 구분 | 운영 조건 및 기준 |
| :--- | :--- |
| **운영 요일** | 월요일 ~ 금요일 (주말 및 법정 공휴일 제외) |
| **오전 근무** | 09:30 ~ 12:30 (판매 1~2명) |
| **오후 근무** | 13:00 ~ 16:00 (월~목: 기계 1명, 판매 1~2명, 생산 1~4명 / 금: 판매 1~2명) |
| **월 목표** | 참여자 18명 × 1인당 월 8회 = 총 144회 배정 |
| **직무 종류** | 판매, 생산, 기계 (선호 / 가능 / 불가 3단계 조건) |

---

## 📄 라이선스

This project is licensed under the MIT License.
