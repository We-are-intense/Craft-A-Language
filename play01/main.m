//
//  main.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import <Foundation/Foundation.h>
#import "Tokenizer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray <Token *> *tokens = @[
            [Token createWithKind:Keyword text:@"function"],
            [Token createWithKind:Identifier text:@"Identifier"],
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
        
        Tokenizer *tokenizer = [[Tokenizer alloc] initWithTokens:tokens];
    }
    return 0;
}
