//
//  PongiftUtils.h
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PongiftUtils : NSObject

+ (void)showAlertWithMsg:(NSString* _Nonnull)msg controller:(UIViewController* _Nonnull)controller shouldAddSecondButton:(BOOL)shouldAddSeconButton okActionTitle:(NSString* _Nullable)okActionTitle andOkAction:(void(^ _Nullable)())okCompletion;
+ (void)showAlertWithMsg:(NSString* _Nonnull)msg controller:(UIViewController* _Nonnull) controller;
+ (NSArray * _Nonnull)groupBirthDaysFromTargetMonthBirthDayList:(NSArray<NSDictionary*> * _Nonnull)targetMonthBirthDayList;
+ (UIViewController * _Nullable)topViewControllerFromRootViewController:(UIViewController* _Nullable) rootVC;
+ (NSString *_Nonnull)memorialLocalNotificationMsgFromBirthDays:(NSArray* _Nonnull)birthdays;

+ (NSBundle *_Nonnull)frameworkBundle;
+(void) Log:(NSString*) format, ...;
@end
