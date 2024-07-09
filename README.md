# **TerningPoint**
<br>

> 서비스 한 줄 소개
: 맞춤형 인턴 추천 및 일정 관리를 통해, 
  사회인을 향한 대학생의 마지막 터닝포인트를 함께합니다.

## **1. Member**
| 이명진<br/>([@thingineeer](https://github.com/thingineeer)) | 정민지<br/>([@wjdalswl](https://github.com/wjdalswl)) | 김민성<br/>([@mminny](https://github.com/mminny)) |
| :---: | :---: | :---: |
| <img width="540" src="https://github.com/teamterning/Terning-iOS/assets/88179341/5ce47573-b805-4be0-9b6f-ac03d9fd4163"/> | <img width="540" src="https://github.com/teamterning/Terning-iOS/assets/88179341/ed6c378e-f17d-4dd6-8081-8b69da816d51"/> | <img width="540" src="https://github.com/teamterning/Terning-iOS/assets/88179341/f6420a14-2ca9-4463-a075-e0594e50e107"/> |
<br>

## [2. Project Design](https://www.figma.com/board/h597MCTAjj8PawsF1nbHMC/iOS-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EC%84%A4%EA%B3%84?node-id=0-1&t=elsfeNTTSrKMhUfx-1)
<img width="941" alt="image" src="https://github.com/teamterning/Terning-iOS/assets/88179341/8e4c42ce-4bef-4c02-87b8-b7adfb5ced1f">


## **3. Commit Message Rule**

`[prefix] #이슈번호 - 이슈 내용`

```
[Prefix]

[Add]: 기능과 무관한 코드 추가 (라이브러리 추가, 유틸리티 함수 추가 등)
[Chore]: 그 이외의 잡일/ 버전 코드 수정, 패키지 구조 변경, 파일 이동, 파일이름 변경
[Comment]: 필요한 주석 추가 및 변경
[Del]: 쓸모없는 코드, 주석 삭제
[Design]: 뷰 구현 (UI 관련 코드 추가 및 수정)
[Docs]: README나 WIKI 등의 문서 개정
[Feat]: 새로운 기능 구현
[Fix]: 버그, 오류 해결, 코드 수정
[Merge]: 머지
[Refactor]: 전면 수정이 있을 때 사용합니다
[Remove]: 파일 삭제
[Setting]: 프로젝트 세팅 및 전반적 기능
[Test]: 테스트 코드
```
> ex) [Feat] #5 - 서버 연결 구현

---

## **4. Code Convention**

[터닝 코드 컨벤션](https://abundant-quiver-13f.notion.site/Code-Convention-a0949dcd93184be4be1f6456c48ab80c)

---

## **5. Code Review Rule**

코드 리뷰를 최대한 빨리 달고 반영하자!

---

## **6. Issue Naming Rule**

`[Prefix] - 이슈내용`

> ex) [Feat] - TerningPoint 홈 화면 구현

---

## **7. PR Naming Rule**

`[Prefix] #이슈번호- 작업내용`

> ex) [Feat] #1 - TerningPoint 홈 화면 구현

---

## **8. Git Flow**

1. 이슈 생성
2. 브랜치 생성
3. 브랜치 add, commit, push → PR 과정 거치기
4. 최소 1명 "Approve" 있어야 merge (강제 머지 금지 )
5. 머지후 ( 해당 브랜치 바로 제거 )
6. pull 받아서 다음 이슈 진행

---

## **9.Git**

충돌 안나게 같은 파일 최대한 작업하지 않기

---

## 10. **Development Environment and Using Library**

- Development Environment
<p align="left">
<img src ="https://img.shields.io/badge/Swift-5.9-orange?logo=swift">
<img src ="https://img.shields.io/badge/Xcode-15.0-blue?logo=xcode">
<img src ="https://img.shields.io/badge/iOS-17.0-green.svg">

<br>
<br>

- 📚 Library

라이브러리 | 사용 목적 | Version | Management Tool
:---------:|:----------:|:---------: |:---------:
 Moya | 서버 통신 | 15.0.3 | SPM
 SnapKit | UI Layout | 5.7.1 | SPM
 Then | UI 선언 | 3.0.0 | SPM
 Kingfisher | 이미지 처리 | 7.10.1| SPM
 RxSwift | 비동기 처리 | 6.7.1| SPM
 
 <br>

 - 🧱 framework

프레임워크 | 사용 이유 
:---------:|:----------:
 UIKit | UI 구현

<br>

---

## 11. **Foldering**

```
├── 📂 Terning-iOS
│   ├── 📂 Application
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Info.plist
│   ├── 📂 Network
│   ├── 📂 Resource
│   │   ├── Assets.xcassets
│   │   ├── 📂 Constants
│   │   ├── 📂 Extension
│   │   ├── 📂 Fonts
│   │   └── 📂 Utils
│   └── 📂 Source
│       ├── 📂 Data
│       └── 📂 Presentation

```
