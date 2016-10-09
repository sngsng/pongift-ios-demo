//
//  ViewController.m
//  Pongift
//
//  Created by 김승중 on 2016. 9. 30..
//  Copyright © 2016년 slogup. All rights reserved.
//

#import "ViewController.h"
#import "PongiftAgent.h"
#import "PongiftPersistenceManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor = [UIColor blackColor];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
}
- (IBAction)pushOpenPongiftAgent:(id)sender {

    
    
    PongiftAgent *agent = [PongiftAgent sharedInstance];
    NSString *accessKey = @"j8NtyUuoubAfGShaRQF2MA==";
    NSString *secretKey = @"bD3QeKX2rhUcSVlubuy2Dg==";
    [agent initializePongiftWithSecretKey:secretKey andAccessKey:accessKey completion:^(bool completion) {
        
        if (completion) {
            
            [agent openPongiftViewController:self];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
