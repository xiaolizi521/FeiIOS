//
//  ViewController.m
//  singleview
//
//  Created by hongkai.qian on 12-2-9.
//  Copyright (c) 2012年 TTPod. All rights reserved.
//

#import <MediaPlayer/MPMediaQuery.h>
#import <MediaPlayer/MPMediaLibrary.h>
#import <MediaPlayer/MPMediaPlaylist.h>
#import <MediaPlayer/MPMediaItemCollection.h>

#import <objc/runtime.h>
#include <notify.h>

#import "ViewController.h"
#import "LyricItem.h"


#define KTTMessagePort "com.ttpod.ttdesktop.port2"

static CFMessagePortRef messagePort = NULL;

@interface MPMediaLibrary(Test)
+(void)syncGenerationDidChangeForLibraryDataProvider:(id)syncGeneration;
+(void)reloadDisplayValuesForLibraryDataProvider:(id)libraryDataProvider;
+(void)reloadDynamicPropertiesForLibraryDataProvider:(id)libraryDataProvider;
+(void)reloadLibraryDataProvider:(id)provider;
+(void)removeLibraryDataProvider:(id)provider removalReason:(int)reason;
+(void)addLibraryDataProvider:(id)provider;
+(id)libraryDataProviders;
+(id)_libraryDataProviders;
+(id)_libraryForDataProvider:(id)dataProvider;
+(id)mediaLibraryWithUniqueIdentifier:(id)uniqueIdentifier;
+(id)mediaLibraries;
+(id)_mediaLibraries;
+(void)setRunLoopForNotifications:(id)notifications;
+(void)setLibraryServerDisabled:(BOOL)disabled;
+(BOOL)isLibraryServerDisabled;
+(void)endDiscoveringMediaLibraries;
+(void)beginDiscoveringMediaLibraries;
+(id)deviceMediaLibrary;
+(void)setDefaultMediaLibrary:(id)library;
+(id)defaultMediaLibrary;
-(id)libraryDataProvider;
-(id)_initWithLibraryDataProvider:(id)libraryDataProvider;
-(void)_stopConnectionProgressDisplayLink;
-(void)_removeConnectionAssertion:(id)assertion;
-(void)_connectionProgressDisplayLinkCallback:(id)callback;
-(id)_collectionsForQueryCriteria:(id)queryCriteria;
-(void)_clearPendingDisconnection;
-(id)_itemsForQueryCriteria:(id)queryCriteria;
-(BOOL)playlistExistsWithPersistentID:(unsigned long long)persistentID;
-(BOOL)itemExistsWithPersistentID:(unsigned long long)persistentID;
-(void)setFilteringDisabled:(BOOL)disabled;
-(BOOL)isFilteringDisabled;
-(unsigned long long)_persistentIDForAssetURL:(id)assetURL;
-(id)pathForAssetURL:(id)assetURL;
-(BOOL)isValidAssetURL:(id)url;
-(id)syncValidity;
-(float)connectionProgress;
-(BOOL)performTransactionWithBlock:(id)block;
-(id)connectionAssertionWithIdentifier:(id)identifier;
-(void)connectWithAuthenticationData:(id)authenticationData completionBlock:(id)block;
-(BOOL)requiresAuthentication;
-(id)preferredSubtitleLanguages;
-(id)preferredAudioLanguages;
-(BOOL)isGeniusEnabled;
-(double)timestampForAppliedUbiquitousBookmarkKey:(id)appliedUbiquitousBookmarkKey;
-(void)updateUbiquitousBookmarksWithKey:(id)key bookmarkMediaValue:(id)value timestamp:(double)timestamp;
-(void)downloadItem:(id)item completionHandler:(id)handler;
-(BOOL)isArtworkIdenticalForItem:(id)item otherItem:(id)item2 compareRepresentativeItemArtwork:(BOOL)artwork missingAlwaysComparesEqual:(BOOL)equal;
-(BOOL)removePlaylist:(id)playlist;
-(BOOL)removeItems:(id)items;
-(id)addPlaylistWithName:(id)name activeGeniusPlaylist:(BOOL)playlist;
-(id)addPlaylistWithName:(id)name;
-(id)playlistWithPersistentID:(unsigned long long)persistentID;
-(id)newPlaylistWithPersistentID:(unsigned long long)persistentID;
-(id)itemWithPersistentID:(unsigned long long)persistentID verifyExistence:(BOOL)existence;
-(id)itemWithPersistentID:(unsigned long long)persistentID;
-(BOOL)hasVideoPodcasts;
-(BOOL)hasTVShows;
-(BOOL)hasMovieRentals;
-(BOOL)hasITunesUContent;
-(BOOL)hasCompilations;
-(BOOL)hasMovies;
-(BOOL)hasAudibleAudioBooks;
-(BOOL)hasMusicVideos;
-(BOOL)hasVideos;
-(BOOL)_checkHasContent:(BOOL*)content determined:(BOOL*)determined mediaType:(int)type queryIsEmptyBlock:(id)block;
-(BOOL)_checkHasContent:(BOOL*)content determined:(BOOL*)determined queryIsEmptyBlock:(id)block;
-(BOOL)hasAudiobooks;
-(BOOL)hasComposers;
-(BOOL)hasGenres;
-(BOOL)hasPodcasts;
-(BOOL)hasSongs;
-(BOOL)hasAlbums;
-(BOOL)hasArtists;
-(BOOL)hasPlaylists;
-(BOOL)hasGeniusMixes;
-(BOOL)hasMedia;
-(BOOL)hasMediaOfType:(int)type;
-(BOOL)libraryHasBeenModifiedWithToken:(id)token;
-(id)modificationToken;
-(id)uniqueIdentifier;
-(id)name;
-(int)status;
-(BOOL)writable;
-(long long)playlistGeneration;
-(unsigned long long)syncGenerationID;
-(void)endGeneratingLibraryChangeNotifications;
-(void)disconnect;
-(void)connectWithCompletionHandler:(id)completionHandler;
-(void)beginGeneratingLibraryChangeNotifications;
-(void)_displayValuesDidChangeNotification:(id)_displayValues;
-(void)_didReceiveMemoryWarning:(id)warning;
-(void)_reloadLibraryForDynamicPropertyChangeWithNotificationInfo:(id)notificationInfo;
-(void)_reloadLibraryForContentsChangeWithNotificationInfo:(id)notificationInfo;
-(void)_clearCachedContentData;
-(void)_clearCachedEntities;
@end

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)dealloc
{
	if (messagePort != NULL)
	{
		CFRelease(messagePort);
	}
	
	[lbltext release];
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 72, 37)];
	[btn1 setTitle:@"上一首" forState:UIControlStateNormal];
	[btn1 addTarget:self action:@selector(btn1Clicked:) forControlEvents:UIControlEventTouchUpInside];
