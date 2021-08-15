//
//  NSSafeMutableArray.m
//  play03
//
//  Created by xiaerfei on 2021/8/15.
//

#import "NSSafeMutableArray.h"

@implementation NSSafeMutableArray
- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    if (self.count == 0) {
        return nil;
    }
    
    if (idx >= self.count || idx < 0) {
        return nil;
    }
    return [self objectAtIndex:idx];
}

- (id)shift {
    if (self.count == 0) {
        return nil;
    }
    id obj = self.firstObject;
    [self removeObjectAtIndex:0];
    return obj;
}
@end
