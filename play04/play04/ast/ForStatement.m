//
//  ForStatement.m
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import "ForStatement.h"
#import "AstVisitor.h"

@implementation ForStatement

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                           initi:(id)initi
                       condition:(Expression *)condition
                       increment:(Expression *)increment
                            stmt:(Statement *)stmt {
    self = [super initWithBeginPos:beginPos endPos:endPos isErrorNode:isErrorNode];
    if (self) {
        self.initi = initi;
        self.condition = condition;
        self.increment = increment;
        self.stmt = stmt;
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitForStatement:self additional:additional];
}



@end
