//
//  PongiftAgent.h
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PongiftAgent : NSObject

@property (assign, nonatomic) BOOL localNotificationEnabled;
@property (assign, nonatomic) BOOL contactAccessEnabled;
@property (assign, nonatomic) BOOL debugMode;
@property (strong, nonatomic) NSString *accessKey;
@property (strong, nonatomic) NSString *secretKey;
@property (strong, nonatomic) NSString *appUrlScheme;

+(PongiftAgent*)sharedInstance;
- (void)initializePongiftWithCompletion:(void(^)(bool completion)) completion;
- (void)openPongiftViewController:(UIViewController*)controller;
- (void)requestAccessPermissions;
- (void)schedulePongiftMemorialDayNotifications;
- (void)showPongiftMemorialPushPopUp:(UILocalNotification*)push;
@end
