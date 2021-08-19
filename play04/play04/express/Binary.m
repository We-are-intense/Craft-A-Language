//
//  Binary.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Binary.h"
#import "AstVisitor.h"

@implementation Binary

- (instancetype)initWithOp:(NSString *)op
                      exp1:(Expression *)exp1
                      exp2:(Expression *)exp2 {
    self = [super init];
    if (self) {
        _op = [op copy];
        _exp1 = exp1;
        _exp2 = exp2;
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitBinary:self additional:additional];
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@Binary:%@", prefix, self.op);
    [self.exp1 dump:[NSString stringWithFormat:@"%@    ", prefix]];
    [self.exp2 dump:[NSString stringWithFormat:@"%@    ", prefix]];
}


@end
