# LegalPromptHub 구현 계획

## 프로젝트 개요
- **목적**: 변호사를 위한 AI 프롬프트 저장 및 공유 플랫폼
- **기술 스택**: Rails 8, PostgreSQL, Tailwind CSS, Devise, Turbo, Stimulus
- **개발 일시**: 2025-01-09

## 구현 순서 및 상세 계획

### 1. 기본 환경 설정 ✓
- Rails 8 프로젝트 생성 완료
- 기본 gem 설치 완료

### 2. Gemfile 수정 및 번들 설치
```ruby
# 추가할 gem들:
- devise (~> 4.9) - 인증
- tailwindcss-rails (~> 3.0) - CSS 프레임워크
- pg (~> 1.5) - PostgreSQL 어댑터
- redis (>= 5.0) - Action Cable용
```

### 3. Devise 설치 및 User 모델 구성
- Devise 설치: `rails generate devise:install`
- User 모델 생성: `rails generate devise User`
- name 필드 추가: `rails generate migration AddNameToUsers name:string`
- Devise 뷰 생성: `rails generate devise:views`
- Strong parameters 설정 (ApplicationController)

### 4. LegalPrompt 모델 생성
- 모델 생성: `rails generate model LegalPrompt title:string category:integer content:text user:references`
- enum 설정 (7개 카테고리)
- 유효성 검사 추가
- 관계 설정 (belongs_to :user)
- 한국어 카테고리명 메소드 추가

### 5. 컨트롤러 생성
- Dashboard 컨트롤러: 메인 대시보드
- LegalPrompts 컨트롤러: CRUD 작업
- 권한 체크 (본인 것만 수정/삭제)

### 6. 라우팅 설정
- 인증된 사용자 root: dashboard#index
- 비인증 사용자 root: legal_prompts#index
- legal_prompts 리소스 라우트

### 7. 뷰 템플릿 구현 (4개 화면)
1. **인증 화면** (로그인/회원가입 통합)
   - Devise 뷰 커스터마이징
   - 이메일, 비밀번호, 이름(회원가입시)
   
2. **대시보드** (메인)
   - 환영 메시지
   - 새 프롬프트 등록 버튼
   - 최근 프롬프트 목록
   - 전체 프롬프트 보기 링크
   
3. **프롬프트 폼** (생성/수정)
   - 제목 입력
   - 카테고리 선택 (드롭다운)
   - 내용 입력 (텍스트에어리어)
   - 저장/취소 버튼
   
4. **프롬프트 상세**
   - 제목, 카테고리, 작성자 표시
   - 프롬프트 내용
   - 복사하기 버튼 (Stimulus)
   - 수정/삭제 버튼 (본인만)

### 8. Stimulus 컨트롤러 구현
- clipboard_controller.js 생성
- 복사 기능 구현
- 성공/실패 피드백 UI

### 9. Tailwind CSS 스타일링
- 메인 컬러: emerald-600 (#059669)
- 보조 컬러: gray-100 (#f3f4f6)
- 반응형 디자인
- 카드 컴포넌트 스타일
- 버튼 스타일 (주/보조)
- 폼 입력 스타일

### 10. 한국어 i18n 설정
- config/locales/ko.yml 생성
- 카테고리명 한국어 설정
- 기본 메시지 한국어화
- 날짜/시간 포맷 설정

### 11. 시드 데이터 생성
- 테스트 사용자 1명
- 샘플 프롬프트 3개
- 각 카테고리별 예시

### 12. 테스트 및 검증
- CRUD 기능 테스트
- 권한 체크 테스트
- 복사 기능 브라우저 테스트
- 모바일 반응형 테스트

## 파일 구조
```
app/
├── controllers/
│   ├── application_controller.rb
│   ├── dashboard_controller.rb
│   └── legal_prompts_controller.rb
├── models/
│   ├── user.rb
│   └── legal_prompt.rb
├── views/
│   ├── layouts/
│   │   └── application.html.erb
│   ├── devise/
│   │   ├── registrations/
│   │   └── sessions/
│   ├── dashboard/
│   │   └── index.html.erb
│   └── legal_prompts/
│       ├── index.html.erb
│       ├── show.html.erb
│       ├── new.html.erb
│       ├── edit.html.erb
│       └── _form.html.erb
├── javascript/
│   └── controllers/
│       └── clipboard_controller.js
config/
├── routes.rb
├── locales/
│   └── ko.yml
db/
├── migrate/
└── seeds.rb
```

## 주요 기능 구현 포인트
1. **인증**: Devise로 이메일 기반 인증
2. **권한**: 본인 프롬프트만 수정/삭제 가능
3. **복사**: Stimulus + Clipboard API
4. **카테고리**: enum으로 7개 고정값 관리
5. **UI/UX**: Tailwind로 깔끔한 인터페이스

## 예상 소요 시간
- 전체 구현: 2-3시간
- 기본 기능: 1시간
- UI 스타일링: 30분
- 테스트 및 디버깅: 30분

## 성공 기준
- [x] Rails 8 프로젝트 생성
- [ ] 회원가입/로그인 정상 작동
- [ ] 프롬프트 CRUD 기능 완성
- [ ] 복사 기능 모든 브라우저 작동
- [ ] 모바일 반응형 UI
- [ ] 한국어 인터페이스