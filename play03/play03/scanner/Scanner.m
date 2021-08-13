//
//  scanner.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Scanner.h"
#import "NSMutableArray+GetSafe.h"

@interface Scanner ()

@property (nonatomic, strong) NSMutableArray <Token *> *tokens;

@end

@implementation Scanner

- (instancetype)initWithStream:(CharStream *)stream {
    self = [super init];
    if (self) {
        _stream = stream;
        _tokens = [NSMutableArray array];
    }
    return self;
}

- (Token *)next {
    Token *t = self.tokens.shift;
    if (t == nil) {
        return [self getAToken];
    } else {
        return t;
    }
}

- (Token *)peek {
    Token *t = self.tokens[0];
    if (t == nil) {
        t = [self getAToken];
        NSAssert(t, @"peek token 不能为 nil");
        [self.tokens addObject:t];
    }
    return t;
}

- (Token *)peek2 {
    Token *t = self.tokens[1];
    while (t == nil) {
        Token *t1 = [self getAToken];
        NSAssert(t1, @"peek2 token 不能为 nil");
        [self.tokens addObject:t1];
        t = self.tokens[1];
    }
    return t;
}

#pragma mark - private methods
#pragma mark 从字符串流中获取一个新Token
- (Token *)getAToken {
    // 跳过空白字符
    [self skipWhiteSpaces];
    // 遇到结束符
    if (self.stream.eof) {
        return [Token createWithKind:TokenKindEOF text:@""];
    }

    unichar ch = self.stream.peek;
    if ([self isLetter:ch] || ch == '_') {
        return [self parseIdentifer];
    }
    
    if (ch == '"') {
        return [self parseStringLiteral];
    }
    
    if (ch == '(' || ch == ')' || ch == '{' || ch == '}' || ch == '[' || ch == ']' ||
        ch == ',' || ch == ';' || ch == ':' || ch == '?' || ch == '@') { // @ 为装饰器
        [self.stream next];
        return [Token createWithKind:TokenKindSeperator text:[NSString stringWithFormat:@"%c",ch]];
    }
    

    /*
     解析数字字面量，语法是：
      DecimalLiteral:   IntegerLiteral '.' [0-9]*
                        | '.' [0-9]+
                        | IntegerLiteral
                        ;
      IntegerLiteral:   '0'
                        | [1-9] [0-9]* ;
     */
    if ([self isDigit:ch]) {
        [self.stream next];
        
        unichar ch1 = self.stream.peek;
        NSMutableString *literal = [NSMutableString stringWithString:@""];
        if (ch == '0') { //暂不支持八进制、二进制、十六进制
            if (!(ch1 >= 1 && ch1 <= '9')) {
                [literal appendString:@"0"];
            } else {
                NSLog(@"0 cannot be followed by other digit now, at line: %ld col: %ld", self.stream.line, self.stream.col);
                // 暂时先跳过去
                return [self getAToken];
            }
        } else if( ch >= '1' && ch <= '9' ) {
            [literal appendFormat:@"%c", ch];
            while ([self isDigit:ch1]) {
                ch = self.stream.next;
                [literal appendFormat:@"%c", ch];
                ch1 = self.stream.peek;
            }
        }
        // 加上小数点.
        if (ch1 == '.') {
            [literal appendString:@"."];
            [self.stream next];
            
            ch1 = self.stream.peek;
            while ([self isDigit:ch1]) {
                ch = self.stream.next;
                [literal appendFormat:@"%c", ch];
                ch1 = self.stream.peek;
            }
            // 返回一个小数
            return [Token createWithKind:TokenKindDecimalLiteral text:literal];
        } else {
            // 返回一个整型数
            return [Token createWithKind:TokenKindIntegerLiteral text:literal];
        }
    }
    
    if (ch == '.') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        // 判断是不是小数
        if ([self isDigit:ch1]) {
            NSMutableString *literal = [NSMutableString stringWithString:@"."];
            while ([self isDigit:ch1]) {
                ch = self.stream.next;
                [literal appendFormat:@"%c", ch];
                ch1 = self.stream.peek;
            }
            // 返回一个小数
            return [Token createWithKind:TokenKindDecimalLiteral text:literal];
        } else if(ch1 == '.') {
            // ... 省略号
            [self.stream next];
            
            ch1 = self.stream.peek;
            if (ch1 == '.') {
                return [Token createWithKind:TokenKindSeperator text:@"..."];
            } else {
                NSLog(@"Unrecognized pattern : .., missed a . ?");
                return [self getAToken];
            }
        } else {
            // . 号分隔符   如：this.value
            return [Token createWithKind:TokenKindSeperator text:@"."];
        }
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
    
    if (ch == '%') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '=') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"%="];
        } else {
            return [Token createWithKind:TokenKindOperator text:@"%"];
        }
    }
    
    if (ch == '>') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '=') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@">="];
        } else if (ch1 == '>') {
            [self.stream next];
            ch1 = self.stream.peek;
            if (ch1 == '>') {
                [self.stream next];
                ch1 = self.stream.peek;
                if (ch1 == '=') {
                    [self.stream next];
                    return [Token createWithKind:TokenKindOperator text:@">>>="];
                } else {
                    return [Token createWithKind:TokenKindOperator text:@">>>"];
                }
            } else if (ch1 == '=') {
                [self.stream next];
                return [Token createWithKind:TokenKindOperator text:@">>="];
            } else {
                return [Token createWithKind:TokenKindOperator text:@">>"];
            }
        } else {
            return [Token createWithKind:TokenKindOperator text:@">"];
        }
    }
    
    if (ch == '<') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '=') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"<="];
        } else if (ch1 == '<') {
            [self.stream next];
            ch1 = self.stream.peek;
            if (ch1 == '=') {
                [self.stream next];
                return [Token createWithKind:TokenKindOperator text:@"<<="];
            } else {
                return [Token createWithKind:TokenKindOperator text:@"<<"];
            }
        } else {
            return [Token createWithKind:TokenKindOperator text:@"<"];
        }
    }
    
    if (ch == '=') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '=') {
            [self.stream next];
            ch1 = self.stream.peek;
            if (ch1 == '=') {
                [self.stream next];
                return [Token createWithKind:TokenKindOperator text:@"==="];
            } else {
                return [Token createWithKind:TokenKindOperator text:@"=="];
            }
        } else if(ch1 == '>')  {
            // 箭头 =>
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"=>"];
        } else {
            return [Token createWithKind:TokenKindOperator text:@"="];
        }
    }
    
    if (ch == '!') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch == '=') {
            [self.stream next];
            ch1 = self.stream.peek;
            if (ch1 == '=') {
                [self.stream next];
                return [Token createWithKind:TokenKindOperator text:@"!=="];
            } else {
                [self.stream next];
                return [Token createWithKind:TokenKindOperator text:@"!="];
            }
        } else {
            return [Token createWithKind:TokenKindOperator text:@"!"];
        }
    }
    
    if (ch == '|') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '|') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"||"];
        } else if (ch1 == '=') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"|="];
        } else {
            return [Token createWithKind:TokenKindOperator text:@"|"];
        }
    }
    
    if (ch == '&') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        
        if (ch1 == '&') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"&&"];
        } else if (ch1 == '=') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"&="];
        } else {
            return [Token createWithKind:TokenKindOperator text:@"&"];
        }
    }
    
    if (ch == '^') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '=') {
            [self.stream next];
            return [Token createWithKind:TokenKindOperator text:@"^="];
        } else {
            return [Token createWithKind:TokenKindOperator text:@"^"];
        }
    }
    
    if (ch == '~') {
        [self.stream next];
        return [Token createWithKind:TokenKindOperator text:@"~"];
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
    if ([self.KeyWords containsObject:text]) {
        kind = TokenKindKeyword;
    } else if (SEqual(text, @"null")) {
        kind = TokenKindNullLiteral;
    } else if (SEqual(text, @"true") || SEqual(text, @"false")) {
        kind = TokenKindBooleanLiteral;
    }
    return [Token createWithKind:kind text:text];;
}
#pragma mark 解析标识符。从标识符中还要挑出关键字。
- (Token *)parseStringLiteral {
    TokenKind kind = TokenKindStringLiteral;
    NSString *text = @"";
    // 第一个字符不用判断，因为在调用者那里已经判断过了
    [self.stream next];
    // 读入后序字符
    while (!self.stream.eof &&
           self.stream.peek != '"') {
        text = [text stringByAppendingFormat:@"%c", self.stream.next];
    }
    
    if (self.stream.peek == '"') {
        // 消化掉字符换末尾的引号
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

#pragma mark 关键字集合
- (NSSet *)KeyWords {
    static NSSet *set = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSSet setWithArray:@[
            @"function",  @"class",     @"break",       @"delete",    @"return",
            @"case",      @"do",        @"if",          @"switch",    @"var",
            @"catch",     @"else",      @"in",          @"this",      @"void",
            @"continue",  @"false",     @"instanceof",  @"throw",     @"while",
            @"debugger",  @"finally",   @"new",         @"true",      @"with",
            @"default",   @"for",       @"null",        @"try",       @"typeof",
            //下面这些用于严格模式
            @"implements",@"let",       @"private",     @"public",    @"yield",
            @"interface", @"package",   @"protected",   @"static"
        ]];
    });
    return set;
}


@end
