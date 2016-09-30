//
//  PongiftContactsManager.m
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftContactsManager.h"
#import "PongiftUtils.h"

@implementation PongiftContactsManager

CNContactStore *contactStore;

+ (id)sharedManager {
    static PongiftContactsManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (id)init {
    
    if (self = [super init]) {
        
        contactStore = [[CNContactStore alloc] init];
        
        
    }
    
    return self;
}

// 연락처 리스트
- (void)fetchBirthDayContactsWithController:(UIViewController *)controller {
    
    [self requestForContactsAccessWithCompletion:^(BOOL accessGranted) {
        
        if (accessGranted) {
            
            NSArray *keys = @[CNContactGivenNameKey,CNContactThumbnailImageDataKey,CNContactPhoneNumbersKey,CNContactDatesKey,CNContactBirthdayKey];
            CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
            NSError *error;
            [contactStore enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                
                NSString *name = [contact givenName];
                NSData *thumnail = [contact thumbnailImageData];
                NSArray *phoneNumbers = [contact phoneNumbers];
                NSDateComponents *birthday = [contact birthday];
                NSArray *dates = [contact dates];
                
                NSLog(@"이름 : %@, 이미지: %@, 휴대폰번호 :%@, 생일 : %@ ", [contact givenName], [contact thumbnailImageData], [contact phoneNumbers], [contact birthday]);
            }];
        }
        
    } andController:controller];
}

// 연락처 권한 요청
- (void)requestForContactsAccessWithCompletion:(void(^)(BOOL accessGranted))completion andController:(UIViewController *) controller {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    switch (authorizationStatus) {
            
        case CNAuthorizationStatusAuthorized:
            completion(YES);
            break;
            
        case CNAuthorizationStatusDenied:
            [self showAlertWhenAuthorizationDeniedWithController:controller];
            completion(NO);
            break;
            
        case CNAuthorizationStatusNotDetermined: {
            
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                if (granted) {
                    
                    completion(YES);
                }
                else {
                    
                    // 사용자가 거부를 눌렀을경우 팝업
                    [self showAlertWhenAuthorizationDeniedWithController:controller];
                    completion(NO);
                    
                }
            }];
            completion(NO);
            break;
        }
        default:
            completion(NO);
            break;
    }
}

// 권한 거부시 팝업
- (void)showAlertWhenAuthorizationDeniedWithController:(UIViewController*) controller {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [PongiftUtils showAlertWithMsg:@"기념일 관리 기능을 연락처 접근을 허용하셔야 이용하실수 있습니다." controller:controller shouldAddSecondButton:YES okActionTitle:@"설정" andOkAction:^{
            
            NSURL *settingsAppUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsAppUrl];
            
        }];
    });
}


@end
