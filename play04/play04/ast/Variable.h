//
//  Variable.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import "Expression.h"
#import "VariableDecl.h"

NS_ASSUME_NONNULL_BEGIN

@interface Variable : Expression
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, nullable) VariableDecl *decl;

- (instancetype)initWithName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
