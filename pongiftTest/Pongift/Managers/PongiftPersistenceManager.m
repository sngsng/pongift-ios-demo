//
//  PongiftPersistenceManager.m
//  Pongift
//
//  Created by 김승중 on 2016. 10. 9..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftPersistenceManager.h"
#import "PongiftConstants.h"
#import "PongiftLocalNotificationManager.h"


@implementation PongiftPersistenceManager

NSString *searchHistoryFile = @"pongiftSearchHistories.out";
NSString *settingsFile = @"pongiftNotificationSettings.out";

+ (PongiftPersistenceManager* _Nonnull)sharedInstance {
    
    static PongiftPersistenceManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}

#pragma mark - Public Functions

- (void)addSearchHistory:(PongiftSearchHistory* _Nonnull) searchHistory {
    
    NSMutableArray *willUpdateHistories = [[NSMutableArray alloc] init];
    
    if ([self fileExistsWithFileName:searchHistoryFile]) {
        
        NSArray * searchHistories = [self getSearchHistories];
        willUpdateHistories = [searchHistories mutableCopy];
        [willUpdateHistories insertObject:searchHistory.getJson atIndex:0];
        
    }
    else {
        
        [willUpdateHistories insertObject:searchHistory.getJson atIndex:0];
    }
    
    [NSKeyedArchiver archiveRootObject:willUpdateHistories toFile:[self filePathFromFileName:searchHistoryFile]];
}

- (void)removeSearchHistoryAtIndex:(NSInteger)index {
    
    NSMutableArray *willUpdateHistories = [[NSMutableArray alloc] init];
    
    if ([self fileExistsWithFileName:searchHistoryFile]) {
        
        willUpdateHistories = [[self getSearchHistories] mutableCopy];
        
        if (willUpdateHistories.count > index) {
            
            [willUpdateHistories removeObjectAtIndex:index];
            [NSKeyedArchiver archiveRootObject:willUpdateHistories toFile:[self filePathFromFileName:searchHistoryFile]];
            
        }
    }
}

- (void)removeAllSearchHistory {
    
    NSMutableArray *emptyList = [[NSMutableArray alloc] init];
    if ([self fileExistsWithFileName:searchHistoryFile]) {
        
        [NSKeyedArchiver archiveRootObject:emptyList toFile:[self filePathFromFileName:searchHistoryFile]];
    }
}

- (NSArray * _Nonnull)getSearchHistories {
    
    NSMutableArray *returnHistories = [[NSMutableArray alloc] init];
    
    if ([self fileExistsWithFileName:searchHistoryFile]) {
        
        NSData *data = [NSData dataWithContentsOfFile:[self filePathFromFileName:searchHistoryFile]];
        NSArray *histories = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if (histories != nil) {
            
            returnHistories = [histories mutableCopy];
        }
    }
    
    return returnHistories;
}

- (NSDictionary * _Nonnull)getNotificationSettings {
    
    NSDictionary *settingsJson = @{kEtcAlarmOn:@true,
                                   kMemorialAlarmOn:@true,
                                   kMemorialAlarm:@{
                                           kToday:@true,
                                           kOne:@false,
                                           kTwo:@false,
                                           kThree:@false}
                                   };
    
    if ([self fileExistsWithFileName:settingsFile]) {
        
        NSData *data = [NSData dataWithContentsOfFile:[self filePathFromFileName:settingsFile]];
        NSDictionary *settingsFile = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if (settingsFile != nil) {
            
            settingsJson = settingsFile;
        }
    }
    else {
        
        [NSKeyedArchiver archiveRootObject:settingsJson toFile:[self filePathFromFileName:settingsFile]];
    }
    
    return settingsJson;
    
}

- (void)updateNotificationSettings:(NSDictionary* _Nonnull)updatedSettings {
    
    [NSKeyedArchiver archiveRootObject:updatedSettings toFile:[self filePathFromFileName:settingsFile]];
    
    BOOL memorialAlarmOn = [[updatedSettings objectForKey:kMemorialAlarmOn] boolValue];
    
    if (memorialAlarmOn) {
        
        PongiftLocalNotificationManager *notiManager = [PongiftLocalNotificationManager sharedInstance];
        
        [notiManager cancelScheduledMemorialNotifications];
        [notiManager scheduleMemorialNotificationsWithHour:[notiManager notiFiredHour] andMin:[notiManager notiFiredMin]];
    }
    else {
        
        [[PongiftLocalNotificationManager sharedInstance] cancelScheduledMemorialNotifications];
    }
}

- (NSInteger)getNotificationFiredDayOffset {
    
    NSDictionary *notificationSettings = [self getNotificationSettings];
    
    NSDictionary *offsetDictionary = [notificationSettings objectForKey:kMemorialAlarm];
    
    BOOL offsetToday = [[offsetDictionary objectForKey:kToday] boolValue];
    BOOL offsetOne = [[offsetDictionary objectForKey:kOne] boolValue];
    BOOL offsetTwo = [[offsetDictionary objectForKey:kTwo] boolValue];
    BOOL offsetThree = [[offsetDictionary objectForKey:kThree] boolValue];
    
    if (offsetToday) return 0;
    else if (offsetOne) return 1;
    else if (offsetTwo) return 2;
    else if (offsetThree) return 3;
    else return 0;
}

#pragma mark - Private Functions

- (NSString * _Nonnull)filePathFromFileName:(NSString *)name {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *historyFilePath = [paths[0] stringByAppendingPathComponent:name];
    
    return historyFilePath;
}

- (BOOL)fileExistsWithFileName:(NSString*)fileName {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self filePathFromFileName:fileName]]) {
        
        return true;
    }
    else {
        
        return false;
    }
}


@end
