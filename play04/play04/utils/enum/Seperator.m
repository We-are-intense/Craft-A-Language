//
//  Seperator.m
//  play04
//
//  Created by 夏二飞 on 2021/8/17.
//

#import "Seperator.h"

@implementation Seperator

EnumKindImp(OpenBracket,    0)  ///<  [
EnumKindImp(CloseBracket,   1)  ///<  ]
EnumKindImp(OpenParen,      2)  ///<  (
EnumKindImp(CloseParen,     3)  ///<  )
EnumKindImp(OpenBrace,      4)  ///<  {
EnumKindImp(CloseBrace,     5)  ///<  }
EnumKindImp(Colon,          6)  ///<  :
EnumKindImp(SemiColon,      7)  ///<  ;

@end
