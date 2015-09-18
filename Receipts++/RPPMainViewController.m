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
    
//    NSError *error = nil;
//    [self.fetchedResultsController performFetch:&error];
    
    self.fetchedResultsController = nil;
    
    [self.receiptsTableView reloadData];
}


- (IBAction)addReceipt:(UIButton *)sender {
    UIViewController *addViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addReceipt"];
    [self presentViewController:addViewController animated:YES completion:nil];
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    unsigned long result = self.fetchedResultsController.sections.count;
    NSLog(@"num Sections %lu", result);
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RPPTag *tag = [self tagAtSection:section];
    
    unsigned long result = [[tag.receipt allObjects] count];

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
    
    NSArray *receipts = [tag.receipt allObjects];
    
    RPPReceipt *receipt = receipts[ indexPath.row ];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ on %@",
                           [receipt.amount currency:@"$"],
                           [receipt.timeOfSale dateStringWithFormat:@"dd-MMM, h:mm:ss a"] ];
    cell.detailTextLabel.text = receipt.saleDescription;
    
//    NSLog(@"++++%@", receipt);
//    NSLog(@"---> %@", receipt.tags);
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
                                                                   ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.context
                                                                                                 sectionNameKeyPath:NAME_ATTRIBUTE_NAME
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

//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    [self.receiptsTableView beginUpdates];
//}

//- (void)controller:(NSFetchedResultsController *)controller
//  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
//           atIndex:(NSUInteger)sectionIndex
//     forChangeType:(NSFetchedResultsChangeType)type {
//    switch(type) {
//        case NSFetchedResultsChangeInsert:
//            [self.receiptsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [self.receiptsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        default:
//            return;
//    }
//}
//
//- (void)controller:(NSFetchedResultsController *)controller
//   didChangeObject:(id)anObject
//       atIndexPath:(NSIndexPath *)indexPath
//     forChangeType:(NSFetchedResultsChangeType)type
//      newIndexPath:(NSIndexPath *)newIndexPath {
//    UITableView *tableView = self.receiptsTableView;
//    
//    switch(type) {
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
//{
//    [self.receiptsTableView endUpdates];
//}




@end
