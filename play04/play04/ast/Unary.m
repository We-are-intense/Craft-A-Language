//
//  Unary.m
//  play04
//
//  Created by 夏二飞 on 2021/8/24.
//

#import "Unary.h"

@implementation Unary

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                              op:(NSInteger)op
                             exp:(Expression *)exp
                        isPrefix:(BOOL)isPrefix {
    self = [super initWithBeginPos:beginPos endPos:endPos isErrorNode:isErrorNode];
    if (self) {
        self.op = op;
        self.exp = exp;
        self.isPrefix = isPrefix;
    }
    return self;
}

@end
