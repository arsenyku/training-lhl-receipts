//
//  RPPTag+CoreDataProperties.h
//  Receipts++
//
//  Created by asu on 2015-09-17.
//  Copyright © 2015 asu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RPPTag.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPPTag (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<RPPReceipt *> *receipts;

@end

@interface RPPTag (CoreDataGeneratedAccessors)

- (void)addReceiptsObject:(RPPReceipt *)value;
- (void)removeReceiptsObject:(RPPReceipt *)value;
- (void)addReceipts:(NSSet<RPPReceipt *> *)values;
- (void)removeReceipts:(NSSet<RPPReceipt *> *)values;

@end

NS_ASSUME_NONNULL_END
