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

    NSSet *tags = [self retrieveTags];
    
    if ([tags count] < 1)
        return NO;
    
    RPPReceipt *receipt = [NSEntityDescription
                            insertNewObjectForEntityForName:RECEIPT_ENTITY_NAME
                            inManagedObjectContext:self.context];
    
    receipt.saleDescription = self.receiptNameTextField.text;
    receipt.amount = amount;
    receipt.timeOfSale = self.receiptDatePicker.date;
    
    receipt.tags = tags;

    NSError *saveError = nil;
    
    if (![self.context save:&saveError]) {
        NSLog(@"Save failed! %@", saveError);
    }
    
    return YES;
}


-(NSSet*)retrieveTags{
    NSMutableSet *result = [[NSMutableSet alloc] init];
    
    NSArray *tagStrings = [self.tagsListTextView.text componentsSeparatedByString:@"\n"];
    
    NSError *error = nil;
    if (! [self.fetchedResultsController performFetch:&error] )
        NSLog(@"Error during tags query: %@", error);
    
    NSArray *fetchedTags = self.fetchedResultsController.fetchedObjects;
    
    for (NSString *tagString in tagStrings) {
        // Ignore if the tag is empty
        if ([tagString length] < 1)
            continue;
        
        RPPTag* tag = [[fetchedTags filteredArrayUsingPredicate:
                        [NSPredicate predicateWithFormat:@"name = %@",tagString]] firstObject];
		
        if (! tag)
            tag = [self createTag:tagString];
        
        
        [result addObject:tag];
        
    }

    return result;
}


- (RPPTag*)createTag:(NSString*)tagString {
    RPPTag *tag = [NSEntityDescription
                           insertNewObjectForEntityForName:TAG_ENTITY_NAME
                           inManagedObjectContext:self.context];
    tag.name = tagString;
    
    return tag;

}

#pragma mark - UITextFieldDelegate

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *candidateText = [self.addTagTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *newline = [self.tagsListTextView.text length] > 0 ? @"\n" : @"";
    if ([candidateText length] > 0){
    
        self.tagsListTextView.text =
        [NSString stringWithFormat:@"%@%@%@", self.tagsListTextView.text, newline, self.addTagTextField.text];
        
        self.addTagTextField.text = @"";
    }
    
    return YES;
}


#pragma mark - Fetched Results Controller
- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *tagsQuery = [[NSFetchRequest alloc] initWithEntityName:TAG_ENTITY_NAME];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:NAME_ATTRIBUTE_NAME
                                                                   ascending:NO];
    
    [tagsQuery setSortDescriptors:@[sortDescriptor]];
    
    [tagsQuery setFetchBatchSize:20];
    
    self.fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:tagsQuery
                                        managedObjectContext:self.context
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Master"];

    
    self.fetchedResultsController.delegate = self;
    
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
