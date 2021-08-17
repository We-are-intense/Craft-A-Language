//
//  Token.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "Token.h"
#import "Keyword.h"


@interface Token ()
@property (nonatomic, assign, readwrite) TokenKind kind;
@property (nonatomic, copy, readwrite) NSString *text;

@end

@implementation Token

+ (instancetype)createWithKind:(TokenKind)kind text:(NSString *)text {
    Token *token = Token.new;
    token.kind = kind;
    token.text = text;
    
    NSInteger c = Keyword.Function;
    NSInteger d = Keyword.Break;
    
    
    return token;
}


@end
