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

// 최근검색어 (리스트조회, 추가, 삭제, 모두 삭제)
- (void)addSearchHistory:(PongiftSearchHistory * _Nonnull)searchHistory;
- (void)removeSearchHistoryAtIndex:(NSInteger)index;
- (void)removeAllSearchHistory;
- (NSArray * _Nonnull)getSearchHistories;

// 알림 설정 (조회, 수정)
- (NSDictionary * _Nonnull)getNotificationSettings;
- (void)updateNotificationSettings:(NSDictionary* _Nonnull)updatedSettings;
- (NSInteger)getNotificationFiredDayOffset;
@end
