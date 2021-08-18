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

EnumKind(Keyword)           ///< 关键字
EnumKind(Identifier)        ///<  标识符
EnumKind(StringLiteral)     ///<  字符串
EnumKind(IntegerLiteral)    ///<  整数
EnumKind(DecimalLiteral)    ///<  小数
EnumKind(NullLiteral)       ///<  nil
EnumKind(BooleanLiteral)    ///<  布尔值
EnumKind(Seperator)         ///<  分隔符
EnumKind(Operator)          ///<  运算符
EnumKind(EOFF)              ///<  结束

@end

NS_ASSUME_NONNULL_END
