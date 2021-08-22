//
//  SysTypes.h
//  play04
//
//  Created by xiaerfei on 2021/8/22.
//

#import <Foundation/Foundation.h>
#import "SimpleType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SysTypes : NSObject

///< 所有类型的父类型
+ (SimpleType *)Any;
///< 基础类型
+ (SimpleType *)String;
+ (SimpleType *)Number;
+ (SimpleType *)Boolean;
///< 所有类型的子类型
+ (SimpleType *)Null;
+ (SimpleType *)Undefined;

///< 函数没有任何返回值的情况
///< 如果作为变量的类型，则智能赋值为null和undefined
+ (SimpleType *)Void;

///< 两个Number的子类型
+ (SimpleType *)Integer;
+ (SimpleType *)Decimal;


+ (BOOL)isSysType:(Type *)t;





@end

NS_ASSUME_NONNULL_END
