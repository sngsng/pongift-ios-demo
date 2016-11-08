//
//  PongiftUtils.m
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftAgent.h"
#import "PongiftUtils.h"
#import "PongiftConstants.h"
#import "PongiftPersistenceManager.h"


@implementation PongiftUtils


// 연락처 권한이 거부되었을 경우 Alert
+ (void)showAlertWithMsg:(NSString*)msg controller:(UIViewController*)controller shouldAddSecondButton:(BOOL)shouldAddSeconButton okActionTitle:(NSString*)okActionTitle andOkAction:(void(^)())okCompletion  {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction;
    
    
    
    if (okActionTitle != nil) {
        
        okAction = [UIAlertAction actionWithTitle:okActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (okCompletion != nil) {
                
                okCompletion();
            }
        }];
    }
    else {
        
        okAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (okCompletion != nil) {
                
                okCompletion();
            }
            
        }];
    }
    
    [alert addAction:okAction];
    
    if (shouldAddSeconButton) {
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"닫기" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
    }
    
    
    [controller presentViewController:alert animated:true completion:nil];
}

+ (void)showAlertWithMsg:(NSString*)msg controller:(UIViewController*) controller {
    
    [self showAlertWithMsg:msg controller:controller shouldAddSecondButton:false okActionTitle:nil andOkAction:nil];
}

+ (NSString *)memorialLocalNotificationMsgFromBirthDays:(NSArray*)birthdays {
    
    NSString *msg = @"";
    
    NSInteger alarmOffset = [[PongiftPersistenceManager sharedInstance] getNotificationFiredDayOffset];
    NSString *prefixTargetName = [birthdays[0] objectForKey:kName];
    
    // 생일이 한명 알림 메시지
    if (birthdays.count == 1) {
        
        // 알림설정이 당일
        if (alarmOffset == 0) {
            
            msg = [NSString stringWithFormat:LocalNotiOffsetTodaySingleTargetMsg, prefixTargetName];
        }
        // 알림설정이 offset 일 전
        else {
            
            msg = [NSString stringWithFormat:LocalNotiOffsetPreviousDaySingleTargetMsg, alarmOffset, prefixTargetName];
        }
        
    }
    // 같은생일 여러명 알림 메시지
    else {
        
        if (alarmOffset == 0) {
            
            msg = [NSString stringWithFormat:LocalNotiOffsetTodayMultiTargetMsg, prefixTargetName, birthdays.count - 1];
        }
        else {
            msg = [NSString stringWithFormat:LocalNotiOffsetPreviousDayMultiTargetMsg, alarmOffset, prefixTargetName, birthdays.count - 1];
        }
        
    }
    
    return msg;
    
}

+ (NSArray *)groupBirthDaysFromTargetMonthBirthDayList:(NSArray<NSDictionary*> *)targetMonthBirthDayList {
    
    NSMutableArray *groupedBirthDayList = [[NSMutableArray alloc] init];
    NSInteger tempDay = -1;
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    // 생일이 하나 일경우 리턴
    if (targetMonthBirthDayList.count == 1) {
        
        [tempArray addObject:targetMonthBirthDayList[0]];
        [groupedBirthDayList addObject:tempArray];
        
        [PongiftUtils Log:@"grouped : %@", groupedBirthDayList];
        return groupedBirthDayList;
        
    }
    
    for (int i = 0; i < targetMonthBirthDayList.count; i++) {
        
        NSDictionary *targetMonthBirthDay = targetMonthBirthDayList[i];
        NSInteger day = [[targetMonthBirthDay objectForKey:kBirthDay] integerValue];
        
        
        if (day == tempDay) {
            
            [tempArray addObject:targetMonthBirthDay];
            
            // 모두다 동일한 생일일 경우 마지막에 더함
            if (i == targetMonthBirthDayList.count - 1) {
                
                [groupedBirthDayList addObject:[tempArray copy]];
            }
        }
        // 이전 생일과 다를 경우 첫번쨰와 마지막만 예외처리
        else {
            
            if (i == 0 || i == targetMonthBirthDayList.count - 1) {
                
                if (i == 0) {
                    
                    [tempArray addObject:targetMonthBirthDay];
                }
                else {
                    
                    [groupedBirthDayList addObject:[tempArray copy]];
                    [tempArray removeAllObjects];
                    [tempArray addObject:targetMonthBirthDay];
                    [groupedBirthDayList addObject:[tempArray copy]];
                }
            }
            else {
                
                [groupedBirthDayList addObject:[tempArray copy]];
                [tempArray removeAllObjects];
                [tempArray addObject:targetMonthBirthDay];
            }
        }
        
        tempDay = day;
        
    }
    
    [PongiftUtils Log:@"grouped : %@", groupedBirthDayList];
    
    return groupedBirthDayList;
}

+ (UIViewController * _Nullable)topViewControllerFromRootViewController:(UIViewController* _Nullable) rootVC {
    
    if (rootVC != nil) {
        
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController *navVC = (UINavigationController*) rootVC;
            return [self topViewControllerFromRootViewController:navVC.visibleViewController];
        }
        
        if ([rootVC isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tabVC = (UITabBarController*) rootVC;
            
            UINavigationController *moreVC = tabVC.moreNavigationController;
            
            if (moreVC != nil && moreVC.topViewController != nil) {
                
                if (moreVC.topViewController.view.window != nil) {
                    
                    return [self topViewControllerFromRootViewController:moreVC.topViewController];
                }
            }
            else if (tabVC.selectedViewController != nil) {
                
                return [self topViewControllerFromRootViewController:tabVC.selectedViewController];
            }
            
        }
        
        if (rootVC.presentedViewController != nil) {
            
            return [self topViewControllerFromRootViewController:rootVC.presentedViewController];
        }
    }
    
    return rootVC;
    
}


+ (NSBundle *_Nonnull)frameworkBundle {
    
    return [NSBundle bundleWithIdentifier:@"com.platfos.pongiftSDK"];
    
}

+(void) Log:(NSString*) format, ... {
    
#if DEBUG
    
    if ([PongiftAgent sharedInstance].debugMode) {
        
        static NSDateFormatter* timeStampFormat;
        if (!timeStampFormat) {
            timeStampFormat = [[NSDateFormatter alloc] init];
            [timeStampFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            [timeStampFormat setTimeZone:[NSTimeZone systemTimeZone]];
        }
        
        NSString* timestamp = [timeStampFormat stringFromDate:[NSDate date]];
        
        va_list vargs;
        va_start(vargs, format);
        NSString* formattedMessage = [[NSString alloc] initWithFormat:format arguments:vargs];
        va_end(vargs);
        
        NSString* message = [NSString stringWithFormat:@"<%@> %@", timestamp, formattedMessage];
        
        printf("%s\n", [message UTF8String]);
    }
    
#endif
}
@end
