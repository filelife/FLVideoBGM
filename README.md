# FLVideoBGM
This repository encapsulate a function for adding background music to a video.

### Import FLVideoBGM
```
 pod 'FLVideoBGM', '~>1.1.0'
```

Don't forget to add 'Privacy - Photo Library Usage Description' and 'Privacy - Photo Library Additions Usage Description' into info.plist.

```
#import "FLVideoBGM.h"
```

### How to
Just input video url and music url.
```
[FLVideoBGMManager processVideo:videoUrl 
                    InsertMusic:musicUrl 
               CompletionHandle:^(NSString *resultOutputFilePath, NSString *errorInfo) {

}];
```

Check to see if app's album is exist.You should check it before your save video.

```
[FLAssetsManager checkAlbumBeforeSaveWithCompletionHandler:^(BOOL createNewCollection) {

}]
```

Save edited video.
```
[FLAssetsManager saveVideoWithUrl:[NSURL URLWithString:outputFilePath]];
```

Check the demo to see more.
