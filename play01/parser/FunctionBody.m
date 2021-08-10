//
//  FunctionBody.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "FunctionBody.h"
#import "FunctionCall.h"

@interface FunctionBody ()

@property (nonatomic, copy, readwrite) NSArray <FunctionCall *> *stmts;

@end

@implementation FunctionBody

- (instancetype)initWithStmts:(NSArray <FunctionCall *> *)stmts {
    self = [super init];
    if (self) {
        _stmts = [stmts copy];
    }
    return self;
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@FunctionBody",prefix);
    for (FunctionCall *call in self.stmts) {
        [call dump:[NSString stringWithFormat:@"%@\t", prefix]];
    }
}
@end
