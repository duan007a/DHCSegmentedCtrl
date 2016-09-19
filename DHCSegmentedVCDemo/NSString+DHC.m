//
//  NSString+DHC.m
//  DHCSegmentedVCDemo
//
//  Created by sdlcdhch on 16/9/18.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "NSString+DHC.h"

@implementation NSString (DHC)

- (NSString *)dhc_trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
