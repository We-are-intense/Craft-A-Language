//
//  main.m
//  play02
//
//  Created by 夏二飞 on 2021/8/11.
//

#import <Foundation/Foundation.h>
#import "Tokenizer.h"
#import "Parser.h"
//#import "RefResolver.h"
#import "Intepretor.h"
#import "CharStream.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        char fff[] = __FILE__;
        NSString *path = [NSString stringWithCString:fff encoding:NSUTF8StringEncoding];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[path componentsSeparatedByString:@"/"]];
        [array removeLastObject];
        [array addObject:@"program.js"];
        
        path = [array componentsJoinedByString:@"/"];
        
        NSString *program = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        if (!program) {
            return 0;
        }
        CharStream *stream = [[CharStream alloc] initWithData:program];
        // 词法分析
//        Tokenizer *tokenizer = [[Tokenizer alloc] initWithStream:stream];
//        Parser *parser = [[Parser alloc] initWithTokenizer:tokenizer];
//        // 语法分析
//        Prog *prog = [parser parseProg];
//        // 语义分析
//        [[RefResolver new] visitProg:prog];
//
//        // 运行程序
//        id retVal = [[Intepretor new] visitProg:prog];
//
//        NSLog(@"--------------- %@", retVal);
    }
    return 0;
}
