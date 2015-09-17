//
//  NSDate+format.m
//  Every Do
//
//  Created by asu on 2015-09-08.
//  Copyright (c) 2015 asu. All rights reserved.
//

#import "NSDate+FormattedDate.h"

@implementation NSDate (PrettyDate)
-(NSString*)dateStringWithFormat:(NSString*)format{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

@end
