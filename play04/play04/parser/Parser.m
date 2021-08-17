//
//  Parser.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

/*
 
    当前语法规则：
    prog = statementList? EOF;
    statementList = (variableDecl | functionDecl | expressionStatement)+ ;

    variableDecl : 'let' Identifier typeAnnotation？ ('=' singleExpression) ';';
    typeAnnotation : ':' typeName;

    functionDecl: "function" Identifier "(" ")"  functionBody;
    functionBody : '{' statementList? '}' ;

    statement: functionDecl | expressionStatement;
    expressionStatement: expression ';' ;
    expression: primary (binOP primary)* ;
    primary: StringLiteral | DecimalLiteral | IntegerLiteral | functionCall | '(' expression ')' ;
    binOP: '+' | '-' | '*' | '/' | '=' | '+=' | '-=' | '*=' | '/=' | '==' | '!=' | '<=' | '>=' | '<'
       | '>' | '&&'| '||'|...;

    functionCall : Identifier '(' parameterList? ')' ;
    parameterList : expression (',' expression)* ;
 
 */



#import "Parser.h"
#import "FunctionDecl.h"
#import "FunctionCall.h"
#import "FunctionBody.h"

@interface Parser ()

@property (nonatomic, strong) Scanner *scanner;
@end

@implementation Parser

- (instancetype)initWithScanner:(Scanner *)scanner {
    self = [super init];
    if (self) {
        _scanner = scanner;
    }
    return self;
}

/**
 * 解析Prog
 * 语法规则：
 * prog = (functionDecl | functionCall)* ;
 */
- (Prog *)parseProg {
    return [[Prog alloc] initWithStmts:[self parseStatementList]];
}

-(NSArray <Statement *> *)parseStatementList {
    NSMutableArray <Statement *> *stmts = [NSMutableArray array];
    Token *t = self.scanner.peek;
    
    while (t.kind != TokenKindEOF && !SEqual(t.text, @"}")) {
        Statement *stmt = [self parseStatement];
        if (stmt) {
            [stmts addObject:stmt];
        }
        t = self.scanner.peek;
    }
    
    
    return stmts;
}

- (Statement *)parseStatement {
    Token *t = self.scanner.peek;
    if (t.kind == TokenKindKeyword && SEqual(t.text, @"function")) {
        // 这是个函数声明
        return [self parseFunctionDecl];
    } else if(SEqual(t.text, @"let")) {
        return [self parseVariableDecl];
    } else if (t.kind == TokenKindIdentifier ||
               t.kind == TokenKindDecimalLiteral ||
               t.kind == TokenKindIntegerLiteral ||
               t.kind == TokenKindStringLiteral ||
               SEqual(t.text, @"(")) {
        return [self parseExpressionStatement];
    }
    
    NSLog(@"Can not recognize a expression starting with: %@", self.scanner.peek.text);
    return nil;
}

- (Expression *)parseExpression {
    return [self parseBinary:0];
}

- (ExpressionStatement *)parseExpressionStatement {
    Expression *exp = [self parseExpression];
    if (!exp) {
        NSLog(@"Error parsing ExpressionStatement");
        return nil;
    }
    
    Token *t = self.scanner.peek;
    if (SEqual(t.text, @";")) {
        [self.scanner next];
        return [[ExpressionStatement alloc] initWithExp:exp];
    }
    NSLog(@"Expecting a semicolon at the end of an expresson statement, while we got a %@", t.text);
    return nil;
}

/**
 * 采用运算符优先级算法，解析二元表达式。
 * 这是一个递归算法。一开始，提供的参数是最低优先级，
 *
 * @param prec 当前运算符的优先级
 */
