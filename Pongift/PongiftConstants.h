//
//  PongiftConstants.h
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PongiftConstants : NSObject

// 브릿지 JS -> Obj Call 함수명

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

// 브릿지 ObjC -> JS

@end
