//
//  NetworkAdapter.m
//  ADR22
//
//  Created by Patrick Gaißert on 05.07.22.
//  Copyright © 2022 MaibornWolff GmbH. All rights reserved.
//

#import "NetworkAdapter.h"
#import <os/log.h>

@implementation NetworkAdapter

- (void)retrieveEmployeeDataWithCompletionHandler:(void (^)(NSData * _Nullable, NSError * _Nullable))completionHandler {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"https://jsonblob.com/api/jsonBlob/993862457349128192"];

    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        os_log(OS_LOG_DEFAULT, "Retrieving divisions and employees via network.");

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            completionHandler(data, nil);
        } else {
            os_log(OS_LOG_DEFAULT, "HTTP %li, %@", (long)httpResponse.statusCode, error.description);
            completionHandler(nil, error);
        }
    }];

    [dataTask resume];
}

@end
