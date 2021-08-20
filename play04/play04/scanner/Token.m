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
@property (nonatomic, strong, readwrite) Position *pos;
@property (nonatomic, assign, readwrite) NSUInteger code;
@end

@implementation Token

+ (instancetype)createWithKind:(NSUInteger)kind
                          text:(NSString *)text
                           pos:(Position *)pos
                          code:(NSUInteger)code {
    Token *token = Token.new;
    token.kind = kind;
    token.text = text;
    token.pos  = pos;
    token.code = code;
    return token;
}

- (NSString *)toString {
    return [NSString stringWithFormat:@"Token@%@\t Kind: %ld text: %@", self.pos.toString, self.kind, self.text];
}

@end
