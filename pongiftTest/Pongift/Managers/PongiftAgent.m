//
//  PongiftAgent.m
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftAgent.h"
#import "PongiftRestService.h"
#import "PongiftConstants.h"
#import "PongiftViewController.h"
#import "PongiftPersistenceManager.h"
#import "PongiftContactsManager.h"
#import "PongiftLocalNotificationManager.h"
#import "PongiftUtils.h"
#import "PongiftMemorialPushPopUpViewController.h"

@implementation PongiftAgent

+(PongiftAgent*)sharedInstance {
    
    static PongiftAgent *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
    
}

-(id) init {
    
    if (self = [super init]) {
        
        _localNotificationEnabled = YES;
        _contactAccessEnabled = YES;
    }
    
    return self;
}

- (void)requestAccessPermissions {
    
    if (_localNotificationEnabled) {
        
        [[PongiftLocalNotificationManager sharedInstance] registerLocalNotificationSettings];
    }
    
    if (_contactAccessEnabled) {
        
        [[PongiftContactsManager sharedManager] requestForContactsAccessWithCompletion:^(BOOL accessGranted) {
            
        }];
    }
    
}

- (void)schedulePongiftMemorialDayNotifications {
    
    PongiftLocalNotificationManager *notificationManager = [PongiftLocalNotificationManager sharedInstance];
    PongiftContactsManager *contactsManager = [PongiftContactsManager sharedManager];
    
    BOOL isLocalNotificationOn = [notificationManager isLocalNotificationEnabled];
    BOOL isContactsAccessOn = [contactsManager isContactAccessAuthorized];
    
    if (isLocalNotificationOn && isContactsAccessOn) {
        
        [notificationManager cancelScheduledMemorialNotifications];
        [notificationManager scheduleMemorialNotificationsWithHour:[notificationManager notiFiredHour] andMin:[notificationManager notiFiredMin]];
    }
    else {
        
        [PongiftUtils Log:@"사용자가 푸시허용과 연락처 접근을 허용해야 로컬푸시 등록이 가능합니다."];
    }
}


- (void)initializePongiftWithCompletion:(void(^)(bool completion)) completion {
    
    if (_secretKey != nil && _accessKey != nil) {
        
        [self requestSecretKey:_secretKey andAccessKey:_accessKey completion:completion];
    }
    else {
        
        NSLog(@"Error: accessKey, secretKey nil");
        completion(NO);
    }
    
    
}

- (void)openPongiftViewController:(UIViewController*)controller {
    
    if ([[PongiftPersistenceManager sharedInstance] serviceId] != nil) {
        
        [self initializePongiftWithCompletion:^(bool completion) {
           
            if (completion) {
                
                PongiftViewController *pongiftVC = [[PongiftViewController alloc] init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pongiftVC];
                
                [controller presentViewController:navigationController animated:true completion:nil];
            }
            else {
                
                NSLog(@"Error: Invalid accessKey, secretKey");
            }
        }];
        
        
    }
    else {
        
        
        [PongiftUtils showAlertWithMsg:@"Invalid AccessKey, SecretKey" controller:controller];
    }
}

- (void)requestSecretKey:(NSString*)secretKey andAccessKey:(NSString*)accessKey completion:(void(^)(bool compeltion)) completion{
    
    PongiftRestService *restService = [[PongiftRestService alloc] init];
    
    NSString *subUrl = SerivceInitializeUrl;
    
    NSString *secretQuery = [[ServiceInitializeQuerySecretKey stringByAppendingString:secretKey] stringByAppendingString:@"&"];
    NSString *accessQuery = [ServiceInitializeQueryAccessKey stringByAppendingString:accessKey];
    
    subUrl = [[subUrl stringByAppendingString:secretQuery] stringByAppendingString:accessQuery];

    [restService request:GET subUrl:subUrl params:nil progressBlock:^{
        
    } successBlock:^(id _Nullable response) {
        
        if ([response isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *resDict = (NSDictionary *)response;
            
            NSString *serviceId = [[resDict objectForKey:kServiceIntializeResponseId] stringValue];
            
            if (serviceId != nil) {
                
                [[PongiftPersistenceManager sharedInstance] setServiceId:serviceId];
            }
            
        }
        completion(true);
        
    } failBlock:^(NSError * _Nonnull error) {
        
        [PongiftUtils Log:[error localizedDescription]];
        completion(false);
        
    } errorBlock:^(NSError * _Nonnull error) {
        
        [PongiftUtils Log:[error localizedDescription]];
        completion(false);
    }];
}

- (void)showPongiftMemorialPushPopUp:(UILocalNotification*)push {
    
//    if (push.category!= nil && [push.category isEqualToString:kLocalNotificationCategory]) {
    
    
        PongiftMemorialPushPopUpViewController *pushPopUpVC = [[PongiftMemorialPushPopUpViewController alloc] initWithNibName:@"PongiftMemorialPushPopUpViewController" bundle:[PongiftUtils frameworkBundle]];
        [pushPopUpVC setModalPresentationStyle:UIModalPresentationOverFullScreen];
        pushPopUpVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        pushPopUpVC.notification = push;
        
        UIViewController *rootVC = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        UIViewController *topVC = [PongiftUtils topViewControllerFromRootViewController:rootVC];
        
        if (topVC != nil) [topVC presentViewController:pushPopUpVC animated:true completion:nil];
        
//    }
}
@end
