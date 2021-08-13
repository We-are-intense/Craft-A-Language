//
//  Tokenizer.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "Tokenizer.h"
@interface Tokenizer ()

@property (nonatomic, copy) NSArray <Token *> *tokens;
@property (nonatomic, assign) NSUInteger pos;

@property (nonatomic, strong) CharStream *stream;
@property (nonatomic, strong) Token *nextToken;
@end

@implementation Tokenizer

- (instancetype)initWithTokens:(NSArray <Token *>*)tokens {
    self = [super init];
    if (self) {
        _tokens = [tokens copy];
    }
    return self;
}

- (instancetype)initWithStream:(CharStream *)stream {
    self = [super init];
    if (self) {
        _stream = stream;
        _nextToken = [Token createWithKind:TokenKindEOF text:@""];
    }
    return self;
}


- (Token *)next {
    // 在第一次的时候，先parse一个Token
    if (self.nextToken.kind == TokenKindEOF && !self.stream.eof) {
        self.nextToken = [self getAToken];
    }
    
    Token *last = self.nextToken;
    // 往前走一个Token
    self.nextToken = [self getAToken];
    return last;
}

- (Token *)peek {
    // 在第一次的时候，先parse一个Token
    if (self.nextToken.kind == TokenKindEOF && !self.stream.eof) {
        self.nextToken = [self getAToken];
    }
    return self.nextToken;
}


#pragma mark - private methods
#pragma mark 从字符串流中获取一个新Token
- (Token *)getAToken {
    // 跳过空白字符
    [self skipWhiteSpaces];
    
    if (self.stream.eof) {
        return [Token createWithKind:TokenKindEOF text:@""];
    }
    
    unichar ch = self.stream.peek;
    if ([self isLetter:ch] || [self isDigit:ch]) {
        return [self parseIdentifer];
    }
    
    if (ch == '"') {
        return [self parseStringLiteral];
    }
    
    if (ch == '(' || ch == ')' || ch == '{' ||
        ch == '}' || ch == ';' || ch == ',') {
        [self.stream next];
        return [Token createWithKind:TokenKindSeperator text:[NSString stringWithFormat:@"%c",ch]];
    }
    
    if (ch == '/') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '*') {
            // 多行注释 /**/
            [self skipMultipleLineComments];
            return [self getAToken];
        }
        
        if (ch1 == '/') {
            // 单行注释
            [self skipSingleLineComment];
            return [self getAToken];
        }
        
        if (ch1 == '=') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"/="];
        }
        
        return [Token createWithKind:TokenKindOperator text:@"/"];
    }
    
    if (ch == '+') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '+') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"++"];
        }
        if (ch1 == '=') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"+="];
        }
        return [Token createWithKind:TokenKindOperator text:@"+"];
    }
    if (ch == '-') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '-') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"--"];
        }
        if (ch1 == '=') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"-="];
        }
        return [Token createWithKind:TokenKindOperator text:@"-"];
    }
    
    if (ch == '*') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '=') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"*="];
        }
        return [Token createWithKind:TokenKindOperator text:@"*"];
    }
    // 暂时去掉不能识别的字符
    NSLog(@"Unrecognized pattern meeting line: %ld col: %ld", self.stream.line, self.stream.col);
    [self.stream next];
    return [self getAToken];
}
#pragma mark 解析标识符。从标识符中还要挑出关键字。
- (Token *)parseIdentifer {
    TokenKind kind = TokenKindIdentifier;
    NSString *text = @"";
    // 第一个字符不用判断，因为在调用者那里已经判断过了
    text = [text stringByAppendingFormat:@"%c", self.stream.next];
    // 读入后序字符
    while (!self.stream.eof &&
           [self isLetterDigitOrUnderScore:self.stream.peek]) {
        text = [text stringByAppendingFormat:@"%c", self.stream.next];
    }
    // 识别出关键字
    if ([text isEqualToString:@"function"]) {
        kind = TokenKindKeyword;
    }
    return [Token createWithKind:kind text:text];;
}
#pragma mark 解析标识符。从标识符中还要挑出关键字。
- (Token *)parseStringLiteral {
    TokenKind kind = TokenKindStringLiteral;
    NSString *text = @"";
    // 第一个字符不用判断，因为在调用者那里已经判断过了
    text = [text stringByAppendingFormat:@"%c", self.stream.next];
    // 读入后序字符
    while (!self.stream.eof &&
           self.stream.peek != '"') {
        text = [text stringByAppendingFormat:@"%c", self.stream.next];
    }
    // 识别出关键字
    if (self.stream.peek == '"') {
        [self.stream next];
    } else {
        NSLog(@"Expecting an \" at line: %ld col: %ld", self.stream.line, self.stream.col);
    }
    return [Token createWithKind:kind text:text];;
}

#pragma mark 跳过空白字符串
- (void)skipWhiteSpaces {
    while ([self isWhiteSpace:self.stream.peek]) {
        [self.stream next];
    }
}

- (BOOL)isWhiteSpace:(unichar)ch {
    return (ch == ' ' || ch == '\n' || ch == '\t');
}
#pragma mark 判断是否是字母 A-Z, a-z
- (BOOL)isLetter:(unichar)ch {
    return ((ch>='A' && ch <='Z') || (ch>= 'a' && ch <='z'));
}
#pragma mark 判断是否是数字 0-9
- (BOOL)isDigit:(unichar)ch {
    return (ch>='0' && ch <='9');
}
#pragma mark 判断是否是数字 0-9 或者 字母 A-Z, a-z
- (BOOL)isLetterDigitOrUnderScore:(unichar)ch {
    return ((ch>='A' && ch<='Z') ||
            (ch>='a' && ch<='z') ||
            (ch>='0' && ch<='9') ||
            ch== '_');
}

#pragma mark 跳过多行注释
- (void)skipMultipleLineComments {
    // 跳过*，/ 之前已经跳过去了。
    [self.stream next];
    if (!self.stream.eof) {
        unichar ch1 = self.stream.next;
        // 往后一直找到回车或者eof
        while (!self.stream.eof) {
            unichar ch2 = self.stream.next;
            if (ch1 == '*' && ch2 == '/') {
                // 找到了注释结束的标识
                return;
            }
            ch1 = ch2;
        }
    }
    //如果没有找到注释结束的标识，报错
    NSLog(@"Failed to find matching */ for multiple line comments at ': %ld col: %ld", self.stream.line, self.stream.col);
}
#pragma mark 跳过单行注释
- (void)skipSingleLineComment {
    // 跳过第二个 /
    [self.stream next];
    while (self.stream.peek != '\n' && !self.stream.eof) {
        [self.stream next];
    }
}

@end
