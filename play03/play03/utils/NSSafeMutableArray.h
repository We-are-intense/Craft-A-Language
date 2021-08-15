//
//  NSSafeMutableArray.h
//  play03
//
//  Created by xiaerfei on 2021/8/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSafeMutableArray : NSMutableArray
/// 返回第一个元素并删除
- (id)shift;
@end

NS_ASSUME_NONNULL_END
