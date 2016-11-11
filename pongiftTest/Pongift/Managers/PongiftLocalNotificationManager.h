//
//  PongiftLocalNotificationManager.h
//  PongiftSDK
//
//  Created by 김승중 on 2016. 10. 26..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PongiftLocalNotificationManager : NSObject

+ (PongiftLocalNotificationManager* _Nonnull)sharedInstance;


@property (assign, nonatomic) NSInteger notiFiredHour;
@property (assign, nonatomic) NSInteger notiFiredMin;

- (void)scheduleMemorialNotificationsWithHour:(NSInteger)hour andMin:(NSInteger)min;
- (void)cancelScheduledMemorialNotifications;
- (void)registerLocalNotificationSettings;
- (BOOL)isLocalNotificationEnabled;
@end
