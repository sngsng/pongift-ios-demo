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

+(id)sharedInstance;
- (void)initializePongiftWithSecretKey:(NSString*)secretKey andAccessKey:(NSString*)accessKey completion:(void(^)(bool completion)) completion;
- (void)openPongiftViewController:(UIViewController*)controller;
@end
