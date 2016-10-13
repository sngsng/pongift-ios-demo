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
#import "PongiftConstants.h"
#import "PongiftCookieStore.h"
#import "PongiftUtils.h"

@interface PongiftViewController () <UIWebViewDelegate, CNContactPickerDelegate>


@end

@implementation PongiftViewController

UIWebView *webView;
PongiftBridgeHelper *bridgeHelper;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self scheduleLocalNotification];
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

- (void)scheduleLocalNotification {
    
    UIUserNotificationType notificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound);
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
    [[PongiftContactsManager sharedManager] fetchBirthDayContactsWithController:self andCompletion:^(NSDictionary *contacts) {
       
        NSDateComponents *todayDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        
        NSInteger curYear = [todayDateComponents year];
        NSInteger curMonth = [todayDateComponents month];
        NSInteger curDay = [todayDateComponents day];
        
        for (int i = 1; i <= 12; i++) {
            
            NSArray *targetBirthMonth = [contacts objectForKey:[NSString stringWithFormat:@"%d",i]];
            
            for (int j = 0; j < targetBirthMonth.count; j++) {
                
                NSDictionary *birthDay = targetBirthMonth[j];
                
                NSString *targetName = [birthDay objectForKey:kName];
                NSInteger targetMonth = [[birthDay objectForKey:kBirthMonth] integerValue];
                NSInteger targetDay = [[birthDay objectForKey:kBirthDay] integerValue];
                
                if (targetMonth >= curMonth && targetDay >= curDay) {
                    
                    NSDateComponents *firedDateComponents  =[[NSDateComponents alloc] init];
                    [firedDateComponents setDay:targetDay];
                    [firedDateComponents setMonth: targetMonth];
                    [firedDateComponents setYear: curYear];
                    [firedDateComponents setHour:15];
                    [firedDateComponents setMinute:j];
                    
                    NSCalendar *calendar = [[ NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                    NSDate *dateOfBirth = [calendar dateFromComponents:firedDateComponents];
                    
                    UILocalNotification *localNoti = [self makeLocationNotificationWithName:targetName andFireDate:dateOfBirth];
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
                    
                }
            }
        }
    }];
}


- (UILocalNotification *)makeLocationNotificationWithName:(NSString*)name andFireDate:(NSDate*)date{
    
    UILocalNotification *localNoti = [[UILocalNotification alloc] init];
    localNoti.alertBody = [NSString stringWithFormat:LocalNotiTitleFormat, name];
    localNoti.fireDate = date;
    
    return localNoti;
}

#pragma mark - UIWebView delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [PongiftUtils showAlertWithMsg:[error localizedDescription] controller:self];
}


@end