- (Expression *)parseBinary:(NSInteger)prec {
    Expression *exp1 = [self parsePrimary];
    if (!exp1) {
        NSLog(@"Can not recognize a expression starting with: %@", self.scanner.peek.text);
        return nil;
    }
    
    Token *t = self.scanner.peek;
    NSInteger tprec = [self prec:t.text];
    // 下面这个循环的意思是：只要右边出现的新运算符的优先级更高，
    // 那么就把右边出现的作为右子节点。
    /**
     * 对于2+3*5
     * 第一次循环，遇到+号，优先级大于零，所以做一次递归的binary
     * 在递归的binary中，遇到乘号，优先级大于+号，所以形成3*5返回，又变成上一级的右子节点。
     *
     * 反过来，如果是3*5+2
     * 第一次循环还是一样。
     * 在递归中，新的运算符的优先级要小，所以只返回一个5，跟前一个节点形成3*5.
     */
    while (t.kind == TokenKindOperator && tprec > prec) {
        [self.scanner next]; // 跳过运算符
        Expression *exp2 = [self parseBinary:tprec];
        if (exp2) {
            Binary *exp = [[Binary alloc] initWithOp:t.text exp1:exp1 exp2:exp2];
            exp1 = exp;
            t = self.scanner.peek;
            tprec = [self prec:t.text];
        } else {
            NSLog(@"Can not recognize a expression starting with: %@", t.text);
        }
    }
    return exp1;
}
#pragma mark 解析基础表达式
- (Expression *)parsePrimary {
    Token *t = self.scanner.peek;
    //知识点：以Identifier开头，可能是函数调用，也可能是一个变量，所以要再多向后看一个Token，
    //这相当于在局部使用了LL(2)算法。
    if (t.kind == TokenKindIdentifier) {
        if (SEqual(self.scanner.peek2.text, @"(")) {
            return [self parseFunctionCall];
        } else {
            [self.scanner next];
            return [[Variable alloc] initWithName:t.text];
        }
    } else if(t.kind == TokenKindIntegerLiteral) {
        [self.scanner next];
        return [[IntegerLiteral alloc] initWithValue:@(t.text.integerValue)];
    } else if (t.kind == TokenKindDecimalLiteral) {
        [self.scanner next];
        return [[DecimalLiteral alloc] initWithValue:@(t.text.floatValue)];
    } else if (t.kind == TokenKindStringLiteral) {
        [self.scanner next];
        return [[StringLiteral alloc] initWithValue:t.text];
    } else if(SEqual(t.text, @"(")) {
        [self.scanner next];
        Expression *exp = [self parseExpression];
        Token *t1 = self.scanner.peek;
        if (SEqual(t1.text, @")")) {
            [self.scanner next];
            return exp;
        } else {
            NSLog(@"Expecting a ')' at the end of a primary expresson, while we got a %@", t1.text);
            return nil;
        }
    } else {
        NSLog(@"Can not recognize a primary expression starting with: %@", t.text);
        return nil;
    }
}
#pragma mark 解析函数声明
/**
 * 解析函数声明
 * 语法规则：
 * functionDecl: "function" Identifier "(" ")"  functionBody;
 * 返回值为： FunctionDecl *，这里先写 id 类型
 */
- (id)parseFunctionDecl {
    // 跳过关键字'function'
    [self.scanner next];
    Token *token = self.scanner.next;
    if (token.kind == TokenKindIdentifier) {
        Token *t1 = self.scanner.next;
        if ([t1.text isEqualToString:@"("]) {
            Token *t2 = self.scanner.next;
            if ([t2.text isEqualToString:@")"]) {
                Block *body = [self parseFunctionBody];
                if (body != nil) {
                    return  [[FunctionDecl alloc] initWithName:token.text body:body];
                }
            } else {
                NSLog(@"Expecting ')' in FunctionBody, while we got a %@", t2.text);
                return nil;
            }
        } else {
            NSLog(@"Expecting '(' in FunctionBody, while we got a %@", t1.text);
            return nil;
        }
    } else {
        NSLog(@"Expecting a function name, while we got a  %@", token.text);
        return nil;
    }
    return nil;
}
/**
 * 解析函数体
 * 语法规则：
 * functionBody : '{' functionCall* '}' ;
 */
- (Block *)parseFunctionBody {
    Token *t = self.scanner.peek;
    if ([t.text isEqualToString:@"{"]) {
        [self.scanner next];
        NSArray <Statement *> * stmts = [self parseStatementList];
        t = self.scanner.next;
        if (SEqual(t.text, @"}")) {
            return [[Block alloc] initWithStmts:stmts];
        } else {
            NSLog(@"Expecting '}' in FunctionBody, while we got a %@", t.text);
            return nil;
        }
    } else {
        NSLog(@"Expecting '{' in FunctionBody, while we got a %@", t.text);
    }
    
    return nil;
}

