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
    statement:  block
                | expressionStatement
                | returnStatement
                | ifStatement
                | forStatement
                | emptyStatement
                | functionDecl
                | variableDecl ;
    
    block : '{' statementList? '}' ;

    ifStatement : 'if' '(' expression ')' statement ('else' statement)? ;
    forStatement : 'for' '(' (expression | 'let' variableDecl)? ';' expression? ';' expression? ')' statement ;
    
    variableStatement : 'let' variableDecl ';';
    variableDecl : Identifier typeAnnotation？ ('=' expression)? ;
    typeAnnotation : ':' typeName;
    
    functionDecl: "function" Identifier callSignature  block ;
    callSignature: '(' parameterList? ')' typeAnnotation? ;
    returnStatement: 'return' expression? ';' ;
    
    emptyStatement: ';' ;
 
    expressionStatement: expression ';' ;
    expression: assignment;
    assignment: binary (assignmentOp binary)* ;
    binary: unary (binOp unary)* ;
    unary: primary | prefixOp unary | primary postfixOp ;
    primary: StringLiteral | DecimalLiteral | IntegerLiteral | functionCall | '(' expression ')' ;
 
 
    assignmentOp: '=' | '+=' | '-=' | '*=' | '/=' | '>>=' | '<<=' | '>>>=' | '^=' | '|=' ;
   
    binOp: '+' | '-' | '*' | '/' | '==' | '!=' | '<=' | '>=' | '<'
         | '>' | '&&'| '||'|...;
    prefixOp = '+' | '-' | '++' | '--' | '!' | '~';
    postfixOp = '++' | '--';
    functionCall : Identifier '(' argumentList? ')' ;
    argumentList : expression (',' expression)* ;
 
 */



#import "Parser.h"
#import "FunctionDecl.h"
#import "FunctionCall.h"
#import "FunctionBody.h"
#import "TokenKind.h"
#import "Keyword.h"
#import "Seperator.h"
#import "CallSignature.h"
#import "Op.h"
#import "SysTypes.h"
#import "VariableStatement.h"
#import "Unary.h"

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

/*
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
    
    while (t.kind != TokenKind.EOFF && !SEqual(t.text, @"}")) {
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
    if (t.code == Keyword.Function) {
        return [self parseFunctionDecl];
    } else if(t.code == Keyword.Let) {
        return [self parseVariableStatement];
    } else if (t.code == Keyword.Return) {
        return [self parseReturnStatement];
    } else if (t.code == Seperator.OpenBrace) {
        // '{'
        return [self parseBlock];
    } else if (t.kind == TokenKind.Identifier ||
               t.kind == TokenKind.DecimalLiteral ||
               t.kind == TokenKind.IntegerLiteral ||
               t.kind == TokenKind.StringLiteral ||
               t.code == Seperator.OpenParen) { // '('
        return [self parseExpressionStatement];
    }
    
    NSLog(@"Can not recognize a expression starting with: %@", self.scanner.peek.text);
    return nil;
}
#pragma mark 解析表达式
- (Expression *)parseExpression {
    return [self parseAssignment];
}
#pragma mark 解析赋值表达式
/*
 * 解析赋值表达式。
 * 注意：赋值表达式是右结合的。
 */
