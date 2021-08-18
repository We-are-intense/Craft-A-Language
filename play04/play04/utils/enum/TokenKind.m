//
//  TokenKind.m
//  play04
//
//  Created by 夏二飞 on 2021/8/17.
//

#import "TokenKind.h"

InnerEnum(aa,
          Keyword,
          Identifier,
          StringLiteral,
          IntegerLiteral,
          DecimalLiteral,
          NullLiteral,
          BooleanLiteral,
          Seperator,
          Operator,
          EOFF
          )


@implementation TokenKind

EnumKindImp(Keyword       )
EnumKindImp(Identifier    )
EnumKindImp(StringLiteral )
EnumKindImp(IntegerLiteral)
EnumKindImp(DecimalLiteral)
EnumKindImp(NullLiteral   )
EnumKindImp(BooleanLiteral)
EnumKindImp(Seperator     )
EnumKindImp(Operator      )
EnumKindImp(EOFF          )

@end
