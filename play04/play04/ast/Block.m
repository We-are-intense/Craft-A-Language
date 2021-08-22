//
//  Block.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Block.h"

@implementation Block

- (instancetype)initWithStmts:(NSArray <Statement *> *)stmts {
    self = [super init];
    if (self) {
        _stmts = [stmts copy];
    }
    return self;
}

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                           stmts:(NSArray <Statement *> * _Nullable)stmts {
    self = [super initWithBeginPos:beginPos endPos:endPos isErrorNode:isErrorNode];
    if (self) {
        _stmts = [stmts copy];
    }
    return self;
}


- (id)accept:(AstVisitor *)visitor {
    
    
    return nil;
}

- (void)dump:(NSString *)prefix {
    
}


@end
