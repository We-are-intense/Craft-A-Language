//
//  BooleanLiteral.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "BooleanLiteral.h"
#import "AstVisitor.h"

@implementation BooleanLiteral
- (instancetype)initWithValue:(NSNumber *)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitBooleanLiteral:self additional:additional];
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@%@", prefix, self.value);
}
@end
