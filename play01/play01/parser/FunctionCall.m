//
//  FunctionCall.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "FunctionCall.h"
#import "FunctionDecl.h"

@interface FunctionCall ()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSArray <NSString *>*parameters;

@end

@implementation FunctionCall
- (instancetype)initWithName:(NSString *)name
                  parameters:(NSArray <NSString *>*)parameters {
    self = [super init];
    if (self) {
        _name = [name copy];
        _parameters = [parameters copy];
    }
    return self;
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@FunctionCall%@%@", prefix, self.name, self.definition!=nil ? @", resolved" : @", not resolved");
    for (NSString *param in self.parameters) {
        NSLog(@"%@\tParameter:%@", prefix, param);
    }
    
}


@end
