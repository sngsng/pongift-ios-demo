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

- (void)scheduleMemorialNotifications;
- (void)cancelScheduledMemorialNotifications;
- (void)registerLocalNotificationSettings;
- (BOOL)isLocalNotificationEnabled;
@end
