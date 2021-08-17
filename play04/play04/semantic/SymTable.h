//
//  SymTable.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"
#import "Decl.h"

NS_ASSUME_NONNULL_BEGIN

@interface SymTable : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary <NSString *, Symbol *> *table;

- (void)enterWithName:(NSString *)name decl:(Decl *)decl symType:(SymKind)symType;

- (BOOL)hasSymbolWithName:(NSString *)name;
- (Symbol *)getSymbolWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
