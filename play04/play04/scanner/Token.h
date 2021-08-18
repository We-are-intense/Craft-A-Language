//
//  Token.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import <Foundation/Foundation.h>
#import "Position.h"


#define SEqual(aa, bb) [aa isEqualToString:bb]
#define SChar(cc) [NSString stringWithFormat:@"%c",cc]

#define NToken(kd, txt, posi, codee) [Token createWithKind:kd text:txt pos:posi code:codee]


NS_ASSUME_NONNULL_BEGIN


//typedef NS_ENUM(NSInteger, TokenKind) {
//    TokenKindKeyword,        /// <  关键字
//    TokenKindIdentifier,     /// <  标识符
//    TokenKindStringLiteral,  /// <  字符串
//    TokenKindIntegerLiteral, /// <  整数
//    TokenKindDecimalLiteral, /// <  小数
//    TokenKindNullLiteral,    /// <  nil
//    TokenKindBooleanLiteral, /// <  布尔值
//    TokenKindSeperator,      /// <  分隔符
//    TokenKindOperator,       /// <  运算符
//    TokenKindEOF            /// <  结束
//};



@interface Token : NSObject

@property (nonatomic, assign, readonly) NSUInteger kind;
@property (nonatomic, copy,   readonly) NSString *text;
@property (nonatomic, copy,   readonly) Position *pos;

+ (instancetype)createWithKind:(NSUInteger)kind
                          text:(NSString *)text
                           pos:(Position *)pos
                          code:(NSUInteger)code;


@end

NS_ASSUME_NONNULL_END
