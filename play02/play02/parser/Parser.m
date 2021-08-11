//
//  Parser.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "Parser.h"
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
    Token *token = self.tokenizer.peek;
    while (token.kind != End) {
        if (token.kind == Keyword && [token.text isEqualToString:@"function"]) {
            // 这是一个函数声明
            stmt = [self parseFunctionDecl];
        } else if(token.kind == Identifier) {
            // 尝试 函数调用
            stmt = [self parseFunctionCall];
        }
        
        if (stmt != nil) {
            [stmts addObject:stmt];
        }
        
        token = self.tokenizer.peek;
    }
        
    return [[Prog alloc] initWithStmts:stmts];
}

/**
 * 解析函数声明
 * 语法规则：
 * functionDecl: "function" Identifier "(" ")"  functionBody;
 */
- (FunctionDecl *)parseFunctionDecl {
    // 跳过关键字'function'
    [self.tokenizer next];
    Token *token = self.tokenizer.next;
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
- (FunctionBody *)parseFunctionBody {
    NSMutableArray <FunctionCall *> *stmts = [NSMutableArray array];
    Token *t = self.tokenizer.next;
    if ([t.text isEqualToString:@"{"]) {
        while (self.tokenizer.peek.kind == Identifier) {
            FunctionCall *call = [self parseFunctionCall];
            if (call) {
                [stmts addObject:call];
            } else {
                NSLog(@"Error parsing a FunctionCall in FunctionBody.");
                return nil;
            }
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
    
    return nil;
}

/**
 * 解析函数调用
 * 语法规则：
 * functionCall : Identifier '(' parameterList? ')' ;
 * parameterList : StringLiteral (',' StringLiteral)* ;
 */
- (FunctionCall *)parseFunctionCall {
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

    return nil;
}

@end
