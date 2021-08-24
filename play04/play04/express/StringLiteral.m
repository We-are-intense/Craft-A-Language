//
//  StringLiteral.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "StringLiteral.h"
#import "AstVisitor.h"

@implementation StringLiteral
- (instancetype)initWithValue:(NSString *)value {
    self = [super init];
    if (self) {
        _value = value;
    }
    return self;
}

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                           value:(NSString *)value {
    self = [super initWithBeginPos:beginPos endPos:endPos isErrorNode:isErrorNode];
    if (self) {
        _value = value;
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitStringLiteral:self additional:additional];
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@%@", prefix, self.value);
}
@end
