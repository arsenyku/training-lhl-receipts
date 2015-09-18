//
//  ViewController.m
//  Receipts++
//
//  Created by asu on 2015-09-17.
//  Copyright © 2015 asu. All rights reserved.
//

#import "RPPConstants.h"
#import "RPPMainViewController.h"
#import "RPPAppDelegate.h"
#import "RPPReceipt.h"
#import "RPPTag.h"
#import "NSNumber+CurrencyFormat.h"
#import "NSDate+FormattedDate.h"

@interface RPPMainViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *receiptsTableView;

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RPPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    RPPAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    self.context = [appDelegate managedObjectContext];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self fetchData];
    
    [self.receiptsTableView reloadData];
}


- (IBAction)addReceipt:(UIButton *)sender {
    UIViewController *addViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addReceipt"];
    [self presentViewController:addViewController animated:YES completion:nil];
}

- (void)fetchData {
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    unsigned long result = self.fetchedResultsController.sections.count;
    NSLog(@"num Sections %lu", result);
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RPPTag *tag = [self tagAtSection:section];
    
    unsigned long result = [[tag.receipts allObjects] count];

    NSLog(@"num rows for section %lu is %lu", section, result);
    
    return result;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"receiptCell"
                                                            forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RPPReceipt *deleteTarget = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.context deleteObject:deleteTarget];
    }
}

-(RPPTag*)tagAtSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[ section ] ;
    NSArray *tags = [sectionInfo objects];
    
    RPPTag *tag = [tags firstObject];
    return tag;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RPPTag *tag = [self tagAtSection:indexPath.section];
    
    NSArray *receipts = [tag.receipts allObjects];
    
    RPPReceipt *receipt = receipts[ indexPath.row ];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ on %@",
                           [receipt.amount currency:@"$"],
                           [receipt.timeOfSale dateStringWithFormat:@"dd-MMM, h:mm:ss a"] ];
    cell.detailTextLabel.text = receipt.saleDescription;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[ section ] ;
    NSArray *tags = [sectionInfo objects];
    
    RPPTag *tag = [tags firstObject];
    
    return tag.name;
}


#pragma mark - Fetched Results Controller
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:TAG_ENTITY_NAME
                                              inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:NAME_ATTRIBUTE_NAME
                                                                   ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.context
                                                                                                 sectionNameKeyPath:NAME_ATTRIBUTE_NAME
                                                                                                          cacheName:@"Master"];
    fetchedResultsController.delegate = self;
    self.fetchedResultsController = fetchedResultsController;
    
    [self fetchData];
    
    return _fetchedResultsController;
}

@end
