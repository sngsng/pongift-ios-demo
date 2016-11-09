//
//  PongiftContactsManager.m
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftContactsManager.h"
#import "PongiftUtils.h"
#import "PongiftConstants.h"
#import "PongiftViewController.h"

@interface PongiftContactsManager()<CNContactPickerDelegate, CNContactViewControllerDelegate>

@end

@implementation PongiftContactsManager

CNContactStore *contactStore;
void (^contactPickerCompletion)(CNContact* contact);
void (^contactEditCompletion)(CNContact* contact);

+ (PongiftContactsManager*)sharedManager {
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
- (void) fetchBirthDayContactsWithController:(UIViewController * _Nullable)controller andCompletion:(void(^)(NSDictionary* contacts))completion {
    
    NSMutableArray *january = [[NSMutableArray alloc] init];
    NSMutableArray *february = [[NSMutableArray alloc] init];
    NSMutableArray *march = [[NSMutableArray alloc] init];
    NSMutableArray *april = [[NSMutableArray alloc] init];
    NSMutableArray *may = [[NSMutableArray alloc] init];
    NSMutableArray *june = [[NSMutableArray alloc] init];
    NSMutableArray *july = [[NSMutableArray alloc] init];
    NSMutableArray *august = [[NSMutableArray alloc] init];
    NSMutableArray *september = [[NSMutableArray alloc] init];
    NSMutableArray *october = [[NSMutableArray alloc] init];
    NSMutableArray *november = [[NSMutableArray alloc] init];
    NSMutableArray *december = [[NSMutableArray alloc] init];
    
    [self requestForContactsAccessWithCompletion:^(BOOL accessGranted) {
        
        if (accessGranted) {
            
            NSArray *keys = @[CNContactGivenNameKey,CNContactThumbnailImageDataKey,CNContactPhoneNumbersKey,CNContactDatesKey,CNContactBirthdayKey];
            CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
            NSError *error;
            
            
            
            [contactStore enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                
                NSDateComponents *birthday = [contact birthday];
            
                if (birthday != nil) {
                    
                    NSArray *phoneNumbers = [contact phoneNumbers];
                    NSString *phoneNumberString = @"";
                    NSString *imageString = @"";
                    NSData *thumbImageData = [contact thumbnailImageData];
                    
                    if (thumbImageData != nil) {
                        
                        imageString = [thumbImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                    }
                    
                    if ([phoneNumbers count] != 0) {
                        
                        CNLabeledValue *phoneNumberValue = phoneNumbers[0];
                        CNPhoneNumber *phoneNumber = phoneNumberValue.value;
                        phoneNumberString = phoneNumber.stringValue;
                        
                    }
                    
                    
                    NSString *name = [contact givenName];
                    NSInteger year = [birthday year];
                    NSInteger month = [birthday month];
                    NSInteger day = [birthday day];
                    
                    NSDictionary *json = @{kName:name,
                                           kImage:imageString,
                                           kBirthYear:[NSString stringWithFormat:@"%ld",(long)year], kBirthMonth:[NSString stringWithFormat:@"%ld",(long)month], kBirthDay:[NSString stringWithFormat:@"%ld",(long)day],
                                           kPhone:phoneNumberString,
                                           kContactId:contact.identifier};
                    
                    switch (month) {
                        case 1:
                            [january addObject:json];
                            break;
                        case 2:
                            [february addObject:json];
                            break;
                        case 3:
                            [march addObject:json];
                            break;
                        case 4:
                            [april addObject:json];
                            break;
                        case 5:
                            [may addObject:json];
                            break;
                        case 6:
                            [june addObject:json];
                            break;
                        case 7:
                            [july addObject:json];
                            break;
                        case 8:
                            [august addObject:json];
                            break;
                        case 9:
                            [september addObject:json];
                            break;
                        case 10:
                            [october addObject:json];
                            break;
                        case 11:
                            [november addObject:json];
                            break;
                        case 12:
                            [december addObject:json];
                            break;
                            
                        default:
                            break;
                    }
                }
            }];
            
            NSComparisonResult (^comparator)(NSDictionary* first, NSDictionary* second) = ^NSComparisonResult(NSDictionary* first, NSDictionary* second) {
                
                
                NSNumber *dayFirst = [NSNumber numberWithInteger:[[first objectForKey:kBirthDay] integerValue]];
                NSNumber *daySecond = [NSNumber numberWithInteger:[[second objectForKey:kBirthDay] integerValue]];
                
                return [dayFirst compare:daySecond];
            };
            
            if (january.count > 0) {
                
                [january sortUsingComparator:comparator];
            }
            if (february.count > 0) {
                
                [february sortUsingComparator:comparator];
            }
            if (march.count > 0) {
                
                [march sortUsingComparator:comparator];
            }
            if (april.count > 0) {
                
                [april sortUsingComparator:comparator];
            }
            if (may.count > 0) {
                
                [may sortUsingComparator:comparator];
            }
            if (june.count > 0) {
                
                [june sortUsingComparator:comparator];
            }
            if (july.count > 0) {
                
                [july sortUsingComparator:comparator];
            }
            if (august.count > 0) {
                
                [august sortUsingComparator:comparator];
            }
            if (september.count > 0) {
                
                [september sortUsingComparator:comparator];
            }
            if (october.count > 0) {
                
                [october sortUsingComparator:comparator];
            }
            if (november.count > 0) {
                
                [november sortUsingComparator:comparator];
            }
            if (december.count > 0) {
                
                [december sortUsingComparator:comparator];
            }
            
            NSDictionary *returnJson = @{
                                         @"1":january,
                                         @"2":february,
                                         @"3":march,
                                         @"4":april,
                                         @"5":may,
                                         @"6":june,
                                         @"7":july,
                                         @"8":august,
                                         @"9":september,
                                         @"10":october,
                                         @"11":november,
                                         @"12":december
                                         };

            
            completion(returnJson);
            
            
        }
        else {
            
            
        }
        
    } andController:controller];
}

// 권한 상태 리턴
- (BOOL)isContactAccessAuthorized {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if (authorizationStatus == CNAuthorizationStatusAuthorized) return YES;
    else return NO;
}

// 연락처 UI
- (void)openContactsWithController:(UIViewController *) controller completion:(void(^)(CNContact* contact))pickerCompletion {
    
    
    [self requestForContactsAccessWithCompletion:^(BOOL accessGranted) {
        
        if (accessGranted) {
            
            CNContactPickerViewController *contactPickerViewController = [[CNContactPickerViewController alloc] init];
            contactPickerViewController.delegate = self;
            
            contactPickerCompletion = pickerCompletion;
            [controller presentViewController:contactPickerViewController animated:true completion:nil];
        }
    } andController:controller];
    
    
    
}

// 연락처 수정 UI
- (void)openContactsForEditingWithController:(UINavigationController *)navController andContactId:(NSString *)contactId completion:(void(^)(CNContact* contact))editCompletion{
    
    NSArray *keys = @[[CNContactViewController descriptorForRequiredKeys]];
    
    
    CNContact *contact = [contactStore unifiedContactWithIdentifier:contactId keysToFetch:keys error:nil];
//    CNContact *contact = [contactStore unifiedContactWithIdentifier:@"49C77766-4C50-4A10-B826-B2A7C485D15D" keysToFetch:keys error:nil];
    
    if (contact != nil) {
        
        CNContactViewController *contactViewController = [CNContactViewController viewControllerForContact:contact];
        contactViewController.delegate = self;
        contactViewController.allowsEditing = YES;
        contactViewController.allowsActions = YES;
        
        contactEditCompletion = editCompletion;
        
        [navController pushViewController:contactViewController animated:true];
    }
    
}

- (void)requestForContactsAccessWithCompletion:(void(^)(BOOL accessGranted))completion {
    
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    
    switch (authorizationStatus) {
            
        case CNAuthorizationStatusAuthorized:
            completion(YES);
            break;
            
        case CNAuthorizationStatusDenied:

            completion(NO);
            break;
            
        case CNAuthorizationStatusNotDetermined: {
            
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                if (granted) {
                    
                    completion(YES);
                }
                else {
                    
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

// 연락처 권한 요청
- (void)requestForContactsAccessWithCompletion:(void(^)(BOOL accessGranted))completion andController:(UIViewController * _Nullable) controller {
    
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
                    if (controller != nil) [self showAlertWhenAuthorizationDeniedWithController:controller];
                    
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
        
        [PongiftUtils showAlertWithMsg:@"기념일 관리는 연락처 접근을 허용하셔야 이용하실수 있습니다." controller:controller shouldAddSecondButton:YES okActionTitle:@"설정" andOkAction:^{
            
            NSURL *settingsAppUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsAppUrl];
            
        }];
    });
}

#pragma mark - ContactPickerViewDelegate

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    
    if (contactPickerCompletion != nil) {
    
        contactPickerCompletion(nil);
        contactPickerCompletion = nil;
    }
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    
    if (contactPickerCompletion != nil) {
        
        contactPickerCompletion(contact);
        contactPickerCompletion = nil;
    }
}

#pragma mark - ContactViewControllerDelegate

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact {
    
    if (viewController.navigationController != nil) {
        
        if (contactEditCompletion != nil) {
            
            contactEditCompletion(contact);
        }
        
        [viewController.navigationController popViewControllerAnimated:true];
    }
}


@end
