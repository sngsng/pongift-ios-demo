//
//  PongiftPushPopUpCell.h
//  pongiftTest
//
//  Created by 김승중 on 2016. 10. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PongiftPushPopUpCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *birthDayMsgPrefixLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthDayTargetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthDayTargetPhoneNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendGiftButton;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (void)updateCellFromBirthDayDictionary:(NSDictionary* _Nonnull) dictionary;

@end
