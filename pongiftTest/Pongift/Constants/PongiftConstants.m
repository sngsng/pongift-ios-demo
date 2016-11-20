//
//  PongiftConstants.m
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftConstants.h"

@implementation PongiftConstants

NSString *const RootUrl = @"http://pongift.com:8080";
NSString *const BirthDayDeepLinkUrl = @"http://pongift.com:8080/theme?themeId=1&phone=";
//NSString *const RootUrl = @"http://192.168.0.138:8080";
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
NSString *const kContactId = @"id";

NSString *const kEtcAlarmOn = @"etcAlarmOn";
NSString *const kMemorialAlarmOn = @"memorialDayAlarmOn";
NSString *const kMemorialAlarm = @"memorialDayAlarm";
NSString *const kOne = @"one";
NSString *const kTwo = @"two";
NSString *const kThree = @"three";
NSString *const kToday = @"today";
NSString *const kBirthDaysNotificationInfo = @"birthDayUserInfo";

NSString *const LocalNotiOffsetTodaySingleTargetMsg = @"오늘은 %@님의 생일입니다.";
NSString *const LocalNotiOffsetTodayMultiTargetMsg = @"오늘은 %@님 외 %d명이 생일입니다.";
NSString *const LocalNotiOffsetPreviousDaySingleTargetMsg = @"%d일 후 %@님의 생일입니다.";
NSString *const LocalNotiOffsetPreviousDayMultiTargetMsg = @"%d일 후 %@님외 %d명이 생일입니다.";
NSString *const LocalNotiHeaderBirthDayTodayAlarm = @"생일알림";
NSString *const LocalNotiHeaderBirthDayPreviousDayAlarm = @"생일미리알림";
NSString *const LocalNotiHeaderDDayTitleFormat = @"D-%d";
NSString *const LocalNotiBirthDayFormat = @"%02d월 %02d일";
NSString *const LocalNotiTodayBirthDayPostfix = @"님의 생일입니다.";
NSString *const LocalNotiPreviousBirthDayPrefix = @"%d일 뒤";
NSString *const LocalNotiTommorowBirthDayPrefix = @"내일은";
NSString *const BirthDayDateFormat = @"MM월 dd일";
NSString *const WeekDayDateFormat = @"EEEE";

NSString *const BridgeCallbackGetContacts = @"getContacts";
NSString *const BridgeCallbackOpenContanctUI = @"openContactsUI";
NSString *const BridgeCallbackOpenContactUIForEditing = @"openContactsEditUI";
NSString *const BridgeCallbackGetServiceId = @"getServiceId";
NSString *const BridgeCallbackGetContact = @"getContact";
NSString *const BridgeCallbackCloseWebView = @"closeWebView";
NSString *const BridgeCallbackRefreshWebView = @"refreshWebView";
NSString *const BridgeCallbackLogout = @"logout";
NSString *const BridgeCallbackGetSearchHistories = @"getSearchHistories";
NSString *const BridgeCallbackAddSearchHistory = @"addSearchHistory";
NSString *const BridgeCallbackRemoveSearchHistory = @"removeSearchHistory";
NSString *const BridgeCallbackRemoveAllSearchHistory = @"removeAllSearchHistory";
NSString *const BridgeCallbackGetNotificationSettings = @"getNotificationSettings";


NSString *const BridgeCallbackUpdateEtcAlarmOnSettings = @"updateEtcAlarmOnSettings";
NSString *const BridgeCallbackUpdateMemorialDayAlarmSettings = @"updateMemorialDayAlarmSettings";
NSString *const BridgeCallbackUpdateMemorialDayAlarmOnSettings = @"updateMemorialDayAlarmOnSettings";

NSString *const kLocalNotificationCategory = @"PongiftLocalNotification";

NSString *const BridgeCallerSetContact = @"setContact";

@end
