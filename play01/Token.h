//
//  Token.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, TokenKind) {
    Keyword, Identifier, StringLiteral, Seperator, Operator, End
};


@interface Token : NSObject

+ (instancetype)createWithKind:(TokenKind)kind text:(NSString *)text;

@property (nonatomic, assign, readonly) TokenKind kind;
@property (nonatomic, copy, readonly) NSString *text;

@end

NS_ASSUME_NONNULL_END
