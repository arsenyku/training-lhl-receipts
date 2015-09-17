//
//  NSNumber+CurrencyFormat.h
//  Receipts++
//
//  Created by asu on 2015-09-17.
//  Copyright © 2015 asu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (CurrencyFormat)
-(NSString*)currency:(NSString*)prefix;
@end
