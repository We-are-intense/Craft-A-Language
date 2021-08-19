//
//  ReturnStatement.m
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import "ReturnStatement.h"
#import "AstVisitor.h"

@implementation ReturnStatement
- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                             exp:(Expression *)exp {
    self = [super initWithBeginPos:beginPos endPos:endPos isErrorNode:isErrorNode];
    if (self) {
        self.exp = exp;
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitReturnStatement:self additional:additional];
}

@end
