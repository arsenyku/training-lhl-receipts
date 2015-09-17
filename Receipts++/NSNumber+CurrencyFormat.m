//
//  NSNumber+CurrencyFormat.m
//  Receipts++
//
//  Created by asu on 2015-09-17.
//  Copyright © 2015 asu. All rights reserved.
//

#import "NSNumber+CurrencyFormat.h"

@implementation NSNumber (CurrencyFormat)
-(NSString*)currency:(NSString*)prefix{
    return [NSString stringWithFormat:@"%@%.2f",prefix, [self floatValue] ];
}
@end
