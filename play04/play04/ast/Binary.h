//
//  Binary.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Expression.h"

NS_ASSUME_NONNULL_BEGIN

@interface Binary : Expression

@property (nonatomic, copy, readonly) NSString *op; ///< 运算符
@property (nonatomic, copy, readonly) Expression *exp1; ///< 左边的表达式
@property (nonatomic, copy, readonly) Expression *exp2; ///< 右边的表达式

- (instancetype)initWithOp:(NSString *)op
                      exp1:(Expression *)exp1
                      exp2:(Expression *)exp2;


@end

NS_ASSUME_NONNULL_END
