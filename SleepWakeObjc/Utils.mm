//
//  Utils.m
//  SleepWakeObjc
//
//  Created by Nghia Tran on 12/5/18.
//  Copyright © 2018 com.nsproxy.proxy. All rights reserved.
//

#import "Utils.h"
#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

#include <mach/mach_port.h>
#include <mach/mach_interface.h>
#include <mach/mach_init.h>

#include <IOKit/pwr_mgt/IOPMLib.h>
#include <IOKit/IOMessage.h>

io_connect_t  root_port; // a reference to the Root Power Domain IOService

@implementation Utils {
    io_object_t            notifierObject;
    IONotificationPortRef  notifyPortRef;
}

void
MySleepCallBack( void * refCon, io_service_t service, natural_t messageType, void * messageArgument )
{
    printf( "messageType %08lx, arg %08lx\n",
           (long unsigned int)messageType,
           (long unsigned int)messageArgument );

    switch ( messageType )
    {

        case kIOMessageCanSystemSleep:
            /* Idle sleep is about to kick in. This message will not be sent for forced sleep.
             Applications have a chance to prevent sleep by calling IOCancelPowerChange.
             Most applications should not prevent idle sleep.

             Power Management waits up to 30 seconds for you to either allow or deny idle
             sleep. If you don't acknowledge this power change by calling either
             IOAllowPowerChange or IOCancelPowerChange, the system will wait 30
             seconds then go to sleep.
             */

            //Uncomment to cancel idle sleep
            //IOCancelPowerChange( root_port, (long)messageArgument );
            // we will allow idle sleep
            NSLog(@"kIOMessageCanSystemSleep");
            IOAllowPowerChange( root_port, (long)messageArgument );
            break;

        case kIOMessageSystemWillSleep:
            NSLog(@"kIOMessageSystemWillSleep");
            /* The system WILL go to sleep. If you do not call IOAllowPowerChange or
             IOCancelPowerChange to acknowledge this message, sleep will be
             delayed by 30 seconds.

             NOTE: If you call IOCancelPowerChange to deny sleep it returns
             kIOReturnSuccess, however the system WILL still go to sleep.
             */

            IOAllowPowerChange( root_port, (long)messageArgument );
            break;

        case kIOMessageSystemWillPowerOn:
            //System has started the wake up process...

            NSLog(@"kIOMessageSystemWillPowerOn");
            break;

        case kIOMessageSystemHasPoweredOn:
            //System has finished waking up...
            NSLog(@"kIOMessageSystemHasPoweredOn");
            break;

        default:
            break;

    }
}

-(void) setup {

    // notification port allocated by IORegisterForSystemPower
    //IONotificationPortRef  notifyPortRef;

    // notifier object, used to deregister later
    //io_object_t            notifierObject;
    // this parameter is passed to the callback
    void*                  refCon;

    // register to receive system sleep notifications

    root_port = IORegisterForSystemPower( refCon, &notifyPortRef, MySleepCallBack, &notifierObject );
    if ( root_port == 0 )
    {
        printf("IORegisterForSystemPower failed\n");
        return;
    }

    // add the notification port to the application runloop
    CFRunLoopAddSource( CFRunLoopGetCurrent(),
                       IONotificationPortGetRunLoopSource(notifyPortRef), kCFRunLoopCommonModes );
}

- (void)dealloc
{
    // we no longer want sleep notifications:

    // remove the sleep notification port from the application runloop
    CFRunLoopRemoveSource( CFRunLoopGetCurrent(),
                          IONotificationPortGetRunLoopSource(notifyPortRef),
                          kCFRunLoopCommonModes );

    // deregister for system sleep notifications
    IODeregisterForSystemPower( &notifierObject );

    // IORegisterForSystemPower implicitly opens the Root Power Domain IOService
    // so we close it here
    IOServiceClose( root_port );

    // destroy the notification port allocated by IORegisterForSystemPower
    IONotificationPortDestroy( notifyPortRef );
}

@end
