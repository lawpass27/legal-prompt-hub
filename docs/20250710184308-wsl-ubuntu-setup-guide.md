# WSL Ubuntu에서 LegalPromptHub 설정 가이드

## 개요
Windows WSL2의 Ubuntu 환경에서 Rails 프로젝트를 설정하고 실행하는 완전한 가이드입니다.

## WSL2 설치 및 설정

### 1. WSL2 설치 (Windows PowerShell 관리자 권한)
```powershell
# WSL 설치 (Ubuntu가 기본으로 설치됨)
wsl --install

# 설치 후 재부팅 필요
```

### 2. WSL2로 업그레이드 확인
```powershell
# WSL 버전 확인
wsl -l -v

# WSL2로 설정 (필요시)
wsl --set-default-version 2
wsl --set-version Ubuntu 2
```

## Ubuntu 환경에서 개발 환경 구축

### 1. Ubuntu 초기 설정
```bash
# Ubuntu 터미널에서 실행
# 시스템 업데이트
sudo apt update && sudo apt upgrade -y

# 필수 패키지 설치
sudo apt install -y curl git vim build-essential zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev
```

### 2. Ruby 설치 (rbenv 사용)
```bash
# rbenv 설치
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

# ruby-build 플러그인 설치
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Ruby 3.3.0 설치
rbenv install 3.3.0
rbenv global 3.3.0

# 확인
ruby -v
# => ruby 3.3.0
```

### 3. Node.js 설치 (Tailwind CSS용)
```bash
# NodeSource 저장소 추가
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

# Node.js 설치
sudo apt install -y nodejs

# 확인
node -v
npm -v
```

### 4. SQLite3 설치
```bash
# SQLite3 및 개발 헤더 설치
sudo apt install -y sqlite3 libsqlite3-dev

# 확인
sqlite3 --version
```

### 5. Rails 설치
```bash
# Bundler 설치
gem install bundler

# Rails 설치
gem install rails -v 8.0.2

# 확인
rails -v
# => Rails 8.0.2
```

## 프로젝트 설정

### 1. 프로젝트 클론
```bash
# 홈 디렉토리 또는 원하는 위치로 이동
cd ~

# 프로젝트 클론
git clone https://github.com/lawpass27/legal-prompt-hub.git
cd legal-prompt-hub
```

### 2. 프로젝트 의존성 설치
```bash
# Ruby 의존성 설치
bundle install

# JavaScript 의존성 설치 (필요시)
npm install
```

### 3. 데이터베이스 설정
```bash
# 데이터베이스 생성
rails db:create

# 마이그레이션 실행
rails db:migrate

# 시드 데이터 생성
rails db:seed
```

### 4. Tailwind CSS 빌드
```bash
# Tailwind CSS 빌드
rails tailwindcss:build

# 빌드 파일 확인
ls -la app/assets/builds/
```

## 서버 실행

### 1. Rails 서버 시작
```bash
# 개발 서버 실행
rails server -b 0.0.0.0

# 또는 백그라운드 실행
rails server -b 0.0.0.0 -d
```

### 2. Windows 브라우저에서 접속
```
http://localhost:3000
```

## VSCode 통합

### 1. VSCode에서 WSL Remote 확장 설치
- VSCode 실행
- Extensions에서 "WSL" 검색 후 설치

### 2. WSL에서 VSCode 열기
```bash
# WSL Ubuntu 터미널에서
cd ~/legal-prompt-hub
code .
```

## 일반적인 문제 해결

### 문제 1: Permission denied 에러
```bash
# 해결책: 프로젝트 소유권 변경
sudo chown -R $USER:$USER ~/legal-prompt-hub
```

### 문제 2: Bundle install 실패
```bash
# 해결책: 개발 도구 재설치
sudo apt install -y build-essential
bundle install
```

### 문제 3: JavaScript 런타임 에러
```bash
# 해결책: Node.js 재설치
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts
```

### 문제 4: 서버가 Windows에서 접근 불가
```bash
# 해결책: 0.0.0.0으로 바인딩
rails server -b 0.0.0.0
```

## 성능 최적화

### 1. WSL2 메모리 설정
Windows에서 `.wslconfig` 파일 생성:
```ini
# C:\Users\[사용자명]\.wslconfig
[wsl2]
memory=4GB
processors=2
```

### 2. 파일 시스템 성능
```bash
# 프로젝트를 WSL 파일 시스템에 위치
# 나쁨: /mnt/c/projects/legal-prompt-hub
# 좋음: ~/legal-prompt-hub
```

## 개발 워크플로우

### 1. 일일 시작 루틴
```bash
# WSL Ubuntu 터미널
cd ~/legal-prompt-hub
git pull origin main
bundle install
rails db:migrate
rails server -b 0.0.0.0
```

### 2. 새 터미널에서 Tailwind 감시
```bash
# 별도 터미널
cd ~/legal-prompt-hub
rails tailwindcss:watch
```

### 3. 테스트 실행
```bash
# 전체 테스트
rails test

# 특정 테스트
rails test test/models/legal_prompt_test.rb
```

## 유용한 별칭 설정

`.bashrc`에 추가:
```bash
# Rails 별칭
alias rs='rails server -b 0.0.0.0'
alias rc='rails console'
alias rdb='rails db:migrate'
alias tw='rails tailwindcss:watch'

# Git 별칭
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
```

## 데이터베이스 GUI 도구

### Windows에서 SQLite 브라우저 사용
1. DB Browser for SQLite 다운로드
2. WSL 파일 접근: `\\wsl$\Ubuntu\home\[사용자명]\legal-prompt-hub\db\development.sqlite3`

## 추가 팁

1. **터미널 멀티플렉서 사용**
   ```bash
   # tmux 설치
   sudo apt install tmux
   
   # 세션 시작
   tmux new -s rails
   ```

2. **자동 시작 스크립트**
   ```bash
   # ~/start-legal-prompt.sh 생성
   #!/bin/bash
   cd ~/legal-prompt-hub
   rails server -b 0.0.0.0 -d
   rails tailwindcss:watch
   ```

3. **Windows Terminal 사용**
   - Microsoft Store에서 Windows Terminal 설치
   - 더 나은 터미널 경험

## 결론

WSL2 Ubuntu 환경은 Windows에서 Rails 개발을 위한 최적의 선택입니다:
- ✅ macOS/Linux와 동일한 명령어
- ✅ 네이티브 Linux 성능
- ✅ Windows 도구와의 통합
- ✅ 안정적인 개발 환경

---
*작성일: 2025-07-10 18:43 KST*
*프로젝트: LegalPromptHub*
*환경: WSL2 Ubuntu on Windows*