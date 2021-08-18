//
//  Token.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "Token.h"


@interface Token ()
@property (nonatomic, assign, readwrite) NSUInteger kind;
@property (nonatomic, copy,   readwrite) NSString *text;
@property (nonatomic, copy,   readwrite) Position *pos;
@end

@implementation Token

+ (instancetype)createWithKind:(TokenKind)kind text:(NSString *)text {
    Token *token = Token.new;
    token.kind = kind;
    token.text = text;

    return token;
}

+ (instancetype)createWithKind:(NSUInteger)kind
                          text:(NSString *)text
                           pos:(Position *)pos
                          code:(NSUInteger)code {
    Token *token = Token.new;
    token.kind = kind;
    token.text = text;
    token.pos = pos;
    return token;
}



@end
