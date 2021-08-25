//
//  ForStatement.h
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import "Statement.h"
#import "Expression.h"
#import "VariableDecl.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForStatement : Statement
///<  Expression | VariableDecl | nil
@property (nonatomic, strong) id initi;
@property (nonatomic, strong) Expression *condition;
@property (nonatomic, strong) Expression *increment;
@property (nonatomic, strong) Statement *stmt;

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                           initi:(id)initi
                       condition:(Expression *)condition
                       increment:(Expression *)increment
                            stmt:(Statement *)stmt;


@end

NS_ASSUME_NONNULL_END
