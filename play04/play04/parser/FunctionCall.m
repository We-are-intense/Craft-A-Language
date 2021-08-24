//
//  FunctionCall.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "FunctionCall.h"
#import "FunctionDecl.h"
#import "AstVisitor.h"

@interface FunctionCall ()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSArray <Expression *>*parameters;

@end

@implementation FunctionCall
- (instancetype)initWithName:(NSString *)name
                  parameters:(NSArray <Expression *>*)parameters {
    self = [super init];
    if (self) {
        _name = [name copy];
        _parameters = [parameters copy];
    }
    return self;
}

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                            name:(NSString *)name
                      parameters:(NSArray <Expression *>*)parameters {
    self = [super initWithBeginPos:beginPos endPos:endPos isErrorNode:isErrorNode];
    if (self) {
        _name = [name copy];
        _parameters = [parameters copy];
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitFunctionCall:self additional:additional];
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@FunctionCall%@%@", prefix, self.name, self.decl ? @", resolved" : @", not resolved");
    for (NSString *param in self.parameters) {
        NSLog(@"%@\tParameter:%@", prefix, param);
    }
    
}


@end
