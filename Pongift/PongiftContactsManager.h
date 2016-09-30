//
//  PongiftContactsManager.h
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import <UIKit/UIKit.h>

@interface PongiftContactsManager : NSObject

+ (id)sharedManager;
- (void)fetchBirthDayContactsWithController:(UIViewController *)controller;

@end
