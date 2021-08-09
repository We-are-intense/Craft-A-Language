//
//  Parser.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "Parser.h"
#import "Prog.h"
#import "FunctionDecl.h"
#import "FunctionCall.h"
#import "FunctionBody.h"

@interface Parser ()

@property (nonatomic, strong) Tokenizer *tokenizer;

@end

@implementation Parser
- (instancetype)initWithTokenizer:(Tokenizer *)tokenizer {
    self = [super init];
    if (self) {
        _tokenizer = tokenizer;
    }
    return self;
}
/**
 * 解析Prog
 * 语法规则：
 * prog = (functionDecl | functionCall)* ;
 */
- (Prog *)parseProg {
    
    NSMutableArray <Statement *> *stmts = [NSMutableArray array];
    Statement *stmt = nil;
    
    while (true) {// 每次循环解析一个语句
        // 尝试一下函数声明
        stmt = [self parseFunctionDecl];
        if (stmt != nil) {
            [stmts addObject:stmt];
            continue;
        }
        // 如果前一个尝试不成功，那么再尝试一下函数调用
        stmt = [self parseFunctionCall];
        if (stmt != nil) {
            [stmts addObject:stmt];
            continue;
        }
        
        // 如果都没成功，那就结束
        if (stmt == nil) {
            break;
        }
    }
    
    return [[Prog alloc] initWithStmts:stmts];
}




/**
 * 解析函数声明
 * 语法规则：
 * functionDecl: "function" Identifier "(" ")"  functionBody;
 */
- (FunctionDecl *)parseFunctionDecl {
    NSUInteger oldPos = self.tokenizer.position;
    Token *token = self.tokenizer.next;
    
    if (token.kind == Keyword && [token.text isEqualToString:@"function"]) {
        token = self.tokenizer.next;
        if (token.kind == Identifier) {
            Token *t1 = self.tokenizer.next;
            if ([t1.text isEqualToString:@"("]) {
                Token *t2 = self.tokenizer.next;
                if ([t2.text isEqualToString:@")"]) {
                    FunctionBody *body = [self parseFunctionBody];
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
        }
    }
    
    // 如果解析不成功，回溯，返回null。
    [self.tokenizer traceBack:oldPos];
    
    return nil;
}
/**
 * 解析函数体
 * 语法规则：
 * functionBody : '{' functionCall* '}' ;
 */
- (FunctionBody *)parseFunctionBody {
    NSUInteger oldPos = self.tokenizer.position;
    NSMutableArray <FunctionCall *> *stmts = [NSMutableArray array];
    Token *t = self.tokenizer.next;
    if ([t.text isEqualToString:@"{"]) {
        FunctionCall *call = [self parseFunctionCall];
        while (call != nil) {// 解析函数体
            [stmts addObject:call];
            call = [self parseFunctionCall];
        }
        
        t = self.tokenizer.next;
        if ([t.text isEqualToString:@"}"]) {
            return [[FunctionBody alloc] initWithStmts:stmts];
        } else {
            NSLog(@"Expecting '}' in FunctionBody, while we got a %@", t.text);
            return nil;
        }
    } else {
        NSLog(@"Expecting '{' in FunctionBody, while we got a %@", t.text);
    }
    // 如果解析不成功，回溯，返回null。
    [self.tokenizer traceBack:oldPos];
    
    return nil;
}

/**
 * 解析函数调用
 * 语法规则：
 * functionCall : Identifier '(' parameterList? ')' ;
 * parameterList : StringLiteral (',' StringLiteral)* ;
 */
- (FunctionCall *)parseFunctionCall {
    NSUInteger oldPos = self.tokenizer.position;
    NSMutableArray <NSString *> *params = [NSMutableArray array];
    Token *t = self.tokenizer.next;
    if (t.kind == Identifier) {
        Token *t1 = self.tokenizer.next;
        if ([t1.text isEqualToString:@"("]) {
            Token *t2 = self.tokenizer.next;
            // 循环，取出所有的 params
            while(![t2.text isEqualToString:@")"]) {
                if (t2.kind == StringLiteral) {
                    [params addObject:t2.text];
                } else {
                    NSLog(@"Expecting parameter in FunctionCall, while we got a %@", t2.text);
                    return nil;
                }
                
                t2 = self.tokenizer.next;
                if (![t2.text isEqualToString:@")"]) {
                    if ([t2.text isEqualToString:@","]) {
                        t2 = self.tokenizer.next;
                    } else {
                        NSLog(@"Expecting parameter in FunctionCall, while we got a %@", t2.text);
                        return nil;
                    }
                }
            }
            
            t2 = self.tokenizer.next;
            // 消化掉一个分号：;
            if ([t2.text isEqualToString:@";"]) {
                return [[FunctionCall alloc] initWithName:t.text parameters:params];
            } else {
                NSLog(@"Expecting parameter in FunctionCall, while we got a %@", t2.text);
            }
        }
    }
    // 如果解析不成功，回溯，返回null。
    [self.tokenizer traceBack:oldPos];
    return nil;
}

@end
