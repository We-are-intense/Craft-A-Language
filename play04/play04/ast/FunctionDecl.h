//
//  FunctionDecl.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "Decl.h"

NS_ASSUME_NONNULL_BEGIN
@class Block, CallSignature;

@interface FunctionDecl : Decl

@property (nonatomic, strong, readonly) Block *body;
@property (nonatomic, strong, readonly) CallSignature *callSignature;

- (instancetype)initWithName:(NSString *)name body:(Block * _Nullable)body;

- (instancetype)initWithBeginPos:(Position *)beginPos
                          endPos:(Position *)endPos
                     isErrorNode:(BOOL)isErrorNode
                            name:(NSString *)name
                            body:(Block * _Nullable)body
                   callSignature:(CallSignature * _Nullable)callSignature;

@end

NS_ASSUME_NONNULL_END
