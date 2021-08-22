//
//  Type.h
//  play04
//
//  Created by 夏二飞 on 2021/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Type : NSObject

@property (nonatomic, copy) NSString *name;

- (instancetype)initWithName:(NSString *)name;


@end

NS_ASSUME_NONNULL_END
