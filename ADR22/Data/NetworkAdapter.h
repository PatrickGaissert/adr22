//
//  NetworkAdapter.h
//  ADR22
//
//  Created by Patrick Gaißert on 05.07.22.
//  Copyright © 2022 MaibornWolff GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkAdapter : NSObject

- (void)retrieveEmployeeDataWithCompletionHandler:(void (^)(NSData * _Nullable data, NSError *error))completionHandler;

@end

NS_ASSUME_NONNULL_END