- (id)parseAssignment {
    NSInteger assignPrec = [self prec:Op.Assign];
    // 先解析一个优先级更高的表达式
    Expression *exp1 = [self parseBinary:assignPrec];
    Token *t = self.scanner.peek;
    NSInteger tprec = [self prec:t.code];
    // 存放赋值运算符两边的表达式
    NSMutableArray <Expression *> *expStack = [NSMutableArray array];
    [expStack addObject:exp1];
    // 存放赋值运算符
    NSMutableArray <NSNumber *> *opStack = [NSMutableArray array];
    
    // 解析赋值表达式
    while (t.kind == TokenKind.Operator && tprec == assignPrec) {
        [opStack addObject:@(t.code)];
        // 跳过运算符
        [self.scanner next];
        // 获取运算符优先级高于assignment的二元表达式
        exp1 = [self parseBinary:assignPrec];
        [expStack addObject:exp1];
        t = self.scanner.peek;
        tprec = [self prec:t.code];
    }
    // 组装成右结合的AST
    exp1 = expStack[expStack.count - 1];
    if (opStack.count > 0) {
        for (NSInteger i = expStack.count - 2; i >= 0; i --) {
            exp1 = [[Binary alloc] initWithOp:opStack[i].integerValue exp1:expStack[i] exp2:exp1];
        }
    }
    return exp1;
}
#pragma mark 解析表达式语句
- (ExpressionStatement *)parseExpressionStatement {
    Expression *exp = [self parseExpression];
    if (!exp) {
        NSLog(@"Error parsing ExpressionStatement");
        return nil;
    }
    ExpressionStatement *stmt = [[ExpressionStatement alloc] initWithEndPos:self.scanner.getLastPos isErrorNode:NO exp:exp];
    Token *t = self.scanner.peek;
    if (t.code == Seperator.SemiColon) { // ';'
        [self.scanner next];
    } else {
        [self addError:[NSString stringWithFormat:@"Expecting a semicolon at the end of an expresson statement, while we got a %@", t.text] pos:self.scanner.getLastPos];
        stmt.endPos = self.scanner.getLastPos;
        stmt.isErrorNode = YES;
    }
    return stmt;
}
#pragma mark 解析二元表达式
/**
 * 采用运算符优先级算法，解析二元表达式。
 * 这是一个递归算法。一开始，提供的参数是最低优先级，
 *
 * @param prec 当前运算符的优先级
 */
- (Expression *)parseBinary:(NSInteger)prec {
    Expression *exp1 = [self parseUnary];
    if (!exp1) {
        NSLog(@"Can not recognize a expression starting with: %@", self.scanner.peek.text);
        return nil;
    }
    
    Token *t = self.scanner.peek;
    NSInteger tprec = [self prec:t.code];
    // 下面这个循环的意思是：只要右边出现的新运算符的优先级更高，
    // 那么就把右边出现的作为右子节点。
    /*
     * 对于2+3*5
     * 第一次循环，遇到+号，优先级大于零，所以做一次递归的binary
     * 在递归的binary中，遇到乘号，优先级大于+号，所以形成3*5返回，又变成上一级的右子节点。
     *
     * 反过来，如果是3*5+2
     * 第一次循环还是一样。
     * 在递归中，新的运算符的优先级要小，所以只返回一个5，跟前一个节点形成3*5.
     */
    while (t.kind == TokenKind.Operator && tprec > prec) {
        [self.scanner next]; // 跳过运算符
        Expression *exp2 = [self parseBinary:tprec];
        if (exp2) {
            Binary *exp = [[Binary alloc] initWithOp:t.code exp1:exp1 exp2:exp2];
            exp1 = exp;
            t = self.scanner.peek;
            tprec = [self prec:t.code];
        } else {
            NSLog(@"Can not recognize a expression starting with: %@", t.text);
        }
    }
    return exp1;
}
#pragma mark 解析一元运算
/*
 * 解析一元运算
 * unary: primary | prefixOp unary | primary postfixOp ;
 * primary: StringLiteral | DecimalLiteral | IntegerLiteral | functionCall | '(' expression ')' ;
 * prefixOp = '+' | '-' | '++' | '--' | '!' | '~';
 * postfixOp = '++' | '--';
 */
