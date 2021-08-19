//
//  IfStatement.h
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import "Statement.h"
#import "Expression.h"

NS_ASSUME_NONNULL_BEGIN

@interface IfStatement : Statement

@property (nonatomic, strong) Expression *conditon;
@property (nonatomic, strong) Statement *stmt;
@property (nonatomic, strong) Statement *elseStmt;

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                        conditon:(Expression *)conditon
                            stmt:(Statement *)stmt
                        elseStmt:(Statement *)elseStmt;

@end

NS_ASSUME_NONNULL_END
