//
//  AmplitudeEventType.swift
//  Terning-iOS
//
//  Created by 이명진 on 10/17/24.
//

import Foundation

public enum AmplitudeEventType: String {
    // 회원가입 이벤트
    case signupKakao = "signup_kakao" // 회원가입_카카오 로그인
    case signupApple = "signup_apple" // 회원가입_Apple 로그인
    
    // 스플래쉬 이벤트
    case clickStartService = "click_start_service" // 스플래쉬_서비스 시작하기
    case clickOnboardingCompleted = "click_onboarding_completed" // 온보딩 완료 스플래쉬_맞춤공고 보러가기
    
    // 홈 화면 이벤트
    case clickFiltering = "click_filtering" // 홈_필터링
    case scrollHome = "scroll_home" // 홈_리스트 하단까지 스크롤한 횟수
    case clickFilteredDeadline = "click_filtered_deadline" // 홈_정렬_채용 마감 이른 순
    case clickFilteredShortTerm = "click_filtered_short_term" // 홈_정렬_짧은 근무 기간 순
    case clickFilteredLongTerm = "click_filtered_long_term" // 홈_정렬_긴 근무 기간 순
    case clickFilteredScraps = "click_filtered_scraps" // 홈_정렬_스크랩 많은 순
    case clickFilteredHits = "click_filtered_hits" // 홈_정렬_조회수 많은 순
    case clickInternCard = "click_intern_card" // 홈_공고 카드 클릭
    case clickScrap = "click_scrap" // 홈_스크랩
    case clickRemindInternCard = "click_remind_intern_card" // 홈_곧 마감되는 관심 공고 클릭
    case clickFilteringSave = "click_filtering_save" // 홈_필터링 재설정_저장하기
    case screenHomeDuration = "screen_home_duration" // 홈_화면 체류 시간
    case clickCheckSchedule = "click_check_schedule" // 홈_관심공고_공고마감일정 확인하기
    
    // 캘린더 이벤트
    case clickCalendarList = "click_calendar_list" // 캘린더_리스트뷰 전환하기
    case screenCalendarDuration = "screen_calendar_duration" // 캘린더_체류시간
    
    // 공고 상세페이지 이벤트
    case clickDetailScrap = "click_detail_scrap" // 공고상세페이지_스크랩아이콘
    case clickDetailActiveScrap = "click_detail_active_scrap" // 공고상세페이지_활성화된 스크랩 아이콘_스크랩취소하기
    case clickDetailUrl = "click_detail_url" // 공고상세페이지_지원사이트로이동하기
    
    // 스크랩 이벤트
    case clickScrapCalender = "click_scrap_calender" // 스크랩_내 캘린더에 스크랩하기
    case clickScrapColor = "click_scrap_color" // 스크랩_색상 변경하기
    case clickScarpInformation = "click_scarp_information" // 스크랩_공고상세정보보기
    
    // 탐색 이벤트
    case clickBanner = "click_bannner" // 탐색_각 배너 누르기
    case clickSearch = "click_search" // 탐색_검색창 누르기
    
    // 마이페이지 이벤트
    case clickNotice = "click_notice" // 마이페이지_공지사항 누르기
    case clickComment = "click_comment" // 마이페이지_의견보내기 누르기
    case clickModifyProfile = "click_modify_profile" // 마이페이지_프로필 수정하기
    case clickLogout = "click_logout" // 마이페이지_로그아웃
    case clickDeleteAccount = "click_delete_account" // 마이페이지_탈퇴하기
    
    // 탭바
    case clickNavigationCalendar = "click_navigation_calendar" // 탭바_캘린더
    case clickNavigationSearch = "click_navigation_search" // 탭바_탐색
    case clickNavigationMyPage = "click_navigation_mypage" // 탭바_마이페이지
    case clickNavigationHome = "click_navigation_home" // 탭바_홈
}
