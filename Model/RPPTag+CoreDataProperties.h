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
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *receipt;

@end

@interface RPPTag (CoreDataGeneratedAccessors)

- (void)addReceiptObject:(NSManagedObject *)value;
- (void)removeReceiptObject:(NSManagedObject *)value;
- (void)addReceipt:(NSSet<NSManagedObject *> *)values;
- (void)removeReceipt:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
