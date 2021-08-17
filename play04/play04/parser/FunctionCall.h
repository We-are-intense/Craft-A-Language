//
//  FunctionCall.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "AstNode.h"
#import "Expression.h"
/*
 FunctionCall

 FunctionDecl(function、名称、body)
    ---> FunctionBody {
            FunctionCall
         }
 
 */
/**
 * 函数调用
 */
NS_ASSUME_NONNULL_BEGIN
@class FunctionDecl;
@interface FunctionCall : AstNode
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSArray <Expression *>*parameters;
@property (nonatomic, strong, readwrite) FunctionDecl *decl;

- (instancetype)initWithName:(NSString *)name
                  parameters:( NSArray <Expression *> * _Nullable )parameters;

@end

NS_ASSUME_NONNULL_END
