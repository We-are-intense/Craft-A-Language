//
//  Intepretor.m
//  play01
//
//  Created by 夏二飞 on 2021/8/10.
//

#import "Intepretor.h"
#import "LeftValue.h"
#import "Token.h"
@implementation Intepretor

- (instancetype)init
{
    self = [super init];
    if (self) {
        _values = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)visitFunctionDecl:(FunctionDecl *)functionDecl additional:(id)additional {
    return nil;
}

- (id)visitFunctionCall:(FunctionCall *)functionCall additional:(id)additional {
    if ([functionCall.name isEqualToString:@"println"]) {
        if (functionCall.parameters.count > 0) {
            LeftValue *retVal = [self visit:functionCall.parameters[0] additional:additional];
            if ([retVal isKindOfClass:LeftValue.class] && retVal.variable) {
                retVal = [self getVariableValue:retVal.variable.name];
            }
            NSLog(@"%@", retVal);
        } else {
            NSLog(@" ");
        }
        return @0;
    } else {
        if (functionCall.decl) {
            // 找到函数定义，继续遍历函数体
            return [self visitBlock:functionCall.decl.body additional:additional];
        }
    }
    return nil;
}

- (id)visitVariableDecl:(VariableDecl *)variableDecl additional:(id)additional {
    if (variableDecl.initi) {
        LeftValue *v = [self visit:variableDecl.initi additional:additional];
        if ([self isLeftValue:v]) {
            v = [self getVariableValue:v.variable.name];
        }
        [self setVariableValue:variableDecl.name value:v];
        return v;
    }
    return nil;
}

- (id)visitVariable:(Variable *)v {
    return [[LeftValue alloc] initWithVariable:v];
}

- (id)visitBinary:(Binary *)bi additional:(id)additional {
    id ret = nil;
    id v1 = [self visit:bi.exp1 additional:additional];
    id v2 = [self visit:bi.exp2 additional:additional];
    LeftValue *v1Left = nil;
    LeftValue *v2Left = nil;
    
    if ([self isLeftValue:v1]) {
        v1Left = v1;
        v1 = [self getVariableValue:v1Left.variable.name];
        NSLog(@"value of %@:%@", v1Left.variable.name, v1);
    }
    
    if ([self isLeftValue:v2]) {
        v2Left = v2;
        v2 = [self getVariableValue:v2Left.variable.name];
    }

    /*
        返回类型：
        0: unknown
        1: 字符串
        2: int
        3: float
        4: double
        5: char
        6: BOOL
     */
    NSInteger type = [self numberTypeWithV1:v1 v2:v2];
    if (SEqual(bi.op, @"+")) {
        if (type == 2 || type == 5) {
            ret = @([v1 integerValue] + [v2 integerValue]);
        } else if (type == 3) {
            ret = @([v1 floatValue] + [v2 floatValue]);
        } else if (type == 4) {
            ret = @([v1 doubleValue] + [v2 doubleValue]);
        } else if (type == 1) {
            ret = [NSString stringWithFormat:@"%@%@", v1, v2];
        } else {
            NSAssert(NO, @"运算符 + ：左右值类型错误");
        }
    } else if (SEqual(bi.op, @"-")) {
        if (type == 2 || type == 5) {
            ret = @([v1 integerValue] - [v2 integerValue]);
        } else if (type == 3) {
            ret = @([v1 floatValue] - [v2 floatValue]);
        } else if (type == 4) {
            ret = @([v1 doubleValue] - [v2 doubleValue]);
        } else {
            NSAssert(NO, @"运算符 - ：左右值类型错误");
        }
    } else if (SEqual(bi.op, @"*")) {
        if (type == 2 || type == 5) {
            ret = @([v1 integerValue] * [v2 integerValue]);
        } else if (type == 3) {
            ret = @([v1 floatValue] * [v2 floatValue]);
        } else if (type == 4) {
            ret = @([v1 doubleValue] * [v2 doubleValue]);
        } else {
            NSAssert(NO, @"运算符 * ：左右值类型错误");
        }
    } else if (SEqual(bi.op, @"/")) {
        if (type == 2 || type == 5) {
            NSAssert([v2 integerValue] != 0, @"除数不能为零");
            ret = @([v1 integerValue] / [v2 integerValue]);
        } else if (type == 3) {
            NSAssert([v2 floatValue] != 0, @"除数不能为零");
            ret = @([v1 floatValue] / [v2 floatValue]);
        } else if (type == 4) {
            NSAssert([v2 doubleValue] != 0, @"除数不能为零");
            ret = @([v1 doubleValue] / [v2 doubleValue]);
        } else {
            NSAssert(NO, @"运算符 / ：左右值类型错误");
        }
    } else if (SEqual(bi.op, @"%")) {
        if (type == 2 || type == 5) {
            NSAssert([v2 integerValue] != 0, @"除数不能为零");
            ret = @([v1 integerValue] % [v2 integerValue]);
        } else {
            NSAssert(NO, @"运算符 %% ：左右值类型错误");
        }
    } else if (SEqual(bi.op, @">")) {
        if (type == 2 || type == 5) {
            ret = @([v1 integerValue] > [v2 integerValue]);
        } else if (type == 3) {
            ret = @([v1 floatValue] > [v2 floatValue]);
        } else if (type == 4) {
            ret = @([v1 doubleValue] > [v2 doubleValue]);
        } else {
            NSAssert(NO, @"运算符 > ：左右值类型错误");
        }
    } else if (SEqual(bi.op, @">=")) {
        if (type == 2 || type == 5) {
            ret = @([v1 integerValue] >= [v2 integerValue]);
        } else if (type == 3) {
            ret = @([v1 floatValue] >= [v2 floatValue]);
        } else if (type == 4) {
            ret = @([v1 doubleValue] >= [v2 doubleValue]);
        } else {
            NSAssert(NO, @"运算符 >= ：左右值类型错误");
        }
    } else if (SEqual(bi.op, @"<")) {
        if (type == 2 || type == 5) {
            ret = @([v1 integerValue] < [v2 integerValue]);
        } else if (type == 3) {
            ret = @([v1 floatValue] < [v2 floatValue]);
        } else if (type == 4) {
            ret = @([v1 doubleValue] < [v2 doubleValue]);
        } else {
            NSAssert(NO, @"运算符 < ：左右值类型错误");
        }
    } else if (SEqual(bi.op, @"<=")) {
        if (type == 2 || type == 5) {
            ret = @([v1 integerValue] <= [v2 integerValue]);
        } else if (type == 3) {
            ret = @([v1 floatValue] <= [v2 floatValue]);
        } else if (type == 4) {
            ret = @([v1 doubleValue] <= [v2 doubleValue]);
        } else {
            NSAssert(NO, @"运算符 <= ：左右值类型错误");
        }
    } else if (SEqual(bi.op, @"&&")) {
        if (type == 2 || type == 5) {
            ret = @([v1 integerValue] && [v2 integerValue]);
        } else if (type == 3) {
            ret = @([v1 floatValue] && [v2 floatValue]);
        } else if (type == 4) {
            ret = @([v1 doubleValue] && [v2 doubleValue]);
        } else {
            NSAssert(NO, @"运算符 && ：左右值类型错误");
        }
    } else if (SEqual(bi.op, @"||")) {
        if (type == 2 || type == 5) {
            ret = @([v1 integerValue] || [v2 integerValue]);
        } else if (type == 3) {
            ret = @([v1 floatValue] || [v2 floatValue]);
        } else if (type == 4) {
            ret = @([v1 doubleValue] || [v2 doubleValue]);
        } else {
            NSAssert(NO, @"运算符 || ：左右值类型错误");
        }
    } else if (SEqual(bi.op, @"=")) {
        if (v1Left) {
            [self setVariableValue:v1Left.variable.name value:v2];
        } else {
            NSLog(@"Assignment need a left value: ");
        }
    } else {
        NSLog(@"Unsupported binary operation: %@", bi.op);
    }
    return ret;
}


#pragma mark - private methods
- (BOOL)isLeftValue:(id)v {
    return [v isKindOfClass:LeftValue.class];
}

- (id)getVariableValue:(NSString *)varName {
    return self.values[varName];
}

- (void)setVariableValue:(NSString *)varName value:(id)value {
    self.values[varName] = value;
}
/*
     char: __NSCFNumber c
     unsigned char: __NSCFNumber s
     short: __NSCFNumber s
     unsigned short: __NSCFNumber i
     int: __NSCFNumber i
     unsigned int:
     long: __NSCFNumber q
     unsigned long: __NSCFNumber q
     long long: __NSCFNumber q
     unsigned long long:
     float: __NSCFNumber f
     double: __NSCFNumber d
     BOOL: __NSCFBoolean c
     Integer: __NSCFNumber i
     UnSigned Integer:_NSCFNumber i
 
    返回类型：
    0: unknown
    1: 字符串
    2: int
    3: float
    4: double
    5: char
    6: BOOL
 */
- (NSInteger)numberTypeWithV1:(NSNumber *)v1 v2:(NSNumber *)v2 {
    if ([v1 isKindOfClass:NSString.class] || [v2 isKindOfClass:NSString.class]) {
        return 1;
    }
    
    if ([self isIntOfNum:v1] && [self isIntOfNum:v2]) {
        return 2;
    }
    
    if ([self isFloatOfNum:v1] || [self isFloatOfNum:v2]) {
        return 3;
    }
    
    if ([self isCharOfNum:v1] && [self isCharOfNum:v2]) {
        return 5;
    }
    
    if ([self isBoolOfNum:v1] && [self isBoolOfNum:v2]) {
        return 6;
    }
    
    return 0;
}

- (BOOL)isIntOfNum:(NSNumber *)v {
    NSArray *intTypeArray = @[@"s", @"i", @"q"];
    NSString *intType = [NSString stringWithFormat:@"%s", v.objCType];
    return ([NSStringFromClass(v.class) isEqualToString:@"__NSCFNumber"] &&
            [intTypeArray containsObject:intType]);
}

- (BOOL)isFloatOfNum:(NSNumber *)v {
    NSArray *floatTypeArray = @[@"f", @"d"];
    NSString *floatType = [NSString stringWithFormat:@"%s", v.objCType];
    return ([NSStringFromClass(v.class) isEqualToString:@"__NSCFNumber"] &&
            [floatTypeArray containsObject:floatType]);
}

- (BOOL)isCharOfNum:(NSNumber *)v {
    NSArray *charTypeArray = @[@"c"];
    NSString *charType = [NSString stringWithFormat:@"%s", v.objCType];
    return ([NSStringFromClass(v.class) isEqualToString:@"__NSCFNumber"] &&
            [charTypeArray containsObject:charType]);
}

- (BOOL)isBoolOfNum:(NSNumber *)v {
    return ([v isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) ;
}

@end
