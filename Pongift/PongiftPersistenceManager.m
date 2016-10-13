//
//  PongiftPersistenceManager.m
//  Pongift
//
//  Created by 김승중 on 2016. 10. 9..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftPersistenceManager.h"
#import "PongiftConstants.h"


@implementation PongiftPersistenceManager

NSString *searchHistoryFile = @"pongiftSearchHistories.out";
NSString *settingsFile = @"pongiftNotificationSettings.out";

+ (id _Nonnull)sharedInstance {
    
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
    
    NSLog(@"Removed Index : %ld",(long)index);
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
}

- (NSInteger)getNotificationFiredDayOffset {
    
    NSDictionary *notificationSettings = [self getNotificationSettings];
    
    NSDictionary *offsetDictionary = [notificationSettings objectForKey:kMemorialAlarm];
    
    BOOL offsetToday = [offsetDictionary objectForKey:kToday];
    BOOL offsetOne = [offsetDictionary objectForKey:kOne];
    BOOL offsetTwo = [offsetDictionary objectForKey:kTwo];
    BOOL offsetThree = [offsetDictionary objectForKey:kThree];
    
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
    NSString *historyFilePath = [paths[0] stringByAppendingString:name];
    
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
