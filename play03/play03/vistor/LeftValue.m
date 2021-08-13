//
//  LeftValue.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "LeftValue.h"

@implementation LeftValue
- (instancetype)initWithVariable:(Variable *)variable {
    self = [super init];
    if (self) {
        _variable = variable;
    }
    return self;
}
@end
