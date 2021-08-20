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
    while (t.kind == TokenKind.Operator && tprec > prec) {
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
    if (t.kind == TokenKind.Identifier) {
        if (SEqual(self.scanner.peek2.text, @"(")) {
            return [self parseFunctionCall];
        } else {
            [self.scanner next];
            return [[Variable alloc] initWithName:t.text];
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
/**
 * 解析函数声明
 * 语法规则：
 * functionDecl: "function" Identifier "(" ")"  functionBody;
 * 返回值为： FunctionDecl *，这里先写 id 类型
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
    
    
    
    
    
    
    
    // TODO: 下面的代码即将被删除
    if (token.kind == TokenKind.Identifier) {
        Token *t1 = self.scanner.next;
        if (t1.code == Seperator.OpenParen) { // '('
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
/**
 * 解析变量声明语句
 * variableStatement : 'let' variableDecl ';';
 */
- (id)parseVariableStatement {
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
/**
 * Return语句
 * 无论是否出错都会返回一个ReturnStatement。
 */
- (id)parseReturnStatement {
    return nil;
}

#pragma mark 解析函数体
/**
 * 解析函数体
 * 语法规则：
 * block : '{' statementList? '}' ;
*/
- (id)parseBlock {
    return nil;
}

#pragma mark 添加语法错误
- (void)addError:(NSString *)msg pos:(Position *)pos {
    
}
#pragma mark 添加语法报警
- (void)addWarning:(NSString *)msg pos:(Position *)pos {
    
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

- (void)skip:( NSArray <NSString *> * _Nullable )seperators {
    if (!seperators) { return; }
    
}




@end
