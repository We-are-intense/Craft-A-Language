//
//  FunctionDecl.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "Decl.h"

NS_ASSUME_NONNULL_BEGIN
@class Block;

@interface FunctionDecl : Decl

@property (nonatomic, strong, readonly) Block *body;

- (instancetype)initWithName:(NSString *)name body:(Block *)body;

@end

NS_ASSUME_NONNULL_END
