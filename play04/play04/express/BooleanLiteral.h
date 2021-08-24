//
//  BooleanLiteral.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Expression.h"

NS_ASSUME_NONNULL_BEGIN

@interface BooleanLiteral : Expression
@property (nonatomic, strong) NSNumber *value;

- (instancetype)initWithValue:(NSNumber *)value;

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                           value:(NSNumber *)value;
@end

NS_ASSUME_NONNULL_END
