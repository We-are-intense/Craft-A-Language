//
//  StringLiteral.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "StringLiteral.h"
#import "AstVisitor.h"

@implementation StringLiteral
- (instancetype)initWithValue:(NSNumber *)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor {
    return [visitor visitStringLiteral:self];
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@%@", prefix, self.value);
}
@end
