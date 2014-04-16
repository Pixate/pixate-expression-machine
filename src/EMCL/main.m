//
//  main.m
//  ExpressionMachine
//
//  Created by Kevin Lindsey on 3/8/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXCommandExecutor.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSMutableArray *args = [[NSMutableArray alloc] init];

        for (int i = 1; i < argc; i++)
        {
            NSString *arg = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];

            [args addObject:arg];
        }

        PXCommandExecutor *executor = [[PXCommandExecutor alloc] init];

        [executor processArgs:args];
        [executor run];
    }

    return 0;
}
