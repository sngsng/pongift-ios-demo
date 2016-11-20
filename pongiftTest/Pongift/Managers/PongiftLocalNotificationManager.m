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

- (id) init {
    
    if (self = [super init]) {
        
        _notiFiredHour = 16;
        _notiFiredMin = 0;
        
    }
    
    return self;
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

- (void)scheduleMemorialNotificationsWithHour:(NSInteger)hour andMin:(NSInteger)min {
    
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
                    
                    NSDateComponents *todayDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
                    [todayDateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];
                    
                    NSInteger curYear = [todayDateComponents year];
                    
                    NSInteger targetHour = hour;
                    NSInteger targetMin = min;
                    
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
                                
                                
                                if ([self isFutureDateWithMonth:month day:targetDay hour:hour min:min]) {
                                    
                                    NSDateComponents *firedDateComponents  =[[NSDateComponents alloc] init];
                                    [firedDateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];
                                    [firedDateComponents setDay:targetDay];
                                    [firedDateComponents setMonth: month];
                                    [firedDateComponents setYear: curYear];
                                    [firedDateComponents setHour:targetHour];
                                    [firedDateComponents setMinute:targetMin];
                                    
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

- (BOOL)isFutureDateWithMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour min:(NSInteger) min {
    
    NSDateComponents *todayDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    [todayDateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];
    
    NSInteger curMonth = [todayDateComponents month];
    NSInteger curDay = [todayDateComponents day];
    NSInteger curHour = [todayDateComponents hour];
    NSInteger curMin = [todayDateComponents minute];
    
    if (month >= curMonth && day >= curDay && hour >= curHour) {
        
        if (hour == curHour) return min >= curMin;
        else return YES;
    }
    else {
        
        return NO;
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
