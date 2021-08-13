//
//  RefResolver.m
//  play01
//
//  Created by 夏二飞 on 2021/8/10.
//

#import "RefResolver.h"

@interface RefResolver ()

@property (nonatomic, strong, readwrite) Prog *prog;

@end

@implementation RefResolver

- (id)visitProg:(Prog *)prog {
    self.prog = prog;
    for (id obj in prog.stmts) {
        if ([obj isKindOfClass:FunctionCall.class]) {
            [self resolveFunctionCall:prog functionCall:obj];
        } else {
            [self visitFunctionDecl:obj];
        }
    }
    
    return nil;
}

- (id)visitFunctionBody:(FunctionBody *)functionBody {
    if (self.prog != nil) {
        for (id obj in functionBody.stmts) {
            return [self resolveFunctionCall:self.prog functionCall:obj];
        }
    }
    return nil;
}


- (id)resolveFunctionCall:(Prog *)prog functionCall:(FunctionCall *)functionCall {
    FunctionDecl *obj = [self findFunctionDecl:self.prog name:functionCall.name];
    if (obj) {
        functionCall.definition = obj;
    } else {
        if (![functionCall.name isEqualToString:@"println"]) {
            NSLog(@"Error: cannot find definition of function %@", functionCall.name);
        }
    }
    
    return nil;
}

- (id)findFunctionDecl:(Prog *)prog name:(NSString *)name {
    for (FunctionDecl *obj in prog.stmts) {
        if ([obj isKindOfClass:FunctionDecl.class] && [obj.name isEqualToString:name]) {
            return obj;
        }
    }
    return nil;
}


@end
