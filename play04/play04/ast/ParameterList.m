//
//  ParameterList.m
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import "ParameterList.h"
#import "AstVisitor.h"
@implementation ParameterList

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                          params:(NSArray <VariableDecl *> *)params {
    self = [super initWithBeginPos:beginPos endPos:endPos isErrorNode:isErrorNode];
    if (self) {
        _params = [params copy];
    }
    return self;
}


- (id)accept:(AstVisitor *)visitor additional:(nonnull id)additional {
    return [visitor visitParameterList:self additional:additional];
}

@end
