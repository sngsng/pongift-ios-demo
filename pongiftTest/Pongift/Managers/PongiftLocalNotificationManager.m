//
//  PongiftLocalNotificationManager.m
//  PongiftSDK
//
//  Created by 김승중 on 2016. 10. 26..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftLocalNotificationManager.h"
#import "PongiftPersistenceManager.h"
#import "PongiftConstants.h"
#import "PongiftUtils.h"
#import "PongiftContactsManager.h"

@implementation PongiftLocalNotificationManager

+ (PongiftLocalNotificationManager* _Nonnull)sharedInstance {
    
    static PongiftLocalNotificationManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)registerLocalNotificationSettings {
    
    UIUserNotificationType notificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound);
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

- (BOOL)isLocalNotificationEnabled {
    
    BOOL isNotificationEnabled = YES;
    UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    if (grantedSettings.types == UIUserNotificationTypeNone) {
        
        isNotificationEnabled = NO;
    }
    
    return isNotificationEnabled;
}

- (void)scheduleMemorialNotifications {
    
    // 로컬 푸시 알림 허용
    if ([self isLocalNotificationEnabled]) {
        
        PongiftPersistenceManager *persistenceManager = [PongiftPersistenceManager sharedInstance];
        
        NSDictionary *alarmSettings = [persistenceManager getNotificationSettings];
        BOOL isMemorialAlarmOn = [[alarmSettings objectForKey:kMemorialAlarmOn] boolValue];
        
        // 설정에 기념일 알림이 ON
        if (isMemorialAlarmOn) {
            
            // 연락처 접근권한이 허용되어야 함
            if ([[PongiftContactsManager sharedManager] isContactAccessAuthorized]) {
                
                [[PongiftContactsManager sharedManager] fetchBirthDayContactsWithController:nil andCompletion:^(NSDictionary *contacts) {
                    
                    [PongiftUtils Log:@"contacts : %@", contacts];
                    
                    NSDateComponents *todayDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
                    [todayDateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];
                    
                    NSInteger curYear = [todayDateComponents year];
                    NSInteger curMonth = [todayDateComponents month];
                    NSInteger curDay = [todayDateComponents day];
                    
                    for (int i = 1; i <= 12; i++) {
                        
                        int month = i;
                        NSArray *targetBirthMonthList = [contacts objectForKey:[NSString stringWithFormat:@"%d",i]];
                        NSArray *groupedList = [PongiftUtils groupBirthDaysFromTargetMonthBirthDayList:targetBirthMonthList];
                        
                    
                        for (int j = 0; j < groupedList.count; j++) {
                            
                            NSArray *birthDays = groupedList[j];
                            
                            if (birthDays.count > 0) {
                                
                                NSDictionary *birthDay = birthDays[0];
                                NSInteger dateOffset = [persistenceManager getNotificationFiredDayOffset];
                                NSInteger targetDay = [[birthDay objectForKey:kBirthDay] integerValue] - dateOffset;
                                
                                if (month >= curMonth && targetDay >= curDay) {
                                    
                                    NSDateComponents *firedDateComponents  =[[NSDateComponents alloc] init];
                                    [firedDateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];
                                    [firedDateComponents setDay:targetDay];
                                    [firedDateComponents setMonth: month];
                                    [firedDateComponents setYear: curYear];
                                    [firedDateComponents setHour:15];
                                    [firedDateComponents setMinute:j];
                                    
                                    [PongiftUtils Log:@"firedDate : %@", firedDateComponents];
                                    
                                    NSCalendar *calendar = [[ NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                                    NSDate *dateOfBirth = [calendar dateFromComponents:firedDateComponents];
                                    
                                    UILocalNotification *localNoti = [self makeLocationNotificationWithFireDate:dateOfBirth andBirthDays:birthDays];
                                    
                                    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
                                }
                            }
                            
                            
                        }
                        
                    }
                }];
                
            }
            else {
                
                [self cancelScheduledMemorialNotifications];
            }

            }
            
    }
}

- (UILocalNotification *)makeLocationNotificationWithFireDate:(NSDate*)date andBirthDays:(NSArray *) birthDays{
    
    UILocalNotification *localNoti = [[UILocalNotification alloc] init];
    localNoti.alertBody = [PongiftUtils memorialLocalNotificationMsgFromBirthDays:birthDays];
    localNoti.category = kLocalNotificationCategory;
    localNoti.userInfo = @{kBirthDaysNotificationInfo:birthDays};
    localNoti.fireDate = date;
    
    return localNoti;
}

- (void)cancelScheduledMemorialNotifications {
    
    NSArray<UILocalNotification*> *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    if (scheduledNotifications != nil) {
        
        for (int i = 0; i < scheduledNotifications.count; i++) {
            
            UILocalNotification *scheduledNotification = scheduledNotifications[i];
            
            if ([scheduledNotification category] != nil) {
                
                if ([[scheduledNotification category] isEqualToString:kLocalNotificationCategory]) {
                    
                    [[UIApplication sharedApplication] cancelLocalNotification:scheduledNotification];
                }
            }
            
        }
    }
}

@end
