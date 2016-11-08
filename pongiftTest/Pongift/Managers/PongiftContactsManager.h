//
//  PongiftContactsManager.h
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <UIKit/UIKit.h>

@interface PongiftContactsManager : NSObject

+ (PongiftContactsManager* _Nonnull)sharedManager;
- (void)fetchBirthDayContactsWithController:(UIViewController * _Nullable)controller andCompletion:(void(^_Nonnull)(NSDictionary* _Nonnull contacts))completion;
- (void)openContactsWithController:(UIViewController * _Nullable) controller completion:(void(^_Nonnull)(CNContact* _Nonnull contact))pickerCompletion;
- (void)openContactsForEditingWithController:(UINavigationController * _Nonnull)navController andContactId:(NSString * _Nonnull)contactId completion:(void(^ _Nonnull)(CNContact* _Nonnull contact))editCompletion;
- (BOOL)isContactAccessAuthorized;
- (void)requestForContactsAccessWithCompletion:(void(^_Nonnull)(BOOL accessGranted))completion;

@end
