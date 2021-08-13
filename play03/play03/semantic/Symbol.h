//
//  Symbol.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import <Foundation/Foundation.h>
#import "Decl.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SymKind) {
    SymKindVariable,
    SymKindFunction,
    SymKindClass,
    SymKindInterface
};
/**
 * 符号表条目
 */
@interface Symbol : NSObject
@property (nonatomic,   copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) Decl *decl;
@property (nonatomic, assign, readonly) SymKind kind;

- (instancetype)initWithName:(NSString *)name
                        decl:(Decl *)decl
                        kind:(SymKind)kind;

@end

NS_ASSUME_NONNULL_END
