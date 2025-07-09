# LegalPromptHub MVP 기획서 (Rails 8)

## 1. 프로젝트 개요

**목적**: 검증되지 않는 프롬프트 사용으로 인한 변호사들의 시간 낭비 해결  
**대상**: AI 도구를 활용하는 변호사  
**핵심 가치**: 변호사가 검증된 AI 프롬프트를 저장하고 원클릭으로 복사해서 사용한다

**기술 스택**:
- Ruby on Rails 8.0
- SQLite3 (개발), PostgreSQL (프로덕션)
- Tailwind CSS 3.4
- Devise (인증)
- Turbo (Rails 8 기본)
- Stimulus (Rails 8 기본)

**디자인**:
- 메인 컬러: #059669 (emerald-600)
- 보조 컬러: #f3f4f6 (gray-100)
- 모바일 우선 반응형
- 심플하고 직관적인 UI

## 2. 기능 범위

### 포함 (MVP)
- 회원가입/로그인 (이메일 방식)
- 프롬프트 생성/조회/수정/삭제 (CRUD)
- 프롬프트 원클릭 복사
- 본인 프롬프트만 수정/삭제
- 모든 프롬프트 공개 조회
- 기본 카테고리 분류 (고정값)

### 제외 (다음 버전)
- 소셜 로그인
- 검색 기능
- 카테고리 관리
- 평가/리뷰 시스템
- 통계/분석
- 팀/그룹 기능
- 즐겨찾기

## 3. 데이터 모델

### User (사용자)
```ruby
# Devise가 자동 생성
- email: string (필수, 고유)
- encrypted_password: string
- name: string (필수)
- created_at: datetime
- updated_at: datetime
```

### LegalPrompt (법무 프롬프트)
```ruby
- title: string (필수, 최대 255자)
- category: integer (필수, enum)
- content: text (필수)
- user_id: bigint (필수, 외래키)
- created_at: datetime
- updated_at: datetime
```

**카테고리 enum 정의**:
```ruby
enum category: {
  party_analysis: 0,      # 당사자정보분석
  fact_organizing: 1,     # 사실관계정리
  evidence_linking: 2,    # 증거연결
  keyword_extraction: 3,  # 검색어추출
  law_extraction: 4,      # 관련법령추출
  legal_principles: 5,    # 관련법리추출
  case_search: 6          # 유사판례검색
}
```

**관계**: User has_many :legal_prompts

## 4. 화면 구성 (총 4개)

### 4.1 인증 화면 (로그인/회원가입 통합)
```
┌─────────────────────────────┐
│      LegalPromptHub         │
│   변호사를 위한 AI 프롬프트   │
├─────────────────────────────┤
│  [이메일________________]    │
│  [비밀번호______________]    │
│                            │
│  [로그인] [회원가입]        │
│                            │
│  비밀번호 찾기             │
└─────────────────────────────┘
```

### 4.2 대시보드 (메인)
```
┌─────────────────────────────┐
│ LegalPromptHub   [로그아웃] │
├─────────────────────────────┤
│ 안녕하세요 [이름]님!         │
│                            │
│ [+ 새 프롬프트 등록]        │
│                            │
│ 최근 프롬프트              │
├─────────────────────────────┤
│ □ 계약서 검토 프롬프트      │
│   당사자정보분석 | 3일 전   │
├─────────────────────────────┤
│ □ 소장 작성 도우미         │
│   사실관계정리 | 5일 전     │
├─────────────────────────────┤
│ [모든 프롬프트 보기]        │
└─────────────────────────────┘
```

### 4.3 프롬프트 폼 (생성/수정)
```
┌─────────────────────────────┐
│ < 뒤로    프롬프트 등록      │
├─────────────────────────────┤
│ 제목*                       │
│ [_____________________]     │
│                            │
│ 카테고리*                   │
│ [▼ 선택하세요_________]     │
│                            │
│ 프롬프트 내용*              │
│ ┌─────────────────────┐    │
│ │                     │    │
│ │                     │    │
│ │                     │    │
│ └─────────────────────┘    │
│                            │
│ [저장]  [취소]             │
└─────────────────────────────┘
```

### 4.4 프롬프트 상세
```
┌─────────────────────────────┐
│ < 목록으로                  │
├─────────────────────────────┤
│ 계약서 검토 프롬프트         │
│ 당사자정보분석 | 홍길동      │
├─────────────────────────────┤
│ 아래 계약서를 분석하여       │
│ 당사자들의 권리의무를...     │
│                            │
│ 1. 계약 당사자 식별         │
│ 2. 각 당사자의 주요 의무    │
│ 3. 위험 부담 사항           │
│                            │
│ [📋 복사하기]              │
│                            │
│ [수정] [삭제] (본인만 표시) │
└─────────────────────────────┘
```

