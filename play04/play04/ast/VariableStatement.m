//
//  VariableStatement.m
//  play04
//
//  Created by xiaerfei on 2021/8/22.
//

#import "VariableStatement.h"

@implementation VariableStatement

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                    variableDecl:(VariableDecl *)variableDecl {
    self = [super initWithBeginPos:beginPos endPos:endPos isErrorNode:isErrorNode];
    if (self) {
        self.variableDecl = variableDecl;
    }
    return self;
}

@end
