//
//  RPPAddViewController.m
//  Receipts++
//
//  Created by asu on 2015-09-17.
//  Copyright © 2015 asu. All rights reserved.
//

#import "RPPAddViewController.h"

@interface RPPAddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *receiptNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiptAmountTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *receiptDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *addTagTextField;
@property (weak, nonatomic) IBOutlet UITextView *tagsListTextView;


@end

@implementation RPPAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tagsListTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}


- (IBAction)doneAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)dismissKeyboard {
    [self.receiptNameTextField resignFirstResponder];
    [self.receiptAmountTextField resignFirstResponder];
    [self.addTagTextField resignFirstResponder];
    
}

@end
