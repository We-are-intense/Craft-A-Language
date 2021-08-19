//
//  IfStatement.m
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import "IfStatement.h"
#import "AstVisitor.h"

@implementation IfStatement

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                        conditon:(Expression *)conditon
                            stmt:(Statement *)stmt
                        elseStmt:(Statement *)elseStmt {
    self = [super initWithBeginPos:beginPos endPos:endPos isErrorNode:isErrorNode];
    if (self) {
        self.conditon = conditon;
        self.stmt = stmt;
        self.elseStmt = elseStmt;
    }
    return self;
}

- (id)accept:(AstVisitor *)visitor additional:(id)additional {
    return [visitor visitIfStatement:self additional:additional];
}


@end