## 5. 초기 Rails 설정

### 5.1 Gemfile
```ruby
source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.0"

# The modern asset pipeline for Rails
gem "propshaft"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.5"

# Use the Puma web server
gem "puma", ">= 6.0"

# Use JavaScript with ESM import maps
gem "importmap-rails"

# Hotwire's SPA-like page accelerator
gem "turbo-rails"

# Hotwire's modest JavaScript framework
gem "stimulus-rails"

# Use Tailwind CSS
gem "tailwindcss-rails", "~> 3.0"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 5.0"

# Use Devise for authentication
gem "devise", "~> 4.9"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Use sqlite3 as the database for Active Record in development
  gem "sqlite3", "~> 2.0"
  
  # Static analysis for security vulnerabilities
  gem "brakeman", require: false

  # Omakase Ruby styling
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages
  gem "web-console"
end

group :test do
  # Use system testing
  gem "capybara"
  gem "selenium-webdriver"
end
```

### 5.2 초기 설정 커맨드
```bash
# 1. 프로젝트 생성
rails new LegalPromptHub --css=tailwind --database=postgresql

# 2. Gemfile 수정 후
bundle install

# 3. Devise 설치
rails generate devise:install
rails generate devise User
rails generate devise:views

# 4. User 모델에 name 필드 추가
rails generate migration AddNameToUsers name:string

# 5. LegalPrompt 모델 생성
rails generate model LegalPrompt title:string category:integer content:text user:references

# 6. 컨트롤러 생성
rails generate controller Dashboard index
rails generate controller LegalPrompts index show new create edit update destroy

# 7. 데이터베이스 생성 및 마이그레이션
rails db:create
rails db:migrate

# 8. 시드 데이터 추가
rails db:seed
```

### 5.3 Routes 설정 (config/routes.rb)
```ruby
Rails.application.routes.draw do
  devise_for :users
  
  authenticated :user do
    root "dashboard#index", as: :authenticated_root
  end
  
  root "legal_prompts#index"
  
  resources :legal_prompts
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions
  get "up" => "rails/health#show", as: :rails_health_check
end
```

### 5.4 Application Controller 설정
```ruby
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
```

## 6. 핵심 코드 구조

### 6.1 LegalPrompt 모델
```ruby
class LegalPrompt < ApplicationRecord
  belongs_to :user
  
  enum category: {
    party_analysis: 0,      # 당사자정보분석
    fact_organizing: 1,     # 사실관계정리
    evidence_linking: 2,    # 증거연결
    keyword_extraction: 3,  # 검색어추출
    law_extraction: 4,      # 관련법령추출
    legal_principles: 5,    # 관련법리추출
    case_search: 6          # 유사판례검색
  }
  
  validates :title, presence: true, length: { maximum: 255 }
  validates :category, presence: true
  validates :content, presence: true
  
  scope :recent, -> { order(created_at: :desc) }
  
  def category_korean
    I18n.t("legal_prompt.categories.#{category}")
  end
end
```

### 6.2 User 모델
```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :legal_prompts, dependent: :destroy
  
  validates :name, presence: true
end
```

### 6.3 JavaScript (복사 기능)
```javascript
// app/javascript/controllers/clipboard_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "button"]
  
  copy() {
    const content = this.contentTarget.innerText || this.contentTarget.value
    
    navigator.clipboard.writeText(content)
      .then(() => {
        const originalText = this.buttonTarget.innerText
        this.buttonTarget.innerText = "✓ 복사됨!"
        this.buttonTarget.classList.add("bg-green-600")
        
        setTimeout(() => {
          this.buttonTarget.innerText = originalText
          this.buttonTarget.classList.remove("bg-green-600")
        }, 2000)
      })
      .catch(err => {
        console.error('복사 실패:', err)
        alert('복사에 실패했습니다. 텍스트를 직접 선택해주세요.')
      })
  }
}
```

## 7. UI 스타일 가이드

### 7.1 Tailwind 컴포넌트 클래스
```erb
<!-- 기본 버튼 -->
<%= link_to "새 프롬프트 등록", new_legal_prompt_path, 
    class: "bg-emerald-600 text-white px-6 py-3 rounded-lg hover:bg-emerald-700 transition duration-200" %>

<!-- 보조 버튼 -->
<%= link_to "취소", legal_prompts_path, 
    class: "bg-gray-200 text-gray-700 px-4 py-2 rounded hover:bg-gray-300 transition duration-200" %>

<!-- 카드 컨테이너 -->
<div class="bg-white shadow-sm rounded-lg p-6 mb-4 hover:shadow-md transition duration-200">
  <!-- 내용 -->
</div>

<!-- 폼 입력 필드 -->
<%= form.text_field :title, 
    class: "w-full border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent" %>

<!-- 메인 컨테이너 -->
<div class="max-w-4xl mx-auto px-4 py-8">
  <!-- 내용 -->
</div>
```

