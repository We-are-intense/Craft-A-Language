//
//  ExpressionStatement.m
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "ExpressionStatement.h"
#import "AstVisitor.h"

@implementation ExpressionStatement

- (instancetype)initWithExp:(Expression *)exp {
    self = [super init];
    if (self) {
        _exp = exp;
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor {
 
    return nil;
}

@end
