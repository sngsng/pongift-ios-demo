//
//  PongiftConstants.h
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PongiftConstants : NSObject

/** Network **/
extern NSString *const RootUrl;
extern NSString *const BirthDayDeepLinkUrl;
extern NSString *const SerivceInitializeUrl;
extern NSString *const ServiceInitializeQuerySecretKey;
extern NSString *const ServiceInitializeQueryAccessKey;
extern NSString *const kServiceIntializeResponseId;
extern NSString *const kRows;
extern NSString *const kTitle;
extern NSString *const kDate;
extern NSString *const kIndex;
extern NSString *const kServiceId;

extern NSString *const kName;
extern NSString *const kImage;
extern NSString *const kPhone;
extern NSString *const kBirthYear;
extern NSString *const kBirthMonth;
extern NSString *const kBirthDay;
extern NSString *const kContactId;

extern NSString *const kEtcAlarmOn;
extern NSString *const kMemorialAlarmOn;
extern NSString *const kMemorialAlarm;
extern NSString *const kOne;
extern NSString *const kTwo;
extern NSString *const kThree;
extern NSString *const kToday;
extern NSString *const kBirthDaysNotificationInfo;

/** Messages **/
extern NSString *const LocalNotiOffsetTodaySingleTargetMsg;
extern NSString *const LocalNotiOffsetTodayMultiTargetMsg;
extern NSString *const LocalNotiOffsetPreviousDaySingleTargetMsg;
extern NSString *const LocalNotiOffsetPreviousDayMultiTargetMsg;
extern NSString *const LocalNotiHeaderBirthDayTodayAlarm;
extern NSString *const LocalNotiHeaderBirthDayPreviousDayAlarm;
extern NSString *const LocalNotiHeaderDDayTitleFormat;
extern NSString *const LocalNotiBirthDayFormat;
extern NSString *const LocalNotiTodayBirthDayPostfix;
extern NSString *const LocalNotiPreviousBirthDayPrefix;
extern NSString *const LocalNotiTommorowBirthDayPrefix;
extern NSString *const BirthDayDateFormat;
extern NSString *const WeekDayDateFormat;

/** 브릿지 JS -> Obj Call 함수명 **/

// 연락처 리스트 리턴
extern NSString *const BridgeCallbackGetContacts;

// 연락처 선택 뷰 열기
extern NSString *const BridgeCallbackOpenContanctUI;

// 연락처 수정 뷰 열기
extern NSString *const BridgeCallbackOpenContactUIForEditing;

// 서비스 아이디 리턴
extern NSString *const BridgeCallbackGetServiceId;

// 선택된 연락처 리턴
extern NSString *const BridgeCallbackGetContact;

// 웹뷰 닫기
extern NSString *const BridgeCallbackCloseWebView;

// 웹뷰 새로고침
extern NSString *const BridgeCallbackRefreshWebView;

// 로그아웃
extern NSString *const BridgeCallbackLogout;

// 최근검색 리스트 리턴
extern NSString *const BridgeCallbackGetSearchHistories;

// 최근검색어 추가
extern NSString *const BridgeCallbackAddSearchHistory;

// 최근검색어 삭제
extern NSString *const BridgeCallbackRemoveSearchHistory;

// 최근검색어 모두삭제
extern NSString *const BridgeCallbackRemoveAllSearchHistory;

// 알림설정 조회
extern NSString *const BridgeCallbackGetNotificationSettings;

// 알림설정 수정
extern NSString *const BridgeCallbackUpdateEtcAlarmOnSettings;
extern NSString *const BridgeCallbackUpdateMemorialDayAlarmSettings;
extern NSString *const BridgeCallbackUpdateMemorialDayAlarmOnSettings;

// 로컬 노티피케이션 카테고리
extern NSString *const kLocalNotificationCategory;


/** 브릿지 ObjC -> JS **/

// 연락처 UI에서 선택된 연락처 세팅 완료알림
extern NSString *const BridgeCallerSetContact;

@end
