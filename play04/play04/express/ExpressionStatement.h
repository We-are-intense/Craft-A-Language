//
//  ExpressionStatement.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Statement.h"

NS_ASSUME_NONNULL_BEGIN
@class Expression;
@interface ExpressionStatement : Statement
@property (nonatomic, strong, readonly) Expression *exp;

- (instancetype)initWithExp:(Expression *)exp;

@end

NS_ASSUME_NONNULL_END
