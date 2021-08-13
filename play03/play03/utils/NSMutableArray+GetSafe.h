//
//  NSMutableArray+GetSafe.h
//  play03
//
//  Created by 夏二飞 on 2021/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (GetSafe)

/// 返回第一个元素并删除
- (id)shift;

@end

NS_ASSUME_NONNULL_END
