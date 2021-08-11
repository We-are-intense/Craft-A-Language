//
//  FunctionDecl.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "Statement.h"

NS_ASSUME_NONNULL_BEGIN
@class FunctionBody;

@interface FunctionDecl : Statement

@property (nonatomic, strong, readonly) FunctionBody *body;

@property (nonatomic, copy, readonly) NSString *name;

- (instancetype)initWithName:(NSString *)name body:(FunctionBody *)body;

@end

NS_ASSUME_NONNULL_END
