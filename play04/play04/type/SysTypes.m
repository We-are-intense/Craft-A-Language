//
//  SysTypes.m
//  play04
//
//  Created by xiaerfei on 2021/8/22.
//

#import "SysTypes.h"

#define returnNSimpleType(na, uts)    \
static SimpleType *type = nil;  \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
    type = [[SimpleType alloc] initWithName:na upperTypes:uts]; \
}); \
return type;

@implementation SysTypes


///< 所有类型的父类型
+ (SimpleType *)Any {
    returnNSimpleType(@"any",@[]);
}
///< 基础类型
+ (SimpleType *)String {
    returnNSimpleType(@"string", @[SysTypes.Any]);
}

+ (SimpleType *)Number {
    returnNSimpleType(@"number",@[SysTypes.Any]);
}

+ (SimpleType *)Boolean {
    returnNSimpleType(@"boolean", @[SysTypes.Any]);
}
///< 所有类型的子类型
+ (SimpleType *)Null {
    returnNSimpleType(@"null", @[]);
}

+ (SimpleType *)Undefined {
    returnNSimpleType(@"undefined", @[]);
}

///< 函数没有任何返回值的情况
///< 如果作为变量的类型，则智能赋值为null和undefined
+ (SimpleType *)Void {
    returnNSimpleType(@"void", @[]);
}

///< 两个Number的子类型
+ (SimpleType *)Integer {
    returnNSimpleType(@"integer", @[SysTypes.Number]);
}

+ (SimpleType *)Decimal {
    returnNSimpleType(@"decimal", @[SysTypes.Number]);
}

+ (BOOL)isSysType:(Type *)t {
    return (t == SysTypes.Any ||
            t == SysTypes.String ||
            t == SysTypes.Number ||
            t == SysTypes.Boolean ||
            t == SysTypes.Null ||
            t == SysTypes.Undefined ||
            t == SysTypes.Void ||
            t == SysTypes.Integer ||
            t == SysTypes.Decimal);
}

@end
