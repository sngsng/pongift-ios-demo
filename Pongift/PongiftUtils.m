//
//  PongiftUtils.m
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftUtils.h"


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
@end
