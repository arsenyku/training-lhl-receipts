//
//  ViewController.m
//  Receipts++
//
//  Created by asu on 2015-09-17.
//  Copyright © 2015 asu. All rights reserved.
//

#import "RPPMainViewController.h"

@interface RPPMainViewController ()

@end

@implementation RPPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    NSLog(@"test");
}


- (IBAction)addReceipt:(UIButton *)sender {
    UIViewController *addViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addReceipt"];
    [self presentViewController:addViewController animated:YES completion:nil];
}

@end
