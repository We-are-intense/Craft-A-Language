//
//  Unary.h
//  play04
//
//  Created by 夏二飞 on 2021/8/24.
//

#import "Expression.h"

NS_ASSUME_NONNULL_BEGIN

@interface Unary : Expression

@property (nonatomic, assign) NSInteger op;
@property (nonatomic, strong) Expression *exp;
@property (nonatomic, assign) BOOL isPrefix;

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                              op:(NSInteger)op
                             exp:(Expression *)exp
                        isPrefix:(BOOL)isPrefix;

@end

NS_ASSUME_NONNULL_END
