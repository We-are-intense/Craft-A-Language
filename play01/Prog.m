//
//  Prog.m
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "Prog.h"
@interface Prog ()

@property (nonatomic, copy) NSArray <Statement *>*stmts;

@end
// prog = (functionDecl | functionCall)* ;
@implementation Prog
- (instancetype)initWithStmts:(NSArray <Statement *>*)stmts {
    self = [super init];
    if (self) {
        _stmts = [stmts copy];
    }
    return self;
}

- (void)dump:(NSString *)prefix {
    NSLog(@"%@Prog", prefix);
    for (Statement *stmt in self.stmts) {
        [stmt dump:[NSString stringWithFormat:@"%@\t", prefix]];
    }
}

@end