//	btn1
	[self.view addSubview:btn1];
	[btn1 release];
	
	UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btn2 setFrame:CGRectMake(110, 10, 72, 37)];
	[btn2 setTitle:@"下一首" forState:UIControlStateNormal];
	[btn2 addTarget:self action:@selector(btn1Clicked:) forControlEvents:UIControlEventTouchDown];
	//	btn2
	[self.view addSubview:btn2];
	
	messagePort = CFMessagePortCreateRemote(kCFAllocatorDefault, CFSTR(KTTMessagePort));
	if (messagePort != NULL)
	{
		BOOL sucess = CFMessagePortIsValid(messagePort);
		NSLog(@"CFMessagePortCreateRemote result: 0x%08X %d", (int)messagePort, sucess);
	}
}

- (void)viewDidUnload
{
	[lbltext release];
	lbltext = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	CFRelease(messagePort);
	messagePort = NULL;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)btn1Clicked:(id)sender
{
//	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"BtnClicked" message:@"you clicked button" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	if (_statusBar == nil)
	{
		_statusBar = [[KaiStatusBar alloc] initWithFrame:CGRectZero];
		[_statusBar showWithStatusMessage:@"测试这，测试那……"];
	}
	else
	{
		[_statusBar hide];
		[_statusBar release];
		_statusBar = nil;
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)tttClicked:(id)sender
{
//	UIButton* aaa = (UIButton *)sender;
//	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"ttttttt" message:@"you clicked button" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	
	
//	NSFileManager *fileManager = [NSFileManager defaultManager];  
//	NSDirectoryEnumerator *dirnum = [[NSFileManager defaultManager] enumeratorAtPath: @"/private/"];  
//	NSString *nextItem = nil;  
//	while( (nextItem = [dirnum nextObject]))
//	{  
//		if ([[nextItem pathExtension] isEqualToString: @"db"] 
//			|| [[nextItem pathExtension] isEqualToString: @"sqlitedb"])
//		{  
//	         if ([fileManager isReadableFileAtPath:nextItem])
//			 {  
//	             NSLog(@"kai:file can read. %@", nextItem);
//	         }
//	     }
//	}
	
//	NSString* filePath = @"/private/var/mobile/Media/general_storage/textfile.txt";
//	NSString* data = @"I am 凯凯";
//	NSError* error = nil;
//	BOOL sucess = [data writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
//	NSLog(@"kai write %d, %@", sucess, error);
	
//	id xxxx = objc_getClass("SBWiFiManager");
//	[[xxxx sharedInstance] setWiFiEnabled:NO];
	
	uint32_t r = notify_post("com.ttpod.kaisubstrate.eventname");
	NSLog(@"kai_eventname:r=%d", r);
}

- (IBAction)wifi_off:(id)sender
{
	uint32_t r = notify_post("com.ttpod.kaisubstrate.wifi_off");
	NSLog(@"kai_wifi_off:r=%d", r);
}

- (IBAction)wifi_on:(id)sender
{
	uint32_t r = notify_post("com.ttpod.kaisubstrate.wifi_on");
	NSLog(@"kai_wifi_on:r=%d", r);
}

- (IBAction)nsnumberused:(id)sender
{
	NSNumber* number = [NSNumber numberWithLongLong:6789];
	long long value = [number longLongValue];
	NSLog(@"singleview: long long value is %lld", value);
}

- (IBAction)btnPortClicked:(id)sender
{
	if (messagePort == NULL) return;
	
	UIButton* btn = (UIButton *)sender;
	CFDataRef data = NULL;
	SInt32 rPort = 0;
	switch (btn.tag)
	{
		case 1001:
		{
			char message[256] = "kai";
			data = CFDataCreate(NULL, (UInt8 *)message, strlen(message) + 1);
			if (data != NULL)
			{
				rPort = CFMessagePortSendRequest(messagePort, btn.tag, data, 0.0, 0.0, NULL, NULL);
				CFRelease(data);
				NSLog(@"qhk: CFMessagePortSendRequest result: %ld", rPort);
			}
			else
			{
				NSLog(@"qhk: create data error");
			}
		}
			break;
			
		case 1002:
		{
			
			rPort = CFMessagePortSendRequest(messagePort, btn.tag, NULL, 0.0, 0.0, NULL, NULL);
			NSLog(@"qhk: CFMessagePortSendRequest result: %ld", rPort);
		}
			break;
			
		case 1003:
		{
			int count = 100;
			for (int idx = 0; idx < count; ++idx)
			{
				rPort = CFMessagePortSendRequest(messagePort, btn.tag, NULL, 0.0, 0.0, NULL, NULL);
				if (rPort != 0)
				{
					NSLog(@"qhk: CFMessagePortSendRequest result: %ld", rPort);
					break;
				}
				[NSThread sleepForTimeInterval:0.075];
			}
		}
			break;
			
		case 1004:
		{
			char message[200 * 1024] = "kai 200 * 1024";
			data = CFDataCreate(NULL, (UInt8 *)message, 200 * 1024);
			if (data != NULL)
			{
				rPort = CFMessagePortSendRequest(messagePort, btn.tag, data, 0.0, 0.0, NULL, NULL);
				CFRelease(data);
				NSLog(@"qhk: CFMessagePortSendRequest result: %ld", rPort);
			}
			else
			{
				NSLog(@"qhk: create data error");
			}
		}
			break;
			
		default:
			break;
	}
}

- (IBAction)btnNSCoderClicked:(id)sender
{
	LyricData* oriLyricData = [[LyricData alloc] init];
	NSLog(@"Ori LyricData: %@", oriLyricData);
	
	NSData* oriData = [NSKeyedArchiver archivedDataWithRootObject:oriLyricData];
	NSLog(@"oriData len=%d %@", [oriData length], oriData);
	
	
	LyricData* afterLyricData = [NSKeyedUnarchiver unarchiveObjectWithData:oriData];
	NSLog(@"after LyricData: %@", afterLyricData);
}

#include <execinfo.h>
#include <stdio.h>
#include <stdlib.h>

void print_trace (void)
{
	void *array[20];
	size_t size;
	char **strings;
	size_t i;
	
	size = backtrace (array, 20);
	strings = backtrace_symbols (array, size);
	
	NSMutableString* str = [NSMutableString stringWithFormat:@"qhk: Obtained %zd stack frames.\n", size];
//	printf ("Obtained %zd stack frames.\n", size);
	
	for (i = 0; i < size; i++)
	{
//		printf ("%s\n", strings[i]);
		[str appendFormat:@"%s\n", strings[i]];
	}
	
	free (strings);
	NSLog(@"%@", str);
}

- (IBAction)btnDeletePod:(id)sender
{
	print_trace();
	return;
	
	NSSet* librarys = [MPMediaLibrary _mediaLibraries];
	MPMediaLibrary* library = [MPMediaLibrary defaultMediaLibrary];
	MPMediaLibrary* libDevice = [MPMediaLibrary deviceMediaLibrary];
	NSMutableString* str2 = [NSMutableString stringWithFormat:@"library count = %d, %@\n", [librarys count], librarys];
	for(MPMediaLibrary * lib in [librarys allObjects])
	{
		[str2 appendFormat:@"%@:%d ", NSStringFromClass([lib class]), [lib writable]];
	}
	[str2 appendFormat:@"\ndefalutlib=%p, devicelib=%p", library, libDevice];
	
	NSSet* dataProviders = [MPMediaLibrary libraryDataProviders];
	[str2 appendFormat:@" provider count=%d ", [dataProviders count]];
	for(id provider in [dataProviders allObjects])
	{
		[str2 appendFormat:@"%@: ", NSStringFromClass([provider class])];
	}
	
	
	lbltext.text = str2;
	
	return;
	
	
	NSDate* date = [library lastModifiedDate];
	MPMediaQuery* songsQuery = [MPMediaQuery songsQuery];
    NSArray* songs = [songsQuery items];
	NSMutableString* str = [NSMutableString stringWithFormat:@"%@\ncount=%d", date ,[songs count]];
	if ([songs count] > 0)
	{
		MPMediaItem* item = [songs objectAtIndex:0];
		NSArray* deleteItems = [NSArray arrayWithObject:item];
//		MPMediaItemCollection* coll = [MPMediaItemCollection collectionWithItems:deleteItems];
	

		
		BOOL haveRemove = [library respondsToSelector:@selector(removeItems:)];
		BOOL removeSucess = NO;
		if (haveRemove)
		{
			removeSucess = [library removeItems:deleteItems];
		}
		
		[str appendFormat:@"\n%@ - %@\nhaveRemoveItems:%d %d", [item valueForProperty:MPMediaItemPropertyArtist], [item valueForProperty:MPMediaItemPropertyTitle], haveRemove,removeSucess];
    }
	lbltext.text = str;
}

- (int)addtwodata:(int)a withdata:(int)b
{
	return a + b;
}

int chengtwo(int a)
{
	return a * 2;
}

- (IBAction)btnInfoBClicked:(id)sender
{
	print_trace();
	int c = [self addtwodata:5 withdata:6];
	int d = chengtwo(c);
	NSLog(@"result: %d", d);
}
@end