- (id)parseUnary {
    Position *beginPos = self.scanner.getNextPos;
    Token *t = self.scanner.peek;
    // 前缀的一元表达式 prefixOp unary
    if (t.kind == TokenKind.Operator) {
        [self.scanner next]; // 跳过运算符
        Expression *exp = [self parseUnary];
        return [[Unary alloc] initWithBeginPos:beginPos
                                        endPos:self.scanner.getLastPos
                                   isErrorNode:NO
                                            op:t.code
                                           exp:exp
                                      isPrefix:YES];
    } else {
        // 后缀只能是 ++ 或 --
        // 首先解析一个primary
        Expression *exp = [self parsePrimary];
        Token *t1 = self.scanner.peek;
        // --, ++
        if (t1.kind == TokenKind.Operator && (t1.code == Op.Inc || t1.code == Op.Dec)) {
            [self.scanner next]; // 跳过运算符
            return [[Unary alloc] initWithBeginPos:beginPos
                                            endPos:self.scanner.getLastPos
                                       isErrorNode:NO
                                                op:t.code
                                               exp:exp
                                          isPrefix:NO];
        } else {
            return exp;
        }
    }
    
    return nil;
}


#pragma mark 解析基础表达式 TODO
- (Expression *)parsePrimary {
    Position *beginPos = self.scanner.getNextPos;
    Token *t = self.scanner.peek;
    //知识点：以Identifier开头，可能是函数调用，也可能是一个变量，所以要再多向后看一个Token，
    //这相当于在局部使用了LL(2)算法。
    if (t.kind == TokenKind.Identifier) {
        if (self.scanner.peek2.code == Seperator.OpenParen) { // "("
            return [self parseFunctionCall];
        } else {
            [self.scanner next];
            return [[Variable alloc] initWithBeginPos:beginPos
                                               endPos:self.scanner.getLastPos
                                          isErrorNode:NO
                                                 name:t.text];
        }
    } else if(t.kind == TokenKind.IntegerLiteral) {
        [self.scanner next];
        return [[IntegerLiteral alloc] initWithValue:@(t.text.integerValue)];
    } else if (t.kind == TokenKind.DecimalLiteral) {
        [self.scanner next];
        return [[DecimalLiteral alloc] initWithValue:@(t.text.floatValue)];
    } else if (t.kind == TokenKind.StringLiteral) {
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
/*
 * 解析函数声明
 * 语法规则：
 * functionDecl: "function" Identifier callSignature  block ;
 * callSignature: '(' parameterList? ')' typeAnnotation? ;
 * parameterList : parameter (',' parameter)* ;
 * parameter : Identifier typeAnnotation? ;
 * block : '{' statementList? '}' ;
 * 返回值：
 * null-意味着解析过程出错。
 */
- (id)parseFunctionDecl {
    Position *beginPos = self.scanner.getNextPos;
    BOOL isErrorNode   = NO;
    // 跳过关键字'function'
    [self.scanner next];
    Token *token = self.scanner.next;
    if (token.kind != TokenKind.Identifier) {
        [self addError:[NSString stringWithFormat:@"Expecting a function name, while we got a %@", token.text] pos:self.scanner.getLastPos];
        [self skip:nil];
        isErrorNode = YES;
    }
    
    // 开始解析参数列表
    CallSignature *callSignature = nil;
    Token *t1 = self.scanner.peek;
    if (t1.code == Seperator.OpenParen) {
        // '('
        callSignature = [self parseCallSignature];
    } else {
        [self addError:[NSString stringWithFormat:@"Expecting '(' in FunctionDecl, while we got a %@", t1.text] pos:self.scanner.getLastPos];
        [self skip:nil];
        callSignature = [[CallSignature alloc] initWithBeginPos:beginPos
                                                endPos:self.scanner.getLastPos
                                           isErrorNode:YES
                                             paramList:nil
                                                  type:nil];
    }
    
    // 开始解析函数体
    Block *functionBody = nil;
    t1 = self.scanner.peek;
    if (t1.code == Seperator.OpenBrace) { // '{'
        functionBody = [self parseBlock];
    } else {
        [self addError:[NSString stringWithFormat:@"Expecting '{' in FunctionDecl, while we got a %@", t1.text] pos:self.scanner.getLastPos];
        [self skip:nil];
        functionBody = [[Block alloc] initWithBeginPos:beginPos endPos:self.scanner.getLastPos isErrorNode:YES stmts:nil];
    }
    
    return [[FunctionDecl alloc] initWithBeginPos:beginPos
                                           endPos:self.scanner.getLastPos
                                      isErrorNode:NO
                                             name:token.text
                                             body:functionBody
                                    callSignature:callSignature];
}
#pragma mark 解析函数调用 TODO
/*
 * 解析函数调用
 * 语法规则：
 * functionCall : Identifier '(' parameterList? ')' ;
 * parameterList : StringLiteral (',' StringLiteral)* ;
 */
- (id)parseFunctionCall {
    NSMutableArray <Expression *> *params = [NSMutableArray array];
    Token *t = self.scanner.next;
    if (t.kind == TokenKind.Identifier) {
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
#pragma mark 解析变量声明语句
/*
 * 解析变量声明语句
 * variableStatement : 'let' variableDecl ';';
 * variableDecl : Identifier typeAnnotation？ ('=' expression)? ;
 * typeAnnotation : ':' typeName;
 */
- (id)parseVariableStatement {
    Position *beginPos = self.scanner.getNextPos;
    BOOL isErrorNode = NO;
    
    [self.scanner next];// 跳过'let'
    VariableDecl *var = [self parseVariableDecl];
    
    Token *t = self.scanner.peek;
    if (t.code == Seperator.SemiColon) {
        // 分号 ';'，结束变量声明
        [self.scanner next];
    } else {
        [self skip:nil];
        isErrorNode = YES;
    }
    
    return [[VariableStatement alloc] initWithBeginPos:beginPos
                                                endPos:self.scanner.getLastPos
                                           isErrorNode:isErrorNode
                                          variableDecl:var];
}

#pragma mark 解析变量声明 TODO
/*
 * 解析变量声明
 * 语法规则：
 * variableDecl : 'let'? Identifier typeAnnotation？ ('=' singleExpression) ';';
 * typeAnnotation : ':' typeName;
 */
- (id)parseVariableDecl {
    [self.scanner next];
    Token *t = self.scanner.next;
    if (t.kind == TokenKind.Identifier) {
        NSString *varName = t.text;
        NSString *varType = @"any";
        Expression *initi = nil;
        
        Token *t1 = self.scanner.peek;
        // 解析类型 let varName:number;
        if (SEqual(t1.text, @":")) {
            [self.scanner next];
            t1 = self.scanner.peek;
            if (t1.kind == TokenKind.Identifier) {
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
#pragma mark Return语句
/*
 * Return语句
 * 无论是否出错都会返回一个ReturnStatement。
 */
- (id)parseReturnStatement {
    Position *beginPos = self.scanner.getNextPos;
    Expression *exp = nil;
    // 跳过'return'
    [self.scanner next];
    // 解析后面的表达式
    Token *t = self.scanner.peek;
    if (t.code != Seperator.SemiColon) { // ';'
        exp = [self parseExpression];
    }
    
    // 跳过';'
    t = self.scanner.peek;
    if (t.code == Seperator.SemiColon) {
        [self.scanner next];
    } else {
        [self addError:@"Expecting ';' after return statement." pos:self.scanner.getLastPos];
    }
    return [[ReturnStatement alloc] initWithBeginPos:beginPos
                                              endPos:self.scanner.getLastPos
                                         isErrorNode:NO
                                                 exp:exp];
}

#pragma mark 解析函数体
/*
 * 解析函数体
 * 语法规则：
 * block : '{' statementList? '}' ;
*/
- (id)parseBlock {
    Position *beginPos = self.scanner.getNextPos;
    [self.scanner next];// 跳过 '{'
    NSArray <Statement *> *stmts = [self parseStatementList];
    Token *t = self.scanner.peek;
    if (t.code == Seperator.CloseBrace) { // '}'
        [self.scanner next];// 跳过 '}'
        return [[Block alloc] initWithBeginPos:beginPos
                                        endPos:self.scanner.getLastPos
                                   isErrorNode:NO
                                         stmts:stmts];
    }
    
    [self addError:[NSString stringWithFormat:@"Expecting '}' while parsing a block, but we got a %@", t.text] pos:self.scanner.getLastPos];
    [self skip:nil];
    return [[Block alloc] initWithBeginPos:beginPos
                                    endPos:self.scanner.getLastPos
                               isErrorNode:YES
                                     stmts:nil];
}

#pragma mark 解析函数签名
/*
 * callSignature: '(' parameterList? ')' typeAnnotation? ;
 * typeAnnotation : ':' typeName;
 */
- (id)parseCallSignature {
    Position *beginPos = self.scanner.getNextPos;
    ParameterList *paramList = nil;
    // 跳过 '('
    Token *t = self.scanner.next;
    if (self.scanner.peek.code != Seperator.CloseParen) { // ')'
        paramList = [self parseParameterList];
    }
    
    t = self.scanner.peek;
    // 看看后面是不是 ')'
    if (t.code == Seperator.CloseParen) {
        [self.scanner next]; // 跳过 ')'
        NSString *type = @"any";
        if (self.scanner.peek.code == Seperator.Colon) {
            // 如果是 ':'
            type = [self parseTypeAnnotation];
        }
        return [[CallSignature alloc] initWithBeginPos:beginPos
                                                endPos:self.scanner.getLastPos
                                           isErrorNode:NO
                                             paramList:paramList
                                                  type:[self parseType:type]];
    } else {
        // 不是，说明有了问题
        [self addError:@"Expecting a ')' after for a call signature" pos:self.scanner.getLastPos];
        return [[CallSignature alloc] initWithBeginPos:beginPos
                                                endPos:self.scanner.getLastPos
                                           isErrorNode:YES
                                             paramList:paramList
                                                  type:nil];
    }
    return nil;
}
#pragma mark 解析参数列表
/*
 * parameterList : parameter (',' parameter)* ;
 * parameter : Identifier ':' Identifier;
 */
- (id)parseParameterList {
    Position *beginPos = self.scanner.getNextPos;
    NSMutableArray <VariableDecl *> *params = [NSMutableArray array];
    BOOL isErrorNode = NO;
    Token *t = self.scanner.peek;
    while (t.code != Seperator.CloseParen && t.kind != TokenKind.EOFF) {
        if (t.kind == TokenKind.Identifier) {
            [self.scanner  next];
            Token *t1 = self.scanner.peek;
            NSString *type = @"any";
            if (t1.code == Seperator.Colon) { // ':'
                type = [self parseTypeAnnotation];
            }
            
            VariableDecl *var = [[VariableDecl alloc] initWithBeginPos:beginPos endPos:self.scanner.getLastPos isErrorNode:isErrorNode name:t.text varType:type initi:nil];
            [params addObject:var];
            
            t = self.scanner.peek;
            if (t.code != Seperator.CloseParen) { // ')'
                if (t.code == Op.Comma) { // ','
                    [self.scanner next]; // 跳过 ','
                    t = self.scanner.peek;
                } else {
                    [self addError:@"Expecting a ',' or '）' after a parameter" pos:self.scanner.getLastPos];
                    [self skip:nil];
                    isErrorNode = YES;
                    Token *t2 = self.scanner.peek;
                    if (t2.code == Op.Comma) {
                        [self.scanner next];
                        t = self.scanner.next;
                    } else {
                        break;
                    }
                }
            }
        } else {
            [self addError:@"Expecting an identifier as name of a Parameter" pos:self.scanner.getLastPos];
            [self skip:nil];
            isErrorNode = YES;
            Token *t2 = self.scanner.peek;
            if (t2.code == Op.Comma) {
                [self.scanner next];
                t = self.scanner.next;
            } else {
                break;
            }
        }
    }
    return [[ParameterList alloc] initWithBeginPos:beginPos endPos:self.scanner.getLastPos isErrorNode:isErrorNode params:params];
}
#pragma mark 解析类型注解
/*
 * 无论是否出错，都会返回一个类型。缺省类型是'any'。
 */
- (NSString *)parseTypeAnnotation {
    NSString *type = @"any";
    // 跳过:
    [self.scanner  next];
    Token *t = self.scanner.peek;
    if (t.kind == TokenKind.Identifier) {
        [self.scanner  next];
        type = t.text;
    } else {
        [self addError:@"Expecting a type name in type annotation" pos:self.scanner.getLastPos];
    }
    return type;
}


#pragma mark 添加语法错误
- (void)addError:(NSString *)msg pos:(Position *)pos {
    
}
#pragma mark 添加语法报警
- (void)addWarning:(NSString *)msg pos:(Position *)pos {
    
}

#pragma mark - private methods
#pragma mark 二元运算符的优先级
- (NSDictionary <NSNumber *, NSNumber *>*)opPrec {
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{
            @(Op.Assign):@2,
            @(Op.PlusAssign):@2,
            @(Op.MinusAssign):@2,
            @(Op.MultiplyAssign):@2,
            @(Op.DivideAssign):@2,
            @(Op.ModulusAssign):@2,
            @(Op.BitAndAssign):@2,
            @(Op.BitOrAssign):@2,
            @(Op.BitXorAssign):@2,
            @(Op.LeftShiftArithmeticAssign):@2,
            @(Op.RightShiftArithmeticAssign):@2,
            @(Op.RightShiftLogicalAssign):@2,
            @(Op.Or):@4,
            @(Op.And):@5,
            @(Op.BitOrr):@6,
            @(Op.BitXOr):@7,
            @(Op.BitAndd):@8,
            @(Op.EQ):@9,
            @(Op.IdentityEquals):@9,
            @(Op.NE):@9,
            @(Op.IdentityNotEquals):@9,
            @(Op.G):@10,
            @(Op.GE):@10,
            @(Op.L):@10,
            @(Op.LE):@10,
            @(Op.LeftShiftArithmetic):@11,
            @(Op.RightShiftArithmetic):@11,
            @(Op.RightShiftLogical):@11,
            @(Op.Plus):@12,
            @(Op.Minus):@12,
            @(Op.Divide):@13,
            @(Op.Multiply):@13,
            @(Op.Modulus):@13,
        };
    });
    return map;
}

- (NSInteger)prec:(NSInteger)op {
    NSNumber *p = [self opPrec][@(op)];
    if (p) {
        return p.integerValue;
    }
    
    return -1;
}
#pragma mark skip TODO
- (void)skip:( NSArray <NSString *> * _Nullable )seperators {
    if (!seperators) { return; }
    
}

- (Type *)parseType:(NSString *)typeName {
    
    if (SEqual(typeName, @"any")) {
        return SysTypes.Any;
    } else if (SEqual(typeName, @"number")) {
        return SysTypes.Number;
    } else if (SEqual(typeName, @"boolean")) {
        return SysTypes.Boolean;
    } else if (SEqual(typeName, @"string")) {
        return SysTypes.String;
    } else if (SEqual(typeName, @"undefined")) {
        return SysTypes.Undefined;
    } else if (SEqual(typeName, @"null")) {
        return SysTypes.Null;
    } else if (SEqual(typeName, @"void")) {
        return SysTypes.Undefined;
    }
    
    [self addError:[NSString stringWithFormat:@"Unrecognized type: %@", typeName] pos:self.scanner.getLastPos];
    
    return SysTypes.Any;
}


@end
