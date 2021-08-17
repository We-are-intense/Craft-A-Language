//
//  Token.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import <Foundation/Foundation.h>

#define SEqual(aa, bb) [aa isEqualToString:bb]

#define NewToken(aa,bb) [Token createWithKind:aa text:bb]
#define NewTokenWord(aa,bb) [Token createWithKind:aa text:@#bb]

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, TokenKind) {
    TokenKindKeyword,        /// <  关键字
    TokenKindIdentifier,     /// <  标识符
    TokenKindStringLiteral,  /// <  字符串
    TokenKindIntegerLiteral, /// <  整数
    TokenKindDecimalLiteral, /// <  小数
    TokenKindNullLiteral,    /// <  nil
    TokenKindBooleanLiteral, /// <  布尔值
    TokenKindSeperator,      /// <  分隔符
    TokenKindOperator,       /// <  运算符
    TokenKindEOF            /// <  结束
};



@interface Token : NSObject

+ (instancetype)createWithKind:(TokenKind)kind text:(NSString *)text;

@property (nonatomic, assign, readonly) TokenKind kind;
@property (nonatomic, copy, readonly) NSString *text;

@end

NS_ASSUME_NONNULL_END
