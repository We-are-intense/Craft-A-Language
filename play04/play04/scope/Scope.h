//
//  Scope.h
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"


NS_ASSUME_NONNULL_BEGIN

@interface Scope : NSObject

@property (nonatomic, strong) NSMutableDictionary <NSString *, Symbol *> *name2sym;
///< 上级作用域，顶级作用域的上一级是null
@property (nonatomic, strong) Scope *enclosingScope;

- (instancetype)initWithEnclosingScope:(Scope *)enclosingScope;
/**
 * 把符号记入符号表（作用域）
 * @param name name
 * @param sym symbol
 */
- (void)enterWithName:(NSString *)name sym:(Symbol *)sym;
/**
 * 查询是否有某名称的符号
 * @param name name
 */
- (BOOL)hasSymbolWithName:(NSString *)name;
/**
 * 根据名称查找符号。
 * @param name 符号名称。
 * @returns 根据名称查到的Symbol。如果没有查到，则返回null。
 */
- (Symbol *)getSymbolWithName:(NSString *)name;
/**
 * 级联查找某个符号。
 * 先从本作用域查找，查不到就去上一级作用域，依此类推。
 * @param name name
 */
- (Symbol *)getSymbolCascade:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
