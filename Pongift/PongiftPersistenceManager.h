//
//  PongiftPersistenceManager.h
//  Pongift
//
//  Created by 김승중 on 2016. 10. 9..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PongiftSearchHistory.h"



@interface PongiftPersistenceManager : NSObject

@property (strong, nonatomic)  NSString * _Nullable serviceId;

+ (id _Nonnull)sharedInstance;
- (void)addSearchHistory:(PongiftSearchHistory * _Nonnull)searchHistory;
- (void)removeSearchHistoryAtIndex:(NSInteger)index;
- (NSArray * _Nonnull)getSearchHistories;
@end