### 7.2 레이아웃 구조
```erb
<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html>
  <head>
    <title>LegalPromptHub</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    <%= stylesheet_link_tag "tailwind", "inter-font", "data-turbo-track": "reload" %>
    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>

  <body class="bg-gray-50">
    <% if user_signed_in? %>
      <nav class="bg-white shadow-sm">
        <div class="max-w-4xl mx-auto px-4">
          <div class="flex justify-between items-center h-16">
            <h1 class="text-xl font-semibold text-gray-800">
              <%= link_to "LegalPromptHub", root_path %>
            </h1>
            <div class="flex items-center space-x-4">
              <span class="text-gray-600"><%= current_user.name %></span>
              <%= button_to "로그아웃", destroy_user_session_path, method: :delete, 
                  class: "text-gray-500 hover:text-gray-700" %>
            </div>
          </div>
        </div>
      </nav>
    <% end %>
    
    <main>
      <%= yield %>
    </main>
  </body>
</html>
```

## 8. 시드 데이터

```ruby
# db/seeds.rb
# 테스트 사용자 생성
user = User.create!(
  email: "test@example.com",
  password: "password123",
  name: "테스트 변호사"
)

# 샘플 프롬프트 생성
prompts = [
  {
    title: "계약서 당사자 분석 프롬프트",
    category: "party_analysis",
    content: "다음 계약서를 분석하여 당사자들의 정보를 정리해주세요:\n\n1. 각 당사자의 명칭과 역할\n2. 당사자들의 주요 권리\n3. 당사자들의 주요 의무\n4. 특별한 지위나 조건\n\n[계약서 내용을 여기에 붙여넣으세요]"
  },
  {
    title: "사실관계 시간순 정리",
    category: "fact_organizing",
    content: "다음 사실관계를 시간순으로 정리해주세요:\n\n1. 날짜별로 중요 사건 정리\n2. 각 사건의 법적 의미\n3. 인과관계 표시\n\n[사실관계를 여기에 입력하세요]"
  },
  {
    title: "판례 검색 키워드 추출",
    category: "keyword_extraction",
    content: "다음 사안에서 판례 검색에 사용할 핵심 키워드를 추출해주세요:\n\n1. 법적 쟁점 키워드 (5개)\n2. 사실관계 키워드 (5개)\n3. 검색 조합 제안\n\n[사안을 설명해주세요]"
  }
]

prompts.each do |prompt_data|
  user.legal_prompts.create!(prompt_data)
end

puts "시드 데이터 생성 완료!"
puts "테스트 계정: test@example.com / password123"
```

## 9. 배포 체크리스트

### 9.1 개발 환경 테스트
- [ ] 모든 CRUD 기능 정상 작동
- [ ] 복사 기능 브라우저별 테스트
- [ ] 모바일 반응형 확인
- [ ] 에러 처리 확인

### 9.2 프로덕션 준비
- [ ] PostgreSQL 설정
- [ ] 환경변수 설정 (SECRET_KEY_BASE 등)
- [ ] Devise 이메일 설정
- [ ] 에셋 프리컴파일

### 9.3 보안 점검
- [ ] Strong Parameters 확인
- [ ] 권한 체크 (본인 것만 수정/삭제)
- [ ] CSRF 보호 활성화
- [ ] SQL Injection 방지

## 10. 성공 기준

- [ ] 회원가입 후 1분 내에 첫 프롬프트 등록
- [ ] 모든 기능이 3번의 클릭 내에 접근 가능
- [ ] 복사 기능이 모든 브라우저에서 작동
- [ ] 모바일에서 모든 기능 정상 작동
- [ ] 에러 발생 시 명확한 안내

---

## AI 구현 요청 스크립트

```
이 기획서를 바탕으로 Rails 8 MVP를 구현해주세요.

1. Gemfile부터 시작해서 필요한 모든 파일을 생성해주세요
2. User 모델은 Devise 사용, name 필드 추가
3. LegalPrompt 모델은 category를 enum으로 구현
4. 4개 화면만 구현 (인증, 대시보드, 폼, 상세)
5. Tailwind CSS로 깔끔한 UI
6. Stimulus로 복사 기능 구현
7. 시드 데이터 포함
8. 한국어 i18n 설정 포함

모든 파일의 전체 코드를 제공해주세요.
```

---

## 다음 버전 로드맵

### Phase 2 (1개월 후)
- 검색 기능
- 카테고리 필터
- 사용 횟수 추적

### Phase 3 (3개월 후)
- 프롬프트 평가 시스템
- 즐겨찾기 기능
- 프롬프트 공유 링크

### Phase 4 (6개월 후)
- 팀 계정
- API 제공
- AI 도구 직접 연동