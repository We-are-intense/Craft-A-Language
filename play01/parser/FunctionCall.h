//
//  FunctionCall.h
//  play01
//
//  Created by xiaerfei on 2021/8/9.
//

#import "Statement.h"
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
@interface FunctionCall : Statement
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSArray <NSString *>*parameters;
@property (nonatomic, strong, readwrite) FunctionDecl *definition;

- (instancetype)initWithName:(NSString *)name
                  parameters:(NSArray <NSString *>*)parameters;

@end

NS_ASSUME_NONNULL_END
