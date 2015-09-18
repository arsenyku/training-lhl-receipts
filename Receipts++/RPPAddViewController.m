//
//  RPPAddViewController.m
//  Receipts++
//
//  Created by asu on 2015-09-17.
//  Copyright © 2015 asu. All rights reserved.
//

#import "RPPConstants.h"
#import "RPPAddViewController.h"
#import "RPPAppDelegate.h"
#import "RPPReceipt.h"
#import "RPPTag.h"
#import "NSNumber+NumberFromString.h"

@interface RPPAddViewController () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *receiptNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiptAmountTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *receiptDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *addTagTextField;
@property (weak, nonatomic) IBOutlet UITextView *tagsListTextView;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RPPAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tagsListTextView.layer.borderColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2f] CGColor];
    self.tagsListTextView.layer.borderWidth = 0.5f;
	self.automaticallyAdjustsScrollViewInsets = NO;
    self.tagsListTextView.text = @"";
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    RPPAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    self.context = [appDelegate managedObjectContext];
}


- (IBAction)doneAction:(UIButton *)sender {
    if ([self createNewReceipt]) {
	    [self dismissViewControllerAnimated:YES completion:nil];
	}
}


- (void)dismissKeyboard {
    [self.receiptNameTextField resignFirstResponder];
    [self.receiptAmountTextField resignFirstResponder];
    [self.addTagTextField resignFirstResponder];
    
}

- (BOOL)createNewReceipt {

    NSNumber *amount = [NSNumber numberFromString:self.receiptAmountTextField.text];
    
    if (amount == nil)
        return NO;
    
    RPPReceipt *receipt = [NSEntityDescription
                            insertNewObjectForEntityForName:RECEIPT_ENTITY_NAME
                            inManagedObjectContext:self.context];
    
    receipt.saleDescription = self.receiptNameTextField.text;
    receipt.amount = amount;
    receipt.timeOfSale = self.receiptDatePicker.date;
    
    NSError *saveError = nil;
    
    if (![self.context save:&saveError]) {
        NSLog(@"Save failed! %@", saveError);
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *candidateText = [self.addTagTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([candidateText length] > 0){
    
        self.tagsListTextView.text =
        [NSString stringWithFormat:@"%@\n%@", self.tagsListTextView.text, self.addTagTextField.text];
        
        self.addTagTextField.text = @"";
    }
    
    return YES;
}


#pragma mark - Fetched Results Controller
- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:RECEIPT_ENTITY_NAME
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:RECEIPT_ENTITY_NAME
                                                                   ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.context
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:@"Master"];
    fetchedResultsController.delegate = self;
    self.fetchedResultsController = fetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}




@end
