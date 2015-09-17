//
//  RPPReceipt+CoreDataProperties.h
//  Receipts++
//
//  Created by asu on 2015-09-17.
//  Copyright © 2015 asu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RPPReceipt.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPPReceipt (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSString *saleDescription;
@property (nullable, nonatomic, retain) NSDate *timeOfSale;
@property (nullable, nonatomic, retain) NSSet<RPPTag *> *tags;

@end

@interface RPPReceipt (CoreDataGeneratedAccessors)

- (void)addTagsObject:(RPPTag *)value;
- (void)removeTagsObject:(RPPTag *)value;
- (void)addTags:(NSSet<RPPTag *> *)values;
- (void)removeTags:(NSSet<RPPTag *> *)values;

@end

NS_ASSUME_NONNULL_END
