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
#import "PongiftPersistenceManager.h"
#import "PongiftConstants.h"
#import "PongiftCookieStore.h"
#import "PongiftUtils.h"
#import "PongiftLocalNotificationManager.h"

@interface PongiftViewController () <UIWebViewDelegate, CNContactPickerDelegate>


@end

@implementation PongiftViewController

UIWebView *webView;
PongiftBridgeHelper *bridgeHelper;

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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.navigationController != nil) {
        
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (self.navigationController != nil) {
        
        self.navigationController.navigationBarHidden = NO;
    }
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
    
    NSURL *url = [NSURL URLWithString:RootUrl];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // 기본 쿠키관리를 설정하지 않음 (수동으로 관리)
    urlRequest.HTTPShouldHandleCookies = false;
    
    NSString *cookie = [[PongiftCookieStore sharedInstance] getCookie];
    
    if (cookie != nil) {
        
        [urlRequest setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    [webView loadRequest:urlRequest];
    
}

#pragma mark - UIWebView delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [PongiftUtils showAlertWithMsg:[error localizedDescription] controller:self shouldAddSecondButton:NO okActionTitle:@"확인" andOkAction:^{
        
        [self dismissViewControllerAnimated:true completion:nil];
    }];
}


@end
