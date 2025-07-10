# Tailwind CSS 적용 문제 해결 과정

## 문제 상황
Rails 8.0.2 프로젝트에서 Tailwind CSS가 적용되지 않는 문제가 발생했습니다.

### 증상
- `bin/rails server` 실행 시 다음 에러 발생:
  ```
  Specified input file ./app/assets/stylesheets/application.tailwind.css does not exist.
  ```
- 서버가 시작되지 않음
- Tailwind 스타일이 전혀 적용되지 않음

## 원인 분석

### 1차 원인: 누락된 입력 파일
- `tailwindcss-rails` gem이 기본적으로 `application.tailwind.css` 파일을 찾으나 해당 파일이 없었음
- Rails 8의 새로운 구조와 Tailwind v4의 호환성 문제

### 2차 원인: Tailwind 버전 호환성
- 초기 설치된 `tailwindcss-rails ~> 3.0`이 Tailwind CSS v4를 사용
- Tailwind v4는 Rails와의 통합에서 아직 안정적이지 않음

## 해결 과정

### 1단계: 누락된 파일 생성
```css
/* app/assets/stylesheets/application.tailwind.css */
@tailwind base;
@tailwind components;
@tailwind utilities;
```

### 2단계: Tailwind 버전 다운그레이드
1. Gemfile 수정:
   ```ruby
   # 변경 전
   gem "tailwindcss-rails", "~> 3.0"
   
   # 변경 후
   gem "tailwindcss-rails", "~> 2.7"
   ```

2. 번들 업데이트:
   ```bash
   bundle update tailwindcss-rails
   ```

3. Tailwind 재설치:
   ```bash
   rails tailwindcss:install
   ```

### 3단계: 설정 파일 단순화
`config/tailwind.config.js`를 다음과 같이 수정:
```javascript
module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*'
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

### 4단계: 빌드 프로세스 재시작
```bash
# Tailwind CSS 재빌드
rails tailwindcss:build

# 서버 재시작
bin/rails server
```

## 핵심 해결책 요약

1. **파일 존재 확인**: `application.tailwind.css` 파일이 반드시 존재해야 함
2. **버전 호환성**: Rails 8과 안정적으로 작동하는 Tailwind v2.7 사용
3. **간단한 설정**: 복잡한 설정보다는 기본 설정으로 시작
4. **순차적 접근**: 한 번에 모든 것을 해결하려 하지 말고 단계별로 접근

## 교훈

### DO
- ✅ 에러 메시지를 정확히 읽고 누락된 파일부터 확인
- ✅ 안정적인 버전 조합 사용 (Rails 8 + Tailwind 2.7)
- ✅ 빌드 프로세스 재시작 시 캐시 고려

### DON'T
- ❌ 최신 버전이 항상 좋다고 가정하지 말 것
- ❌ 복잡한 설정부터 시도하지 말 것
- ❌ 에러 해결 시 여러 변경사항을 동시에 적용하지 말 것

## 참고 명령어

```bash
# Tailwind 빌드 상태 확인
rails tailwindcss:build

# 빌드 파일 직접 확인
ls -la app/assets/builds/

# Tailwind 프로세스 확인
ps aux | grep tailwind

# 강제 재빌드
rails tailwindcss:build --force
```

## 관련 리소스
- [tailwindcss-rails GitHub](https://github.com/rails/tailwindcss-rails)
- [Rails 8 Asset Pipeline 문서](https://guides.rubyonrails.org/asset_pipeline.html)
- [Tailwind CSS v2 문서](https://v2.tailwindcss.com/)

---
*작성일: 2025-07-10*
*프로젝트: LegalPromptHub*
*Rails 버전: 8.0.2*
*해결된 Tailwind 버전: 2.7*