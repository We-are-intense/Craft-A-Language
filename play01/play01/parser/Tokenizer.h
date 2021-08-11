//
//  Tokenizer.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import <Foundation/Foundation.h>
#import "Token.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tokenizer : NSObject

- (instancetype)initWithTokens:(NSArray <Token *>*)tokens;

- (Token *)next;

- (NSUInteger)position;

- (void)traceBack:(NSUInteger)back;


@end

NS_ASSUME_NONNULL_END
