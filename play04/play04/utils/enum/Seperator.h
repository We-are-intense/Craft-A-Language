//
//  Seperator.h
//  play04
//
//  Created by 夏二飞 on 2021/8/17.
//

#import <Foundation/Foundation.h>
#import "helper.h"

NS_ASSUME_NONNULL_BEGIN

@interface Seperator : NSObject
EnumKind(OpenBracket)   ///<  [
EnumKind(CloseBracket)  ///<  ]
EnumKind(OpenParen)     ///<  (
EnumKind(CloseParen)    ///<  )
EnumKind(OpenBrace)     ///<  {
EnumKind(CloseBrace)    ///<  }
EnumKind(Colon)         ///<  :
EnumKind(SemiColon)     ///<  ;
@end

NS_ASSUME_NONNULL_END
