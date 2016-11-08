//
//  ViewController.m
//  pongiftTest
//
//  Created by 김승중 on 2016. 10. 26..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "ViewController.h"
#import "PongiftAgent.h"
#import "PongiftContactsManager.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (IBAction)openPongiftVC:(id)sender {
    
    // 폰기프트 선물하기기능을 위한 컨트롤러 호출
    PongiftAgent *agent = [PongiftAgent sharedInstance];
    [agent openPongiftViewController:self];
    
}



@end
