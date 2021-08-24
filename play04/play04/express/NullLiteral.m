//
//  NullLiteral.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "NullLiteral.h"
#import "AstVisitor.h"
@implementation NullLiteral
- (instancetype)init {
    self = [super init];
    if (self) {
        _value = @"null";
    }
    return self;
}

- (instancetype)initWithBeginPos:(Position *)beginPos endPos:(Position *)endPos isErrorNode:(BOOL)isErrorNode {
    self = [super initWithBeginPos:beginPos endPos:endPos isErrorNode:isErrorNode];
    if (self) {
        _value = @"null";
        _theType = SysTypes.Null;
    }
    return self;
}


- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitNullLiteral:self additional:additional];
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@%@", prefix, self.value);
}
@end
