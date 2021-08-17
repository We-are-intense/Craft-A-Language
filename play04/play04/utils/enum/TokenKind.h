//
//  TokenKind.h
//  play04
//
//  Created by 夏二飞 on 2021/8/17.
//

#import <Foundation/Foundation.h>
#import "helper.h"

NS_ASSUME_NONNULL_BEGIN

@interface TokenKind : NSObject
EnumKind(Keyword)
EnumKind(Identifier)
EnumKind(StringLiteral)
EnumKind(IntegerLiteral)
EnumKind(DecimalLiteral)
EnumKind(NullLiteral)
EnumKind(BooleanLiteral)
EnumKind(Seperator)
EnumKind(Operator)
EnumKind(EOFF)
@end

NS_ASSUME_NONNULL_END
