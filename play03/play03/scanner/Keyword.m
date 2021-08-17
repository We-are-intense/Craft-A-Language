//
//  Keyword.m
//  play03
//
//  Created by 夏二飞 on 2021/8/17.
//

#import "Keyword.h"

#define EnumKindImp(aa, bb) \
+ (NSInteger)aa { \
return bb; \
}

@implementation Keyword

EnumKindImp(Function,   200)
EnumKindImp(Cls,        201)
EnumKindImp(Break,      202)
EnumKindImp(Delete,     203)
EnumKindImp(Return,     204)
EnumKindImp(Case,       205)
EnumKindImp(Do,         206)
EnumKindImp(If,         207)
EnumKindImp(Switch,     208)
EnumKindImp(Var,        209)
EnumKindImp(Catch,      210)
EnumKindImp(Else,       211)
EnumKindImp(In,         212)
EnumKindImp(This,       213)
EnumKindImp(Void,       214)
EnumKindImp(Continue,   215)
EnumKindImp(False,      216)
EnumKindImp(Instanceof, 217)
EnumKindImp(Throw,      218)
EnumKindImp(While,      219)
EnumKindImp(Debugger,   220)
EnumKindImp(Finally,    221)
EnumKindImp(New,        222)
EnumKindImp(True,       223)
EnumKindImp(With,       224)
EnumKindImp(Default,    225)
EnumKindImp(For,        226)
EnumKindImp(Null,       227)
EnumKindImp(Try,        228)
EnumKindImp(Typeof,     229)
EnumKindImp(Implements, 230)
EnumKindImp(Let,        231)
EnumKindImp(Private,    232)
EnumKindImp(Public,     233)
EnumKindImp(Yield,      234)
EnumKindImp(Interface,  235)
EnumKindImp(Package,    236)
EnumKindImp(Protected,  237)
EnumKindImp(Static,     238)

@end
