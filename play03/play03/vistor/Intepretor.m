//
//  Intepretor.m
//  play01
//
//  Created by 夏二飞 on 2021/8/10.
//

#import "Intepretor.h"

@implementation Intepretor

- (id)visitProg:(Prog *)prog {
    id retVal = nil;
    for (FunctionCall *obj in prog.stmts) {
        if ([obj isKindOfClass:FunctionCall.class]) {
            retVal = [self runFunction:obj];
        }
    }
    return retVal;
}

- (id)visitFunctionBody:(FunctionBody *)functionBody {
    id retVal = nil;
    for (id obj in functionBody.stmts) {
        retVal = [self runFunction:obj];
    }
    return retVal;
}


- (id)runFunction:(FunctionCall *)functionCall {
    if ([functionCall.name isEqualToString:@"println"]) {
        if (functionCall.parameters.count != 0) {
            NSLog(@"%@", functionCall.parameters[0]);
        } else {
            NSLog(@"空值");
        }
    } else {
        //找到函数定义，继续遍历函数体
        if (functionCall.definition) {
            return [self visitFunctionBody:functionCall.definition.body];
        }
    }
    
    return @0;
}


@end
