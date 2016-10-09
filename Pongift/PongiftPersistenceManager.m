//
//  PongiftPersistenceManager.m
//  Pongift
//
//  Created by 김승중 on 2016. 10. 9..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftPersistenceManager.h"


@implementation PongiftPersistenceManager

NSString *filePath = @"searchHistories.out";

+ (id _Nonnull)sharedInstance {
    
    static PongiftPersistenceManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)addSearchHistory:(PongiftSearchHistory* _Nonnull) searchHistory {
    
    NSMutableArray *willUpdateHistories = [[NSMutableArray alloc] init];
    
    if ([self historyExists]) {
        
        NSArray * searchHistories = [self getSearchHistories];
        willUpdateHistories = [searchHistories mutableCopy];
        [willUpdateHistories insertObject:searchHistory.getJson atIndex:0];
        
    }
    else {
        
        [willUpdateHistories insertObject:searchHistory.getJson atIndex:0];
    }
    
    [NSKeyedArchiver archiveRootObject:willUpdateHistories toFile:[self historyFilePath]];
}

- (void)removeSearchHistoryAtIndex:(NSInteger)index {
    
    NSLog(@"Removed Index : %ld",(long)index);
    NSMutableArray *willUpdateHistories = [[NSMutableArray alloc] init];
    
    if ([self historyExists]) {
        
        willUpdateHistories = [[self getSearchHistories] mutableCopy];
        
        if (willUpdateHistories.count > index) {
            
            [willUpdateHistories removeObjectAtIndex:index];
            [NSKeyedArchiver archiveRootObject:willUpdateHistories toFile:[self historyFilePath]];
            
        }
    }
}



- (NSArray * _Nonnull)getSearchHistories {
    
    NSMutableArray *returnHistories = [[NSMutableArray alloc] init];
    
    if ([self historyExists]) {
        
        NSData *data = [NSData dataWithContentsOfFile:[self historyFilePath]];
        NSArray *histories = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if (histories != nil) {
            
            returnHistories = [histories mutableCopy];
        }
    }
    
    return returnHistories;
}

- (NSString * _Nonnull)historyFilePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *historyFilePath = [paths[0] stringByAppendingString:filePath];
    
    return historyFilePath;
}

- (BOOL)historyExists {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self historyFilePath]]) {
        
        return true;
    }
    else {
        
        return false;
    }
}


@end
