//
//  AstNode.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "AstNode.h"

@implementation AstNode

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode {
    self = [super init];
    if (self) {
        _beginPos = beginPos;
        _endPos   = endPos;
        _isErrorNode = isErrorNode;
    }
    return self;
}

- (void)dump:(NSString *)prefix {
    
}

- (id)accept:(AstVisitor *)visitor {
    return nil;
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return nil;
}

@end
