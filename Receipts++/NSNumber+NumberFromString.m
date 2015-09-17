//
//  NSNumber+NumberFromString.m
//  Rotten Mangoes
//
//  Created by asu on 2015-09-14.
//  Copyright (c) 2015 asu. All rights reserved.
//

#import "NSNumber+NumberFromString.h"

@implementation NSNumber (NumberFromString)
+(instancetype)numberFromString:(NSString*)string{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *convertedNumber = [numberFormatter numberFromString:string];
    return convertedNumber;
}
@end
