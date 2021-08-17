//
//  AstVisitor.m
//  play01
//
//  Created by 夏二飞 on 2021/8/10.
//

#import "AstVisitor.h"
#import "Prog.h"

@implementation AstVisitor

- (id)visit:( AstNode * _Nullable )node {
    return [node accept:self];
}

- (id)visitProg:(Prog *)prog {
    id retVal = nil;
    for (id obj in prog.stmts) {
        retVal = [self visit:obj];
    }
    return retVal;
}

- (id)visitBinary:(Binary *)exp {
    [self visit:exp.exp1];
    [self visit:exp.exp2];
    return nil;
}

- (id)visitVariableDecl:(VariableDecl *)variableDecl {
    if (variableDecl.initi) {
        return [self visit:variableDecl.initi];
    }
    return nil;
}

- (id)visitIntegerLiteral:(IntegerLiteral *)exp; {
    return exp.value;
}

- (id)visitDecimalLiteral:(DecimalLiteral *)exp {
    return exp.value;
}

- (id)visitStringLiteral:(StringLiteral *)exp {
    return exp.value;
}
- (id)visitNullLiteral:(NullLiteral *)exp {
    return nil;
}
- (id)visitBooleanLiteral:(BooleanLiteral *)exp {
    return exp.value;
}
- (id)visitVariable:(Variable *)exp {
    return nil;
}

- (id)visitBlock:(Block *)block {
    id retVal = nil;
    for (id obj in block.stmts) {
        retVal = [self visit:obj];
    }
    return retVal;
}

- (id)visitExpressionStatement:(ExpressionStatement *)stmt {
    return [self visit:stmt.exp];
}

- (id)visitFunctionDecl:(FunctionDecl *)functionDecl {
    return [self visitBlock:functionDecl.body];
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
