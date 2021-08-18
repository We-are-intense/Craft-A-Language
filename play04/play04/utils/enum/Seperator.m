//
//  Seperator.m
//  play04
//
//  Created by 夏二飞 on 2021/8/17.
//

#import "Seperator.h"

InnerEnum(aa,
          OpenBracket=0,
          CloseBracket,
          OpenParen,
          CloseParen,
          OpenBrace,
          CloseBrace,
          Colon,
          SemiColon)

@implementation Seperator

EnumKindImp(OpenBracket)    ///<  [
EnumKindImp(CloseBracket)   ///<  ]
EnumKindImp(OpenParen)      ///<  (
EnumKindImp(CloseParen)     ///<  )
EnumKindImp(OpenBrace)      ///<  {
EnumKindImp(CloseBrace)     ///<  }
EnumKindImp(Colon)          ///<  :
EnumKindImp(SemiColon)      ///<  ;

@end
