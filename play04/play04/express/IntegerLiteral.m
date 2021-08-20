//
//  IntegerLiteral.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "IntegerLiteral.h"
#import "AstVisitor.h"

@implementation IntegerLiteral

- (instancetype)initWithValue:(NSNumber *)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitIntegerLiteral:self additional:additional];
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@%@", prefix, self.value);
}


@end