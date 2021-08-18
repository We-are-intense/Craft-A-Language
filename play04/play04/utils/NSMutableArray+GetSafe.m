//
//  NSMutableArray+GetSafe.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "NSMutableArray+GetSafe.h"

@implementation NSMutableArray (GetSafe)

- (id)index:(NSUInteger)idx {
    if (self.count == 0) {
        return nil;
    }
    
    if (idx >= self.count || idx < 0) {
        return nil;
    }
    return self[idx];
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
