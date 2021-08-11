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

@end

@implementation Tokenizer

- (instancetype)initWithTokens:(NSArray <Token *>*)tokens {
    self = [super init];
    if (self) {
        _tokens = [tokens copy];
    }
    return self;
}

- (Token *)next {
    if (self.pos < self.tokens.count) {
        return self.tokens[self.pos ++];
    } else {
        return self.tokens[self.pos];
    }
}

- (NSUInteger)position {
    return self.pos;
}

- (void)traceBack:(NSUInteger)back {
    self.pos = back;
}

@end
