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


@interface PongiftBridgeHelper()

@property(strong, nonatomic) UIViewController *controller;
@property(strong, nonatomic)  WebViewJavascriptBridge *bridge;
@property(strong, nonatomic)  UIWebView *webView;
@end

@implementation PongiftBridgeHelper


- (id)initWithController:(UIViewController *)controller bridge:(WebViewJavascriptBridge *)bridge andWebView:(UIWebView*)webView{
    
    if (self = [super init]) {
        
        _controller = controller;
        _bridge = bridge;
        _webView = webView;
    }
    
    return self;
}

- (void)setUpBridgeCallback {
    
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
        [contactsManager fetchBirthDayContactsWithController:_controller];
    }];
}


@end