/**
 * 解析函数调用
 * 语法规则：
 * functionCall : Identifier '(' parameterList? ')' ;
 * parameterList : StringLiteral (',' StringLiteral)* ;
 */
- (id)parseFunctionCall {
    NSMutableArray <Expression *> *params = [NSMutableArray array];
    Token *t = self.scanner.next;
    if (t.kind == TokenKindIdentifier) {
        Token *t1 = self.scanner.next;
        if (SEqual(t1.text, @"(")) {
            Token *t2 = self.scanner.peek;
            // 循环，取出所有的 params
            while(!SEqual(t2.text, @")")) {
                Expression *exp = [self parseExpression];
                if (exp) {
                    [params addObject:exp];
                } else {
                    NSLog(@"Expecting parameter in FunctionCall, while we got a %@", t2.text);
                    return nil;
                }
                
                t2 = self.scanner.peek;
                if (!SEqual(t2.text, @")")) {
                    if (SEqual(t2.text, @",")) {
                        t2 = self.scanner.next;
                    } else {
                        NSLog(@"Expecting parameter in FunctionCall, while we got a %@", t2.text);
                        return nil;
                    }
                }
            }
            
            // 消化掉一个括号：)
            [self.scanner next];
            return [[FunctionCall alloc] initWithName:t.text parameters:params];
        }
    }

    return nil;
}
/**
 * 解析变量声明
 * 语法规则：
 * variableDecl : 'let'? Identifier typeAnnotation？ ('=' singleExpression) ';';
 * typeAnnotation : ':' typeName;
 */
- (id)parseVariableDecl {
    [self.scanner next];
    Token *t = self.scanner.next;
    if (t.kind == TokenKindIdentifier) {
        NSString *varName = t.text;
        NSString *varType = @"any";
        Expression *initi = nil;
        
        Token *t1 = self.scanner.peek;
        // 解析类型 let varName:number;
        if (SEqual(t1.text, @":")) {
            [self.scanner next];
            t1 = self.scanner.peek;
            if (t1.kind == TokenKindIdentifier) {
                [self.scanner next];
                varType = t1.text;
                t1 = self.scanner.peek;
            } else {
                NSLog(@"Error parsing type annotation in VariableDecl");
                return nil;
            }
        }
        
        // 初始化部分
        if (SEqual(t1.text, @"=")) {
            [self.scanner next];
            initi = [self parseExpression];
        }
        
        t1 = self.scanner.peek;
        // 分号
        if (SEqual(t1.text, @";")) {
            [self.scanner next];
            return [[VariableDecl alloc] initWithName:varName varType:varType initi:initi];
        } else {
            NSLog(@"Expecting ; at the end of varaible declaration, while we meet %@", t1.text);
            return nil;
        }
    } else {
        NSLog(@"Expecting variable name in VariableDecl, while we meet %@", t.text);
        return nil;
    }
}

#pragma mark - private methods
#pragma mark 二元运算符的优先级
- (NSDictionary <NSString *, NSNumber *>*)opPrec {
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{
            @"=":@2,
            @"+=":@2,
            @"-=":@2,
            @"*=":@2,
            @"%=":@2,
            @"&=":@2,
            @"|=":@2,
            @"^=":@2,
            @"~=":@2,
            @"<<=":@2,
            @">>=":@2,
            @">>>=":@2,
            @"||":@4,
            @"&&":@5,
            @"|":@6,
            @"^":@7,
            @"&":@8,
            @"==":@9,
            @"===":@9,
            @"!=":@9,
            @"!==":@9,
            @">":@10,
            @">=":@10,
            @"<":@10,
            @"<=":@10,
            @"<<":@11,
            @">>":@11,
            @">>>":@11,
            @"+":@12,
            @"-":@12,
            @"*":@13,
            @"/":@13,
            @"%":@13,
        };
    });
    return map;
}

- (NSInteger)prec:(NSString *)op {
    NSNumber *p = [self opPrec][op];
    if (p) {
        return p.integerValue;
    }
    
    return -1;
}






@end
