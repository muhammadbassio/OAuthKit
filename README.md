## AuthKit

#### OAuth2Client:

The base class for handling [OAuth2](https://www.oauth.com/oauth2-servers/oauth2-clients/mobile-and-native-apps/) flow on iOS using `SFSafariViewController` (`SFAuthenticationSession` for iOS11), currently supports`OAuth2CodeGrant` , tested on [Facebook](https://www.facebook.com) , [Google](https://www.google.com) &  [Github](https://www.github.com) (example app includes code for all).

`OAuth2Client`supports custom handlers for updating UI during the authentication flow.



## Requirements

- iOS 9.0+
- Xcode 9.0
- Swift 4.0



## Installation
### Manually

N8iveKit can be integrated manually into your project, dependency managers support coming soon.



#### Embedded Framework

- Add OAuthKit as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/muhammadbassio/OAuthKit.git
  ```

- Open the `OAuthKit` folder, and drag `OAuthKit.xcodeproj`  into the Project Navigator of your application's Xcode project.

- Navigate to the target configuration window by clicking on the blue project icon, and selecting the application target under the "Targets" heading in the sidebar.

- In the tab bar at the top of that window, open the "General" panel.

- Click on the `+` button under the "Embedded Binaries" section.

- Select the framework (currently `OAuthKit.framework`).

- Enjoy  :relaxed:



## Usage

Included Example app shows how to configure and use OAuthKit.

## Included Open source libraries

- [Alamofire](https://github.com/Alamofire/Alamofire) 
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) 
- [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) 

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## License

N8iveKit is released under the MIT license. [See LICENSE](https://github.com/n8iveapps/N8iveKit/blob/master/LICENSE) for details.