//
//  PongiftBridgeHelper.m
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftBridgeHelper.h"
#import "PongiftConstants.h"
#import "PongiftContactsManager.h"
#import "PongiftPersistenceManager.h"
#import "PongiftCookieStore.h"
#import "PongiftUtils.h"

@interface PongiftBridgeHelper()

@property(strong, nonatomic) UIViewController *controller;
@property(strong, nonatomic)  WebViewJavascriptBridge *bridge;
@property(strong, nonatomic)  UIWebView *webView;
@end

@implementation PongiftBridgeHelper

NSString *selectedPhoneNum = @"";

- (id)initWithController:(UIViewController *)controller bridge:(WebViewJavascriptBridge *)bridge andWebView:(UIWebView*)webView{
    
    if (self = [super init]) {
        
        _controller = controller;
        _bridge = bridge;
        _webView = webView;
    }
    
    return self;
}

- (void)setUpBridgeCallback {
    
    // 서비스 아이디 리턴
    [_bridge registerHandler:BridgeCallbackGetServiceId handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *serviceId = [[PongiftPersistenceManager sharedInstance] serviceId];
        NSDictionary *serviceIdJson = @{kServiceId : serviceId};
        responseCallback(serviceIdJson);
    }];
    
    
    // 웹뷰 종료
    [_bridge registerHandler:BridgeCallbackCloseWebView handler:^(id data, WVJBResponseCallback responseCallback) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_controller dismissViewControllerAnimated:true completion:nil];
        });
        
        responseCallback(nil);
    }];
    
    // 웹뷰 새로고침
    [_bridge registerHandler:BridgeCallbackRefreshWebView handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (_webView != nil) {
            
            [_webView reload];
        }
        
        responseCallback(nil);
    }];
    
    // 연락처 리스트
    [_bridge registerHandler:BridgeCallbackGetContacts handler:^(id data, WVJBResponseCallback responseCallback) {
        
        PongiftContactsManager *contactsManager = [PongiftContactsManager sharedManager];
        [contactsManager fetchBirthDayContactsWithController:_controller andCompletion:^(NSDictionary *contacts) {
            
            [PongiftUtils Log:[contacts description]];
            responseCallback(contacts);
        }];
    }];
    
    
    // 연락처 UI
    [_bridge registerHandler:BridgeCallbackOpenContanctUI handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        PongiftContactsManager *contactsManager = [PongiftContactsManager sharedManager];
        
        [contactsManager openContactsWithController:_controller completion:^(CNContact *contact) {
            
            NSArray *phoneNumbers = [contact phoneNumbers];
            NSString *phoneNumberString = @"";
            
            if ([phoneNumbers count] != 0) {
                
                CNLabeledValue *phoneNumberValue = phoneNumbers[0];
                CNPhoneNumber *phoneNumber = phoneNumberValue.value;
                phoneNumberString = phoneNumber.stringValue;

            }
            
            selectedPhoneNum = phoneNumberString;
            [_bridge callHandler:BridgeCallerSetContact data:phoneNumberString responseCallback:^(id responseData) {
                
                
            }];
        }];
        
        responseCallback(nil);
    }];
    
    // 연락처 수정 UI
    [_bridge registerHandler:BridgeCallbackOpenContactUIForEditing handler:^(id data, WVJBResponseCallback responseCallback) {
        
        PongiftContactsManager *contactsManager = [PongiftContactsManager sharedManager];
        
        if (data != nil && [data isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *params = (NSDictionary*)data;
            NSString *contactId = [params objectForKey:kContactId];
            
            [contactsManager openContactsForEditingWithController:_controller.navigationController andContactId:contactId completion:^(CNContact * _Nonnull contact) {
                
                NSDateComponents *birthday = [contact birthday];
                
                if (birthday != nil) {
                    
                    NSArray *phoneNumbers = [contact phoneNumbers];
                    NSString *phoneNumberString = @"";
                    NSString *imageString = @"";
                    NSData *thumbImageData = [contact thumbnailImageData];
                    
                    if (thumbImageData != nil) {
                        
                        imageString = [thumbImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    }
                    
                    if ([phoneNumbers count] != 0) {
                        
                        CNLabeledValue *phoneNumberValue = phoneNumbers[0];
                        CNPhoneNumber *phoneNumber = phoneNumberValue.value;
                        phoneNumberString = phoneNumber.stringValue;
                        
                    }
                    
                    
                    NSString *name = [contact givenName];
                    NSInteger year = [birthday year];
                    NSInteger month = [birthday month];
                    NSInteger day = [birthday day];
                    
                    NSDictionary *json = @{kName:name,
                                           kImage:imageString,
                                           kBirthYear:[NSString stringWithFormat:@"%ld",(long)year], kBirthMonth:[NSString stringWithFormat:@"%ld",(long)month], kBirthDay:[NSString stringWithFormat:@"%ld",(long)day],
                                           kPhone:phoneNumberString,
                                           kContactId:contact.identifier};
                    
                    responseCallback(json);
                }
                else {
                    
                    responseCallback(nil);
                }
                
            }];
        }
        
        
    }];
    
    // 선택된 연락처 리턴
    [_bridge registerHandler:BridgeCallbackGetContact handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *returnJson = @{kPhone: selectedPhoneNum};
        responseCallback(returnJson);
    }];

    
    // 로그아웃
    [_bridge registerHandler:BridgeCallbackLogout handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[PongiftCookieStore sharedInstance] removeCookie];
        responseCallback(nil);
    }];
    
    // 최근검색 리스트 리턴
    [_bridge registerHandler:BridgeCallbackGetSearchHistories handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSArray *searchHistories = [[PongiftPersistenceManager sharedInstance] getSearchHistories];
        
        NSDictionary *searchHistoriesJson = @{kRows : searchHistories};
        
        responseCallback(searchHistoriesJson);
        
    }];
    
    // 최근검색어 추가
    [_bridge registerHandler:BridgeCallbackAddSearchHistory handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *params = (NSDictionary *)data;
            NSString *title = [params objectForKey:kTitle];
            NSString *date = [params objectForKey:kDate];
            
            PongiftPersistenceManager *manager = [PongiftPersistenceManager sharedInstance];
            PongiftSearchHistory *searchHistory = [[PongiftSearchHistory alloc] initWithTitle:title andDate:date];
            [manager addSearchHistory:searchHistory];
            
            NSArray *searchHistories = [manager getSearchHistories];
            NSDictionary *searchHistoriesJson = @{kRows : searchHistories};
            responseCallback(searchHistoriesJson);
            
        }
        
    }];
    
    // 최근검색어 삭제
    [_bridge registerHandler:BridgeCallbackRemoveSearchHistory handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *params = (NSDictionary *)data;
            NSString *indexParam = [params objectForKey:kIndex];
            
            NSInteger index = [indexParam integerValue];
            
            PongiftPersistenceManager *manager = [PongiftPersistenceManager sharedInstance];
            [manager removeSearchHistoryAtIndex:index];
            
            NSArray *searchHistories = [manager getSearchHistories];
            NSDictionary *searchHistoriesJson = @{kRows : searchHistories};
            responseCallback(searchHistoriesJson);
        }
    }];
    
    // 최근검색어 모두삭제
    [_bridge registerHandler:BridgeCallbackRemoveAllSearchHistory handler:^(id data, WVJBResponseCallback responseCallback) {
       
        PongiftPersistenceManager *manager = [PongiftPersistenceManager sharedInstance];
        [manager removeAllSearchHistory];
        
        NSArray *searchHistories = [manager getSearchHistories];
        NSDictionary *searchHistoriesJson = @{kRows : searchHistories};
        responseCallback(searchHistoriesJson);
        
    }];
    
    // 알림설정 조회
    [_bridge registerHandler:BridgeCallbackGetNotificationSettings handler:^(id data, WVJBResponseCallback responseCallback) {
       
        PongiftPersistenceManager *manager = [PongiftPersistenceManager sharedInstance];
        
        NSDictionary *settingsJson = [manager getNotificationSettings];
        responseCallback(settingsJson);
    }];
    
    // 기타알림 수정
    [_bridge registerHandler:BridgeCallbackUpdateEtcAlarmOnSettings handler:^(id data, WVJBResponseCallback responseCallback) {
        
       
            BOOL updatedSettings = [data boolValue];
            
            PongiftPersistenceManager *manager = [PongiftPersistenceManager sharedInstance];
            NSMutableDictionary *curSettings = [[manager getNotificationSettings] mutableCopy];
            [curSettings setValue:updatedSettings?@true:@false forKey:kEtcAlarmOn];
            
            [manager updateNotificationSettings:curSettings];
            responseCallback(curSettings);
        
    }];
    
    // 기념일알림 날짜 수정
    [_bridge registerHandler:BridgeCallbackUpdateMemorialDayAlarmSettings handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *updatedSettings = (NSDictionary*)data;
            
            PongiftPersistenceManager *manager = [PongiftPersistenceManager sharedInstance];
            NSMutableDictionary *curSettings = [[manager getNotificationSettings] mutableCopy];
            [curSettings setValue:updatedSettings forKey:kMemorialAlarm];
            
            [manager updateNotificationSettings:curSettings];
            
            responseCallback(curSettings);
            
        }
    }];
    
    // 기념일알림 수정
    [_bridge registerHandler:BridgeCallbackUpdateMemorialDayAlarmOnSettings handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
            BOOL updatedSettings = [data boolValue];
            PongiftPersistenceManager *manager = [PongiftPersistenceManager sharedInstance];
            NSMutableDictionary *curSettings = [[manager getNotificationSettings] mutableCopy];
            [curSettings setValue:updatedSettings?@true:@false forKey:kMemorialAlarmOn];
            
            [manager updateNotificationSettings:curSettings];
            
            responseCallback(curSettings);
        
    }];
}


@end
