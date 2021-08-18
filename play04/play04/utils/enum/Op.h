//
//  Op.h
//  play04
//
//  Created by xiaerfei on 2021/8/17.
//

#import <Foundation/Foundation.h>
#import "helper.h"

NS_ASSUME_NONNULL_BEGIN

@interface Op : NSObject
EnumKind(QuestionMark)                   //?   让几个类型的code取值不重叠
EnumKind(Ellipsis)                       //...
EnumKind(Dot)                            //.
EnumKind(Comma)                          //,
EnumKind(At)                             //@
EnumKind(RightShiftArithmetic)           //>>
EnumKind(LeftShiftArithmetic)            // <<
EnumKind(RightShiftLogical)              //>>>
EnumKind(IdentityEquals)                 //===
EnumKind(IdentityNotEquals)              //!==
EnumKind(BitNott)                         //~
EnumKind(BitAndd)                         //&
EnumKind(BitXOr)                         //^
EnumKind(BitOrr)                          //|
EnumKind(Not)                            //!
EnumKind(And)                            //&&
EnumKind(Or)                             //||
EnumKind(Assign)                         //=
EnumKind(MultiplyAssign)                 //*=
EnumKind(DivideAssign)                   ///=
EnumKind(ModulusAssign)                  //%=
EnumKind(PlusAssign)                     //+=
EnumKind(MinusAssign)                    //-=
EnumKind(LeftShiftArithmeticAssign)      // <<=
EnumKind(RightShiftArithmeticAssign)     //>>=
EnumKind(RightShiftLogicalAssign)        //>>>=
EnumKind(BitAndAssign)                   //&=
EnumKind(BitXorAssign)                   //^=
EnumKind(BitOrAssign)                    //|=
EnumKind(ARROW)                          //=>
EnumKind(Inc)                            //++
EnumKind(Dec)                            //--
EnumKind(Plus)                           //+
EnumKind(Minus)                          //-
EnumKind(Multiply)                       //*
EnumKind(Divide)                         ///
EnumKind(Modulus)                        //%
EnumKind(EQ)                             //==
EnumKind(NE)                             //!=
EnumKind(G)                              //>
EnumKind(GE)                             //>=
EnumKind(L)                              // <
EnumKind(LE)                             // <=
@end

NS_ASSUME_NONNULL_END
