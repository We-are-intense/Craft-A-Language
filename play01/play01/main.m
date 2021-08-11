//
//  main.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import <Foundation/Foundation.h>
#import "Tokenizer.h"
#import "Parser.h"
#import "RefResolver.h"
#import "Intepretor.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray <Token *> *tokens = @[
            [Token createWithKind:Keyword text:@"function"],
            [Token createWithKind:Identifier text:@"sayHello"],
            [Token createWithKind:Seperator text:@"("],
            [Token createWithKind:Seperator text:@")"],
            [Token createWithKind:Seperator text:@"{"],
            [Token createWithKind:Identifier text:@"println"],
            [Token createWithKind:Seperator text:@"("],
            [Token createWithKind:StringLiteral text:@"Hello World!"],
            [Token createWithKind:Seperator text:@")"],
            [Token createWithKind:Seperator text:@";"],
            
            [Token createWithKind:Identifier text:@"}"],
            [Token createWithKind:Identifier text:@"sayHello"],
            [Token createWithKind:Seperator text:@"("],
            [Token createWithKind:Seperator text:@")"],
            [Token createWithKind:Seperator text:@";"],
            [Token createWithKind:End text:@""],
        ];
        // 词法分析
        Tokenizer *tokenizer = [[Tokenizer alloc] initWithTokens:tokens];
        Parser *parser = [[Parser alloc] initWithTokenizer:tokenizer];
        // 语法分析
        Prog *prog = [parser parseProg];
        // 语义分析
        [[RefResolver new] visitProg:prog];
        
        // 运行程序
        id retVal = [[Intepretor new] visitProg:prog];
        
        NSLog(@"--------------- %@", retVal);
    }
    return 0;
}
