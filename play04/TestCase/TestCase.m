//
//  TestCase.m
//  TestCase
//
//  Created by 夏二飞 on 2021/8/24.
//

#import <XCTest/XCTest.h>
#import "Scanner.h"
#import "Prog.h"
#import "Parser.h"

@interface TestCase : XCTestCase

@end

@implementation TestCase

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    char fff[] = __FILE__;
    NSString *path = [NSString stringWithCString:fff encoding:NSUTF8StringEncoding];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[path componentsSeparatedByString:@"/"]];
    [array removeLastObject];
    [array addObject:@"program.js"];
    
    path = [array componentsJoinedByString:@"/"];
    
    NSString *program = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (!program) {
        return;
    }
    CharStream *stream = [[CharStream alloc] initWithData:program];
    // 词法分析
    Scanner *tokenizer = [[Scanner alloc] initWithStream:stream];
    Parser *parser = [[Parser alloc] initWithScanner:tokenizer];
    
    
    // 语法分析
    Prog *prog = [parser parseProg];
    NSLog(@"-------");
    
}

- (void)testThree {
    NSString *program = @"";
    CharStream *stream = [[CharStream alloc] initWithData:program];
    // 词法分析
    Scanner *tokenizer = [[Scanner alloc] initWithStream:stream];
    Parser *parser = [[Parser alloc] initWithScanner:tokenizer];
    
    
    // 语法分析
    Prog *prog = [parser parseProg];
    
    
}


@end
