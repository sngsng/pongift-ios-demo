//
//  AppDelegate.m
//  pongiftTest
//
//  Created by 김승중 on 2016. 10. 26..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "AppDelegate.h"
#import "PongiftAgent.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    PongiftAgent *agent = [PongiftAgent sharedInstance];
    agent.debugMode = true;
    
    // 기념일 알림을 사용할 경우 (선택)
    // 기념일 알림을 사용하기위해 연락처접근과, 알림허용 권한을 요청합니다.
    [agent requestAccessPermissions];
    
    // 폰기프트 SDK를 사용하기 위한 초기 설정입니다. (필수)
    [agent setAccessKey:@"j8NtyUuoubAfGShaRQF2MA=="];
    [agent setSecretKey:@"bD3QeKX2rhUcSVlubuy2Dg=="];
    [agent initializePongiftWithCompletion:^(bool completion) {
        
    }];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    // 사용자가 연락처접근과 푸시알림에 권한에 승인해야하며 승인하지 않았을시 푸시메시지가 스케줄되지 않음
    // 사용자 휴대폰 연락처의 기념일을 로컬 알림으로 등록합니다. (선택)
    [[PongiftAgent sharedInstance] schedulePongiftMemorialDayNotifications];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    // 앱이 Foreground 상태일때 사용자 기념일 알림이 왔을시 푸시 팝업 호출. (선택)
    [[PongiftAgent sharedInstance] showPongiftMemorialPushPopUp:notification];
}


@end
