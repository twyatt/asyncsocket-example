//
//  SocketTestViewController.m
//  SocketTest
//
//  Created by Travis Wyatt on 9/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SocketTestViewController.h"


@interface SocketTestViewController (Private)
- (void)connect;
- (void)sendHTTPRequest;
- (void)readWithTag:(long)tag;
@end

@implementation SocketTestViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	socket = [[AsyncSocket alloc] initWithDelegate:self];
	[self connect];
}

#pragma mark -

- (void)connect {
	[socket connectToHost:@"www.google.com" onPort:80 error:nil];
}

- (void)sendHTTPRequest {
	NSString *string = [[NSString alloc] initWithString:@"GET / HTTP/1.1\r\n"
						"Host: www.google.com\r\n"
						"User-Agent: AsyncSocket/1.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.0.0.0) Gecko/20100923 AsyncSocket/1.0.0\r\n"
						"Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n"
						"Accept-Language: en-us,en;q=0.5\r\n"
						"Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\n"
						"Cache-Control: max-age=0\r\n\r\n"];
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	[string release];
	
	NSLog(@"Sending HTTP Request.");
	[socket writeData:data withTimeout:-1 tag:1];
}

- (void)readWithTag:(long)tag {
	// reads response line-by-line
	[socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}

#pragma mark -
#pragma mark AsyncSocket Methods

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
	NSLog(@"Disconnecting. Error: %@", [err localizedDescription]);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
	NSLog(@"Disconnected.");
	
	[socket setDelegate:nil];
	[socket release];
	socket = nil;
}

- (BOOL)onSocketWillConnect:(AsyncSocket *)sock {
	NSLog(@"onSocketWillConnect:");
	return YES;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
	NSLog(@"Connected To %@:%i.", host, port);
	
	[self readWithTag:2];
	[self sendHTTPRequest];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	/**
	 * Convert data to a string for logging.
	 *
	 * http://stackoverflow.com/questions/550405/convert-nsdata-bytes-to-nsstring
	 */
	NSString *string = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
	NSLog(@"Received Data (Tag: %i): %@", tag, string);
	[string release];
	
	[self readWithTag:3];
}

- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(CFIndex)partialLength tag:(long)tag {
	NSLog(@"onSocket:didReadPartialDataOfLength:%i tag:%i", partialLength, tag);
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	NSLog(@"onSocket:didWriteDataWithTag:%i", tag);
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[socket release];
	[super dealloc];
}

@end
