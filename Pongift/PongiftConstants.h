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

/** 브릿지 JS -> Obj Call 함수명 **/


// 연락처 리스트 리턴
extern NSString *const BridgeCallbackGetContacts;

// 연락처 선택 뷰 열기
extern NSString *const BridgeCallbackOpenContanctUI;

// 서비스 아이디 리턴
extern NSString *const BridgeCallbackGetServiceId;

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


/** 브릿지 ObjC -> JS **/

// 연락처 UI에서 선택된 연락처 리턴
extern NSString *const BridgeCallerGetContact;

@end
