//
//  SymTable.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import <Foundation/Foundation.h>
#import "Symbol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SymTable : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary <NSString *, Symbol *> *table;



@end

NS_ASSUME_NONNULL_END
