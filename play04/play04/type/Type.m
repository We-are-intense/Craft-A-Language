//
//  Type.m
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import "Type.h"

@implementation Type

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

@end
