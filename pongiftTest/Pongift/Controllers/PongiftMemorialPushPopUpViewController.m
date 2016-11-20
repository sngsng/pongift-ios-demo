//
//  PongiftMemorialPushPopUpViewController.m
//  pongiftTest
//
//  Created by 김승중 on 2016. 10. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "PongiftMemorialPushPopUpViewController.h"
#import "PongiftPushPopUpCell.h"
#import "PongiftConstants.h"
#import "PongiftPersistenceManager.h"
#import <MessageUI/MessageUI.h>
#import "PongiftAgent.h"
#import "PongiftUtils.h"

@interface PongiftMemorialPushPopUpViewController () <UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerNotificationTitleLabel;

@end

@implementation PongiftMemorialPushPopUpViewController

NSArray<NSDictionary*> *birthdays;
NSString *const cellNibName = @"PongiftPushPopUpCell";


CGFloat const cellHeight = 132.0f;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self updateHeaderView];
    [self setUpTableView];
    
}

#pragma mark - Private Functions

- (void)updateHeaderView {
    
    NSInteger offset = [[PongiftPersistenceManager sharedInstance] getNotificationFiredDayOffset];
    NSDateComponents *todayDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [todayDateComponents setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Seoul"]];
    
    
    NSInteger curMonth = [todayDateComponents month];
    NSInteger curDay = [todayDateComponents day];

    
    NSDateFormatter *birthDayFormatter = [[NSDateFormatter alloc] init];
    [birthDayFormatter setDateFormat:BirthDayDateFormat];
    NSString *birthDayString = [birthDayFormatter stringFromDate:[NSDate date]];
    
    NSDateFormatter *weekDayFormatter = [[NSDateFormatter alloc] init] ;
    [weekDayFormatter setDateFormat:WeekDayDateFormat];
    NSString *weekDayString = [weekDayFormatter stringFromDate:[NSDate date]];
    
    if (offset == 0) {
        
        _headerNotificationTitleLabel.text = LocalNotiHeaderBirthDayTodayAlarm;
        _headerDateLabel.text = birthDayString;
        _headerDayLabel.text = weekDayString;
        
    }
    else {
        
        _headerNotificationTitleLabel.text = LocalNotiHeaderBirthDayPreviousDayAlarm;
        _headerDateLabel.text = [NSString stringWithFormat:LocalNotiHeaderDDayTitleFormat,offset];
        
        if (birthdays != nil && birthdays.count > 0) {
            
            NSDictionary *birthDay = birthdays[0];
            NSInteger targetMonth = [[birthDay objectForKey:kBirthMonth] integerValue];
            NSInteger targetDay = [[birthDay objectForKey:kBirthDay] integerValue];
            _headerDayLabel.text = [NSString stringWithFormat:LocalNotiBirthDayFormat,targetMonth, targetDay];
        }
        else {
            
            _headerDayLabel.text = [NSString stringWithFormat:LocalNotiBirthDayFormat,curMonth,curDay];
        }
        
    }
}


- (void)setUpTableView {
    
    if (_notification != nil) {
        
        NSDictionary *userInfo = _notification.userInfo;
        
        if (userInfo != nil) {
            
            if ([userInfo objectForKey:kBirthDaysNotificationInfo] != nil) {
                
                birthdays = [userInfo objectForKey:kBirthDaysNotificationInfo];
            }
        }
    }
    
    UINib *cellNib = [UINib nibWithNibName:cellNibName bundle:[PongiftUtils frameworkBundle]];
    if (cellNib == nil) [UINib nibWithNibName:cellNibName bundle:[NSBundle mainBundle]];
    [_tableView registerNib:cellNib forCellReuseIdentifier:cellNibName];
}

#pragma mark - Control Actions

- (void)pushSendGiftButton:(UIButton*)sender {
    
    [[PongiftAgent sharedInstance] openPongiftViewController:self];
}

- (void)pushSendMsgButton:(UIButton*)sender {
    
    NSInteger tag = sender.tag;
    NSDictionary *birthDay = birthdays[tag];
    NSString *targetPhone = [birthDay objectForKey:kPhone];
    
    if ([MFMessageComposeViewController canSendText]) {
        
        MFMessageComposeViewController *msgVC = [[MFMessageComposeViewController alloc] init];
        msgVC.messageComposeDelegate = self;
        
        if (targetPhone != nil) {
            msgVC.recipients = @[targetPhone];
        }
        
        [self presentViewController:msgVC animated:true completion:nil];
        
    }
}

- (IBAction)pushCloseButton:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (birthdays != nil) return birthdays.count;
        else return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PongiftPushPopUpCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNibName forIndexPath:indexPath];
    
    if (birthdays != nil) {
        
        NSDictionary *birthDay = birthdays[indexPath.row];
        
        cell.sendGiftButton.tag = indexPath.row;
        cell.sendMessageButton.tag = indexPath.row;
        
        [cell.sendGiftButton addTarget:self action:@selector(pushSendGiftButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sendMessageButton addTarget:self action:@selector(pushSendMsgButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell updateCellFromBirthDayDictionary:birthDay];
        
    }
    
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return cellHeight;
}

#pragma mark - MFMessageComposeViewController Delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [controller dismissViewControllerAnimated:true completion:nil];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
