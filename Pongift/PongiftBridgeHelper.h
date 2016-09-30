//
//  PongiftBridgeHelper.h
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewJavascriptBridge.h"
#import <UIKit/UIKit.h>

@interface PongiftBridgeHelper : NSObject

// Custom Constructor
- (id)initWithController:(UIViewController *)controller bridge:(WebViewJavascriptBridge *)bridge andWebView:(UIWebView*)webView;

// JS -> Obj Bridge 함수 등록
- (void)setUpBridgeCallback;



@end
