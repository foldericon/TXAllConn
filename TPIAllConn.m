/*
 ===============================================================================
 Copyright (c) 2013-2014, Tobias Pollmann (foldericon)
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the <organization> nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ===============================================================================
*/


#import "TPIAllConn.h"

@implementation TPIAllConn

#pragma mark -
#pragma mark User Input

- (void)userInputCommandInvokedOnClient:(IRCClient *)client
                          commandString:(NSString *)commandString
                          messageString:(NSString *)messageString
{
    NSArray *argsAry = [messageString componentsSeparatedByString:@" "];
    NSString *cmd = [[argsAry subarrayWithRange:NSMakeRange(1, argsAry.count-1)] componentsJoinedByString:@" "];
    if([[argsAry objectAtIndex:0] isEqualToString:@"-a"] && argsAry.count > 1) {
        for (IRCClient *cl in self.worldController.clientList) {
            if([argsAry[1] hasPrefix:@"#"]) {
                IRCChannel *ch = [cl findChannel:argsAry[3]];
                if(ch != nil)
                    [cl sendCommand:cmd completeTarget:YES target:ch.name];
                else
                    [client sendCommand:[NSString stringWithFormat:@"DEBUG channel %@ not found", argsAry[1]]];
            } else {
                [cl sendCommand:cmd];
            }
        }
    } else if([[argsAry objectAtIndex:0] length] > 4 && argsAry.count > 1) {
        BOOL found = NO;
        for (IRCClient *cl in self.worldController.clientList) {
            if([cl.uniqueIdentifier hasPrefix:[argsAry objectAtIndex:0]]) {
                if([argsAry[1] hasPrefix:@"#"]) {
                    cmd = [[argsAry subarrayWithRange:NSMakeRange(2, argsAry.count-2)] componentsJoinedByString:@" "];
                    IRCChannel *ch = [cl findChannel:argsAry[1]];
                    if(ch != nil)
                        [cl sendCommand:cmd completeTarget:YES target:ch.name];
                    else
                        [client sendCommand:[NSString stringWithFormat:@"DEBUG channel %@ not found", argsAry[1]]];
                } else {
                    [cl sendCommand:cmd];
                }
                found = YES;
                break;
            }
        }
        if(!found)
            [client sendCommand:[NSString stringWithFormat:@"DEBUG client id %@ not found", argsAry[0]]];
    } else {
        [client sendCommand:@"DEBUG USAGE: /allconn <-a|ID> [channel] <command>"];
    }
}

- (NSArray *)subscribedUserInputCommands
{
	return @[@"allconn"];
}

@end
