//
//  PongiftConstants.m
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftConstants.h"

@implementation PongiftConstants

//NSString *const RootUrl = @"http://pongift.com:8080";
NSString *const RootUrl = @"http://192.168.168.163:8080";
NSString *const SerivceInitializeUrl = @"/api/pongift/sdk-initial?";
NSString *const ServiceInitializeQuerySecretKey = @"secretKey=";
NSString *const ServiceInitializeQueryAccessKey = @"accessKey=";
NSString *const kServiceIntializeResponseId = @"id";
NSString *const kRows = @"rows";
NSString *const kTitle = @"title";
NSString *const kDate = @"date";
NSString *const kIndex = @"index";
NSString *const kServiceId = @"serviceId";

NSString *const kName = @"name";
NSString *const kImage = @"image";
NSString *const kPhone = @"phone";
NSString *const kBirthYear = @"year";
NSString *const kBirthMonth = @"month";
NSString *const kBirthDay = @"day";

NSString *const BridgeCallbackGetContacts = @"getContacts";
NSString *const BridgeCallbackOpenContanctUI = @"openContactsUI";
NSString *const BridgeCallbackGetServiceId = @"getServiceId";
NSString *const BridgeCallbackCloseWebView = @"closeWebView";
NSString *const BridgeCallbackRefreshWebView = @"refreshWebView";
NSString *const BridgeCallbackLogout = @"logout";

NSString *const BridgeCallbackGetSearchHistories = @"getSearchHistories";
NSString *const BridgeCallbackAddSearchHistory = @"addSearchHistory";
NSString *const BridgeCallbackRemoveSearchHistory = @"removeSearchHistory";
NSString *const BridgeCallbackRemoveAllSearchHistory = @"removeAllSearchHistory";

NSString *const BridgeCallerGetContact = @"getContact";

@end
