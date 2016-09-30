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

+ (void)showAlertWithMsg:(NSString*)msg controller:(UIViewController*)controller shouldAddSecondButton:(BOOL)shouldAddSeconButton okActionTitle:(NSString*)okActionTitle andOkAction:(void(^)())okCompletion;
+ (void)showAlertWithMsg:(NSString*)msg controller:(UIViewController*) controller;
@end
