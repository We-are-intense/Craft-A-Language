//
//  AstVisitor.m
//  play01
//
//  Created by 夏二飞 on 2021/8/10.
//

#import "AstVisitor.h"
#import "Prog.h"

@implementation AstVisitor

- (id)visit:( AstNode * _Nullable )node additional:(id)additional {
    return [node accept:self additional:additional];
}

- (id)visitProg:(Prog *)prog additional:(id)additional {
    id retVal = nil;
    for (id obj in prog.stmts) {
        retVal = [self visit:obj additional:additional];
    }
    return retVal;
}

- (id)visitBinary:(Binary *)exp  additional:(id)additional {
    [self visit:exp.exp1 additional:additional];
    [self visit:exp.exp2 additional:additional];
    return nil;
}

- (id)visitVariableDecl:(VariableDecl *)variableDecl additional:(id)additional {
    if (variableDecl.initi) {
        return [self visit:variableDecl.initi additional:additional];
    }
    return nil;
}

- (id)visitIntegerLiteral:(IntegerLiteral *)exp additional:(id)additional {
    return exp.value;
}

- (id)visitDecimalLiteral:(DecimalLiteral *)exp additional:(id)additional {
    return exp.value;
}

- (id)visitStringLiteral:(StringLiteral *)exp additional:(id)additional {
    return exp.value;
}
- (id)visitNullLiteral:(NullLiteral *)exp additional:(id)additional {
    return nil;
}
- (id)visitBooleanLiteral:(BooleanLiteral *)exp additional:(id)additional {
    return exp.value;
}
- (id)visitVariable:(Variable *)exp additional:(id)additional {
    return nil;
}

- (id)visitBlock:(Block *)block additional:(id)additional {
    id retVal = nil;
    for (id obj in block.stmts) {
        retVal = [self visit:obj additional:additional];
    }
    return retVal;
}

- (id)visitExpressionStatement:(ExpressionStatement *)stmt additional:(id)additional {
    return [self visit:stmt.exp additional:additional];
}

- (id)visitFunctionDecl:(FunctionDecl *)functionDecl additional:(id)additional {
    return [self visitBlock:functionDecl.body additional:additional];
}

- (id)visitFunctionBody:(FunctionBody *)functionBody additional:(id)additional {
    id retVal = nil;
    for (id obj in functionBody.stmts) {
        retVal = [self visitFunctionCall:obj additional:additional];
    }
    return retVal;
}

- (id)visitFunctionCall:(FunctionCall *)functionCall additional:(id)additional {
    return nil;
}

- (id)visitParameterList:(ParameterList *)paramList additional:(id)additional {
    id retVal = nil;
    for (id x in paramList.params) {
        retVal = [self visit:x additional:additional];
    }
    return retVal;
}

- (id)visitCallSignature:(CallSignature *)callSignature additional:(id)additional {
    if (callSignature.paramList) {
        return [self visit:callSignature.paramList additional:additional];
    }
    return nil;
}

- (id)visitReturnStatement:(ReturnStatement *)stmt additional:(id)additional {
    if (stmt.exp) {
        return [self visit:stmt.exp additional:additional];
    }
    return nil;
}

- (id)visitIfStatement:(IfStatement *)stmt additional:(id)additional {
    [self visit:stmt.conditon additional:additional];
    [self visit:stmt.stmt additional:additional];
    if (stmt.elseStmt) {
        [self visit:stmt.elseStmt additional:additional];
    }
    return nil;
}
@end
