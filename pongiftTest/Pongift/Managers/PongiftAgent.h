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

+(PongiftAgent*)sharedInstance;
- (void)initializePongiftWithSecretKey:(NSString*)secretKey andAccessKey:(NSString*)accessKey completion:(void(^)(bool completion)) completion;
- (void)openPongiftViewController:(UIViewController*)controller;
- (void)requestAccessPermissions;
- (void)schedulePongiftMemorialDayNotifications;
- (void)showPongiftMemorialPushPopUp:(UILocalNotification*)push;
@end
