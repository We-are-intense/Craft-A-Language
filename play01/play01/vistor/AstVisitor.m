//
//  AstVisitor.m
//  play01
//
//  Created by 夏二飞 on 2021/8/10.
//

#import "AstVisitor.h"

@implementation AstVisitor

- (id)visitProg:(Prog *)prog {
    id retVal = nil;
    for (id obj in prog.stmts) {
        if ([obj isKindOfClass:FunctionDecl.class]) {
            retVal = [self visitFunctionDecl:obj];
        } else {
            retVal = [self visitFunctionCall:obj];
        }
    }
    return retVal;
}

- (id)visitFunctionDecl:(FunctionDecl *)functionDecl {
    return [self visitFunctionBody:functionDecl.body];
}

- (id)visitFunctionBody:(FunctionBody *)functionBody {
    id retVal = nil;
    for (id obj in functionBody.stmts) {
        retVal = [self visitFunctionCall:obj];
    }
    return retVal;
}

- (id)visitFunctionCall:(FunctionCall *)functionCall {
    return nil;
}

@end
