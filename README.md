# SKKU DM
Service for the double marjos in SKKU(Sungkyunkwan University, South Korea).

## Intro

## Specs
|part|frameworks|
|-|-------|
|Backend|Nestjs, Prisma|
|Frontend|Flutter|
|Infra|Terraform|
|Databases|Postgresql, Redis, Firestore|

## Features
|name|description|others|
|-|-------|--|
|Bulletin Board|||
|DM|||
|Sqaure|||


## Development

### 1. Backend (Nestjs) 실행
로컬에 docker가 설치 되어있어야함
vscode 에서 devcontainer extension 설치 후 devcontainer 에서 열기

이후

```bash
$ cd apps/backend
$ pnpm start
```

### 2. Frontend (Flutter) 실행
devcontainter 에서 실행하면 안됨 (로컬에서 실행)
로컬에 안드로이드 SDK 또는 IOS 에뮬레이터, flutter SDK가 설치 되어 있어야함

로컬 터미널에서 아래 명령어를 입력하여 개발환경이 올바른지 확인 가능함

```bash
$ flutter doctor
```

프로젝트 실행

```bash
$ cd apps/frontend
$ flutter pub get

# device ID 확인
$ flutter devices

$ flutter run -d <DEVICE_ID>
```
