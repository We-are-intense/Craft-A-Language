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

- (id)visitFunctionDecl:(FunctionDecl *)functionDecl {
    return nil;
}

- (id)visitFunctionCall:(FunctionCall *)functionCall {
    if ([functionCall.name isEqualToString:@"println"]) {
        if (functionCall.parameters.count > 0) {
            id retVal = [self visit:functionCall.parameters[0]];
            if ([retVal isKindOfClass:LeftValue.class]) {
                
            }
            NSLog(@"%@", retVal);
        } else {
            NSLog(@" ");
        }
        return @0;
    } else {
        if (functionCall.decl) {
            // 找到函数定义，继续遍历函数体
            return [self visitBlock:functionCall.decl.body];
        }
    }
    return nil;
}

- (id)visitVariableDecl:(VariableDecl *)variableDecl {
    if (variableDecl.initi) {
        id v = [self visit:variableDecl.initi];
        if ([self isLeftValue:v]) {
            
        }
    }
    
    return nil;
}

- (id)visitBinary:(Binary *)bi {
    id ret = nil;
    id v1 = [self visit:bi.exp1];
    id v2 = [self visit:bi.exp2];
    LeftValue *v1Left = nil;
    LeftValue *v2Left = nil;
    
    if ([self isLeftValue:v1]) {
        v1 = [self getVariableValue:v1Left.variable.name];
        NSLog(@"value of %@:%@", v1Left.variable.name, v1);
    }
    
    if ([self isLeftValue:v2]) {
        v2 = [self getVariableValue:v2Left.variable.name];
    }
    
    if (SEqual(bi.op, @"+")) {
        
    } else if (SEqual(bi.op, @"-")) {
        
    } else if (SEqual(bi.op, @"*")) {
        
    } else if (SEqual(bi.op, @"/")) {
        
    } else if (SEqual(bi.op, @"%")) {
        
    } else if (SEqual(bi.op, @">")) {
        
    } else if (SEqual(bi.op, @">=")) {
        
    } else if (SEqual(bi.op, @"<")) {
        
    } else if (SEqual(bi.op, @"<=")) {
        
    } else if (SEqual(bi.op, @"&&")) {
        
    } else if (SEqual(bi.op, @"||")) {
        
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

- (id)visitVariable:(Variable *)v {
    return [[LeftValue alloc] initWithVariable:v];
}

@end
