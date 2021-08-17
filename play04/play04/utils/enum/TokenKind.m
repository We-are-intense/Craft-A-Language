//
//  TokenKind.m
//  play04
//
//  Created by 夏二飞 on 2021/8/17.
//

#import "TokenKind.h"

@implementation TokenKind

EnumKindImp(Keyword,        0)
EnumKindImp(Identifier,     1)
EnumKindImp(StringLiteral,  2)
EnumKindImp(IntegerLiteral, 3)
EnumKindImp(DecimalLiteral, 4)
EnumKindImp(NullLiteral,    5)
EnumKindImp(BooleanLiteral, 6)
EnumKindImp(Seperator,      7)
EnumKindImp(Operator,       8)
EnumKindImp(EOFF,           9)

@end
