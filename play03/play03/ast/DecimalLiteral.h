//
//  DecimalLiteral.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Expression.h"

NS_ASSUME_NONNULL_BEGIN

@interface DecimalLiteral : Expression
@property (nonatomic, strong, readonly) NSNumber *value;

- (instancetype)initWithValue:(NSNumber *)value;
@end

NS_ASSUME_NONNULL_END
