//
//  PongiftViewController.m
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftViewController.h"
#import "WebViewJavascriptBridge.h"
#import <Contacts/Contacts.h>
#import "PongiftBridgeHelper.h"
#import "PongiftContactsManager.h"

@interface PongiftViewController () <UIWebViewDelegate, CNContactPickerDelegate>


@end

@implementation PongiftViewController

UIWebView *webView;
PongiftBridgeHelper *bridgeHelper;
//NSString *const rootUrl = @"http://pongift.com:8080";
NSString *const rootUrlDebug = @"http://192.168.0.137:8080";

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addWebView];
    [self setUpBridge];
    [self loadWebView];
    
}

- (void) loadView{
    
    CGRect applicationFrame = [[UIScreen mainScreen] bounds];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
}

#pragma mark - Private Functions

// 웹뷰 생성
- (void)addWebView {
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGRect webViewFrame = CGRectMake(0, statusBarHeight, self.view.frame.size.width, self.view.frame.size.height - statusBarHeight);
    webView = [[UIWebView alloc] initWithFrame:webViewFrame];
    webView.scrollView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:webView];
}

// 자바스크립트 브릿지 설정
- (void)setUpBridge {
    
    WebViewJavascriptBridge *bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [bridge setWebViewDelegate:self];
    bridgeHelper = [[PongiftBridgeHelper alloc] initWithController:self bridge:bridge andWebView:webView];
    [bridgeHelper setUpBridgeCallback];
}

// 웹뷰 로드
- (void)loadWebView {
    
    NSURL *url = [NSURL URLWithString:rootUrlDebug];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 기본 쿠키관리를 설정하지 않음 (수동으로 관리)
    urlRequest.HTTPShouldHandleCookies = false;
    
    //
    NSMutableDictionary *cookie = [[NSMutableDictionary alloc] init];
    [cookie setObject:@"" forKey:@"Cookie"];
    
    [urlRequest setValue:@"" forHTTPHeaderField:@"Cookie"];
    
    
    [webView loadRequest:urlRequest];
    
}


@end
