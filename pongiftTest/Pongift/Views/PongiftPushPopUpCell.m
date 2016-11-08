//
//  PongiftPushPopUpCell.m
//  pongiftTest
//
//  Created by 김승중 on 2016. 10. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftPushPopUpCell.h"
#import "PongiftPersistenceManager.h"
#import "PongiftConstants.h"

@implementation PongiftPushPopUpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellFromBirthDayDictionary:(NSDictionary* _Nonnull) dictionary {
    
    NSInteger offset = [[PongiftPersistenceManager sharedInstance] getNotificationFiredDayOffset];
    
    NSString *targetName = [dictionary objectForKey:kName];
    NSString *phone = [dictionary objectForKey:kPhone];
    
    _birthDayTargetPhoneNumLabel.text = phone;
    _birthDayTargetNameLabel.text = targetName;
    
    switch (offset) {
            
        case 0: {
            _birthDayMsgPrefixLabel.text = @"";
            break;
        }
        case 1: {
            
            _birthDayMsgPrefixLabel.text = LocalNotiTommorowBirthDayPrefix;
            break;
        }
        default: {
            
            _birthDayMsgPrefixLabel.text = [NSString stringWithFormat:LocalNotiPreviousBirthDayPrefix, offset];
            break;
        }
    }
    
}

@end
