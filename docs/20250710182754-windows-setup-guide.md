# Windows 환경에서 LegalPromptHub 실행 가이드

## 개요
이 문서는 macOS에서 개발된 Rails 프로젝트를 Windows 환경에서 실행하기 위한 가이드입니다.

## 필요한 소프트웨어

### 1. Ruby 설치
- **Ruby+Devkit** 다운로드: https://rubyinstaller.org/
- 버전: Ruby 3.3.0 이상
- 설치 시 MSYS2 development toolchain 포함 설치 (중요!)

### 2. SQLite3 설치
Windows에서 SQLite3가 종종 문제를 일으킵니다:
```powershell
# PowerShell 관리자 권한으로 실행
gem uninstall sqlite3
gem install sqlite3 --platform=ruby
```

### 3. Node.js 설치
- https://nodejs.org/ 에서 LTS 버전 다운로드
- Tailwind CSS 빌드에 필요

## 프로젝트 설정

### 1. 프로젝트 클론
```powershell
git clone https://github.com/lawpass27/legal-prompt-hub.git
cd legal-prompt-hub
```

### 2. 의존성 설치
```powershell
# Ruby 의존성
bundle install

# 만약 에러 발생 시:
bundle update
```

### 3. 데이터베이스 설정
```powershell
rails db:create
rails db:migrate
rails db:seed
```

### 4. Tailwind CSS 빌드
```powershell
rails tailwindcss:build
```

## 일반적인 문제 해결

### 문제 1: sqlite3 gem 설치 실패
```powershell
# 해결책:
ridk exec pacman -S mingw-w64-x86_64-sqlite3
gem install sqlite3 --platform=ruby -- --with-sqlite3-dir=C:/msys64/mingw64
```

### 문제 2: Tailwind CSS 빌드 실패
```powershell
# 해결책:
npm install -g tailwindcss
rails tailwindcss:install
```

### 문제 3: 파일 권한 문제
Windows의 파일 권한은 Unix와 다르므로:
```powershell
# Git 설정 변경
git config core.filemode false
```

### 문제 4: 줄바꿈 문자 문제 (CRLF vs LF)
```powershell
# Git 설정
git config --global core.autocrlf true
```

## Windows 전용 Gemfile 수정 (필요시)

`Gemfile`에 플랫폼별 gem 지정:
```ruby
# Windows 전용
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'wdm', '>= 0.1.0' if Gem.win_platform?
```

## 서버 실행
```powershell
rails server

# 또는 명시적 포트 지정
rails server -p 3000
```

## WSL2 사용 (권장)

Windows에서 가장 안정적인 Rails 개발 환경은 WSL2입니다:

1. **WSL2 설치**
   ```powershell
   wsl --install
   ```

2. **Ubuntu 설치 후**
   ```bash
   # WSL2 Ubuntu 내에서
   sudo apt update
   sudo apt install ruby-full ruby-bundler git nodejs npm
   
   # 프로젝트 클론 및 실행
   git clone https://github.com/lawpass27/legal-prompt-hub.git
   cd legal-prompt-hub
   bundle install
   rails db:setup
   rails server
   ```

## 추가 팁

1. **Visual Studio Code 사용 시**
   - WSL Remote 확장 설치
   - Ruby 확장 설치
   - Rails 확장 설치

2. **성능 최적화**
   - Windows Defender에서 프로젝트 폴더 제외
   - 가능하면 SSD에 프로젝트 위치

3. **데이터베이스 대안**
   - PostgreSQL for Windows 사용 고려
   - 프로덕션과 동일한 환경 구성

## 결론

대부분의 경우 Rails 프로젝트는 Windows에서도 잘 작동하지만, 최상의 개발 경험을 위해서는:
1. WSL2 사용 권장
2. 네이티브 Windows보다는 Linux 환경 에뮬레이션 선호
3. 초기 설정에 시간 투자 필요

---
*작성일: 2025-07-10 18:27 KST*
*프로젝트: LegalPromptHub*