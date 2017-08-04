# FLVideoBGM
This repository encapsulate a function for adding background music to a video.

### Import FLVideoBGM
```
 pod 'FLVideoBGM', '~>1.0.1'
```

Don't forget to add 'Privacy - Photo Library Usage Description' and 'Privacy - Photo Library Additions Usage Description' into info.plist.

```
#import "FLVideoBGMManager.h"

```

### How to
Just input video url and music url.
```
[FLVideoBGMManager processVideo:videoUrl 
                    InsertMusic:musicUrl 
               CompletionHandle:^(NSString *resultOutputFilePath, NSString *errorInfo) {

}];
```

Save the video into syetem album.
```
[FLAssetsManager checkAlbumBeforeSaveWithCompletionHandler:^(BOOL createNewCollection) {

}]
```

