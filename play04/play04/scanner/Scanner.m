//
//  scanner.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Scanner.h"
#import "NSMutableArray+GetSafe.h"
#import "TokenKind.h"
#import "Op.h"
#import "Seperator.h"
#import "Keyword.h"

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
    Token *t = [self.tokens index:0];
    if (t == nil) {
        t = [self getAToken];
        NSAssert(t, @"peek token 不能为 nil");
        [self.tokens addObject:t];
    }
    return t;
}

- (Token *)peek2 {
    Token *t = [self.tokens index:1];
    while (t == nil) {
        Token *t1 = [self getAToken];
        NSAssert(t1, @"peek2 token 不能为 nil");
        [self.tokens addObject:t1];
        t = [self.tokens index:1];
    }
    return t;
}

#pragma mark - private methods
#pragma mark 从字符串流中获取一个新Token
- (Token *)getAToken {
    // 跳过空白字符
    [self skipWhiteSpaces];
    Position *pos = self.stream.getPosition;
    // 遇到结束符
    if (self.stream.eof) {
//        return [Token createWithKind:TokenKindEOF text:@""];
        return NToken(TokenKind.EOFF, @"", nil, 0);
    }

    unichar ch = self.stream.peek;
    if ([self isLetter:ch] || ch == '_') {
        return [self parseIdentifer];
    }
    
    if (ch == '"') {
        return [self parseStringLiteral];
    }
    
    if (ch == '('){
        [self.stream next];
        return NToken(TokenKind.Seperator, SChar(ch),pos,Seperator.OpenParen);
    }
    else if (ch == ')'){
        [self.stream next];
        return NToken(TokenKind.Seperator, SChar(ch),pos,Seperator.CloseParen);
    }
    else if (ch == '{'){
        [self.stream next];
        return NToken(TokenKind.Seperator, SChar(ch),pos,Seperator.OpenBrace);
    }
    else if (ch == '}'){
        [self.stream next];
        return NToken(TokenKind.Seperator, SChar(ch),pos,Seperator.CloseBrace);
    }
    else if (ch == '['){
        [self.stream next];
        return NToken(TokenKind.Seperator, SChar(ch),pos,Seperator.OpenBracket);
    }
    else if (ch == ']'){
        [self.stream next];
        return NToken(TokenKind.Seperator, SChar(ch),pos,Seperator.CloseBracket);
    }
    else if (ch == ':'){
        [self.stream next];
        return NToken(TokenKind.Seperator, SChar(ch),pos,Seperator.Colon);
    }
    else if (ch == ';'){
        [self.stream next];
        return NToken(TokenKind.Seperator, SChar(ch),pos,Seperator.SemiColon);
    }
    else if (ch == ','){
        [self.stream next];
        return NToken(TokenKind.Seperator, SChar(ch),pos,Op.Comma);
    }
    else if (ch == '?'){
        [self.stream next];
        return NToken(TokenKind.Seperator, SChar(ch),pos,Op.QuestionMark);
    }
    else if (ch == '@'){
        [self.stream next];
        return NToken(TokenKind.Seperator, SChar(ch),pos,Op.At);
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
            pos.end = self.stream.pos + 1;
            // 返回一个小数
            return NToken(TokenKind.DecimalLiteral, literal,pos,0);
        } else {
            // 返回一个整型数
            return NToken(TokenKind.IntegerLiteral, literal,pos,0);
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
            pos.end = self.stream.pos + 1;
            // 返回一个小数
            return NToken(TokenKind.DecimalLiteral, literal,pos,0);
        } else if(ch1 == '.') {
            // ... 省略号
            [self.stream next];
            
            ch1 = self.stream.peek;
            if (ch1 == '.') {
                pos.end = self.stream.pos + 1;
                return NToken(TokenKind.Seperator, @"...",pos, 0);
            } else {
                NSLog(@"Unrecognized pattern : .., missed a . ?");
                return [self getAToken];
            }
        } else {
            // . 号分隔符   如：this.value
            return NToken(TokenKind.Seperator, @".",pos, 0);
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
            pos.end = self.stream.pos + 1;
            return NToken(TokenKind.Operator, @"/=",pos,Op.DivideAssign);
        }
        return NToken(TokenKind.Operator, @"/", pos, Op.Divide);
    }
    
    if (ch == '+') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '+') {
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @"++", pos, Op.Inc);
        }
        if (ch1 == '=') {
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @"+=", pos, Op.PlusAssign);
        }
        return NToken(TokenKind.Operator, @"+", pos, Op.Plus);
    }
    if (ch == '-') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '-') {
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @"--", pos, Op.Dec);
        }
        if (ch1 == '=') {
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @"-=", pos, Op.MinusAssign);
        }
        return NToken(TokenKind.Operator, @"-", pos, Op.Minus);
    }
    
    if (ch == '*') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '=') {
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @"*=", pos, Op.MultiplyAssign);
        }
        return NToken(TokenKind.Operator, @"*", pos, Op.Multiply);
    }
    
    if (ch == '%') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '=') {
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @"%=", pos, Op.ModulusAssign);
        } else {
            return NToken(TokenKind.Operator, @"%", pos, Op.Modulus);
        }
    }
    
    if (ch == '>') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '=') {
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @">=", pos, Op.GE);
        } else if (ch1 == '>') {
            [self.stream next];
            ch1 = self.stream.peek;
            if (ch1 == '>') {
                [self.stream next];
                ch1 = self.stream.peek;
                if (ch1 == '=') {
                    [self.stream next];
                    pos.end = self.stream.pos+1;
                    return NToken(TokenKind.Operator, @">>>=", pos, Op.RightShiftLogicalAssign);
                } else {
                    pos.end = self.stream.pos+1;
                    return NToken(TokenKind.Operator, @">>>", pos, Op.RightShiftLogical);
                }
            } else if (ch1 == '=') {
                [self.stream next];
                pos.end = self.stream.pos+1;
                return NToken(TokenKind.Operator, @">>=", pos, Op.LeftShiftArithmeticAssign);
            } else {
                pos.end = self.stream.pos+1;
                return NToken(TokenKind.Operator, @">>", pos, Op.RightShiftArithmetic);
            }
        } else {
            return NToken(TokenKind.Operator, @">", pos, Op.G);
        }
    }
    
    if (ch == '<') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '=') {
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @"<=", pos, Op.LE);
        } else if (ch1 == '<') {
            [self.stream next];
            ch1 = self.stream.peek;
            if (ch1 == '=') {
                [self.stream next];
                pos.end = self.stream.pos+1;
                return NToken(TokenKind.Operator, @"<<=", pos, Op.LeftShiftArithmeticAssign);
            } else {
                pos.end = self.stream.pos+1;
                return NToken(TokenKind.Operator, @"<<", pos, Op.LeftShiftArithmetic);
            }
        } else {
            return NToken(TokenKind.Operator, @"<", pos, Op.L);
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
                pos.end = self.stream.pos+1;
                return NToken(TokenKind.Operator, @"===", pos, Op.IdentityEquals);
            } else {
                pos.end = self.stream.pos+1;
                return NToken(TokenKind.Operator, @"==", pos, Op.EQ);
            }
        } else if(ch1 == '>')  {
            // 箭头 =>
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @"=>", pos, Op.ARROW);
        } else {
            return NToken(TokenKind.Operator, @"=", pos, Op.Assign);
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
                pos.end = self.stream.pos+1;
                return NToken(TokenKind.Operator, @"!==", pos, Op.IdentityNotEquals);
            } else {
                [self.stream next];
                pos.end = self.stream.pos+1;
                return NToken(TokenKind.Operator, @"!=", pos, Op.NE);
            }
        } else {
            return NToken(TokenKind.Operator, @"!", pos, Op.Not);
        }
    }
    
    if (ch == '|') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '|') {
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @"||", pos, Op.Or);
        } else if (ch1 == '=') {
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @"|=", pos, Op.BitOrAssign);
        } else {
            return NToken(TokenKind.Operator, @"|", pos, Op.BitOrr);
        }
    }
    
    if (ch == '&') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        
        if (ch1 == '&') {
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @"&&", pos, Op.And);
        } else if (ch1 == '=') {
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @"&=", pos, Op.BitAndAssign);;
        } else {
            return NToken(TokenKind.Operator, @"&", pos, Op.BitAndd);
        }
    }
    
    if (ch == '^') {
        [self.stream next];
        unichar ch1 = self.stream.peek;
        if (ch1 == '=') {
            [self.stream next];
            pos.end = self.stream.pos+1;
            return NToken(TokenKind.Operator, @"^=", pos, Op.BitXorAssign);
        } else {
            return NToken(TokenKind.Operator, @"^", pos, Op.BitXOr);
        }
    }
    
    if (ch == '~') {
        [self.stream next];
        return NToken(TokenKind.Operator, @"~", pos, Op.BitNott);
    }
    
    // 暂时去掉不能识别的字符
    NSLog(@"Unrecognized pattern meeting line: %ld col: %ld", self.stream.line, self.stream.col);
    [self.stream next];
    return [self getAToken];
}
#pragma mark 解析标识符。从标识符中还要挑出关键字。
- (Token *)parseIdentifer {
    NSUInteger kind = TokenKind.Identifier;
    Position *pos = self.stream.getPosition;
    NSUInteger code = 0;
    NSString *text = @"";
    // 第一个字符不用判断，因为在调用者那里已经判断过了
    text = [text stringByAppendingFormat:@"%c", self.stream.next];
    // 读入后序字符
    while (!self.stream.eof &&
           [self isLetterDigitOrUnderScore:self.stream.peek]) {
        text = [text stringByAppendingFormat:@"%c", self.stream.next];
    }
    pos.end = self.stream.pos+1;
    // 识别出关键字
    if (self.KeyWords[text]) {
        kind = TokenKind.Keyword;
        code = self.KeyWords[text].integerValue;
    } else if (SEqual(text, @"null")) {
        kind = TokenKind.NullLiteral;
        code = Keyword.Null;
    } else if (SEqual(text, @"true") || SEqual(text, @"false")) {
        kind = TokenKind.BooleanLiteral;
        code = Keyword.True;
    } else if ( SEqual(text, @"false") ) {
        kind = TokenKind.BooleanLiteral;
        code = Keyword.False;
    }
    return NToken(kind, text, pos, code);
}
#pragma mark 解析标识符。从标识符中还要挑出关键字。
- (Token *)parseStringLiteral {
    NSUInteger kind = TokenKind.StringLiteral;
    Position *pos = self.stream.getPosition;
    NSUInteger code = 0;
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
    pos.end = self.stream.pos+1;
    return NToken(kind, text, pos, code);
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
- (NSDictionary <NSString *,NSNumber *>*)KeyWords {
    static NSDictionary *set = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        set = @{
            @"function":@(Keyword.Function),
            @"class":@(Keyword.Cls),
            @"break":@(Keyword.Break),
            @"delete":@(Keyword.Delete),
            @"return":@(Keyword.Return),
            @"case":@(Keyword.Case),
            @"do":@(Keyword.Do),
            @"if":@(Keyword.If),
            @"switch":@(Keyword.Switch),
            @"var":@(Keyword.Var),
            @"catch":@(Keyword.Catch),
            @"else":@(Keyword.Else),
            @"in":@(Keyword.In),
            @"this":@(Keyword.This),
            @"void":@(Keyword.Void),
            @"continue":@(Keyword.Continue),
            @"false":@(Keyword.False),
            @"instanceof":@(Keyword.Instanceof),
            @"throw":@(Keyword.Throw),
            @"while":@(Keyword.While),
            @"debugger":@(Keyword.Debuggerr),
            @"finally":@(Keyword.Finally),
            @"new":@(Keyword.New),
            @"true":@(Keyword.True),
            @"with":@(Keyword.With),
            @"default":@(Keyword.Default),
            @"for":@(Keyword.For),
            @"null":@(Keyword.Null),
            @"try":@(Keyword.Try),
            @"typeof":@(Keyword.Typeof),
            //下面这些用于严格模式
            @"implements":@(Keyword.Implements),
            @"let":@(Keyword.Let),
            @"private":@(Keyword.Private),
            @"public":@(Keyword.Public),
            @"yield":@(Keyword.Yield),
            @"interface":@(Keyword.Interface),
            @"package":@(Keyword.Package),
            @"protected":@(Keyword.Protected),
            @"static":@(Keyword.Static),
        };
    });
    return set;
}

@end
