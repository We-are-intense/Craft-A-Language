//
//  ReturnStatement.h
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import "Statement.h"
#import "Expression.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReturnStatement : Statement

@property (nonatomic, strong) Expression *exp;

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                             exp:(Expression *)exp;

@end

NS_ASSUME_NONNULL_END
