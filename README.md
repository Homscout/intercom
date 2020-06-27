# capacitor-intercom [![npm version](https://badge.fury.io/js/capacitor-intercom.svg)](https://badge.fury.io/js/capacitor-intercom)
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

Capacitor plugin to enable features from [Intercom](https://www.intercom.com)

## API

- registerIdentifiedUser
- registerUnidentifiedUser
- updateUser
- logout
- logEvent
- displayMessenger
- displayMessageComposer
- displayHelpCenter
- hideMessenger
- displayLauncher
- hideLauncher
- displayInAppMessages
- hideInAppMessages
- setUserHash
- setBottomPadding

## Usage

```js
import { Intercom } from "capacitor-intercom";
const intercom = new Intercom();

import { Plugins } from "@capacitor/core";
const { PushNotifications } = Plugins;

//
// Register for push notifications from Intercom
PushNotifications.register()

//
// Register an indetified user
intercom
  .registerIdentifiedUser({ userId: 123456 }) // or email or both

//
// Register a log event
intercom
  .logEvent({ name: "my-event", data: { pi: 3.14 } })

//
// Display the message composer
intercom
  .displayMessageComposer({ message: "Hello there!" } })

//
// Identity Verification
// https://developers.intercom.com/installing-intercom/docs/ios-identity-verification
intercom
  .setUserHash({ hmac: "xyz" } })
```

## iOS setup

- `ionic start my-cap-app --capacitor`
- `cd my-cap-app`
- `npm install —-save capacitor-intercom`
- `mkdir www && touch www/index.html`
- `npx cap add ios`
- add intercom keys to capacitor's configuration file

```
{
 …
  "plugins": {
   "IntercomPlugin": {
      "ios-apiKey": "ios_sdk-xxx",
      "ios-appId": "yyy"
    }
  }
…
}
```

- `npx cap open ios`
- sign your app at xcode (general tab)

> Tip: every time you change a native code you may need to clean up the cache (Product > Clean build folder) and then run the app again.

## Android setup

- `ionic start my-cap-app --capacitor`
- `cd my-cap-app`
- `npm install —-save capacitor-intercom`
- `mkdir www && touch www/index.html`
- `npx cap add android`
- add intercom keys to capacitor's configuration file

```
{
 …
  "plugins": {
   "IntercomPlugin": {
      "android-apiKey": "android_sdk-xxx",
      "android-appId": "yyy"
    }
  }
…
}
```

- `npx cap open android`
- `[extra step]` in android case we need to tell Capacitor to initialise the plugin:

> on your `MainActivity.java` file add `import io.stewan.capacitor.intercom.IntercomPlugin;` and then inside the init callback `add(IntercomPlugin.class);`

Now you should be set to go. Try to run your client using `ionic cap run android --livereload`.

> Tip: every time you change a native code you may need to clean up the cache (Build > Clean Project | Build > Rebuild Project) and then run the app again.

## Sample app

(coming soon)

## You may also like

- [capacitor-fcm](https://github.com/stewwan/capacitor-fcm)
- [capacitor-analytics](https://github.com/stewwan/capacitor-analytics)
- [capacitor-crashlytics](https://github.com/stewwan/capacitor-crashlytics)
- [capacitor-twitter](https://github.com/stewwan/capacitor-twitter)

Cheers 🍻

Follow me [@Twitter](https://twitter.com/StewanSilva)

## License

MIT

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://twitter.com/StewanSilva"><img src="https://avatars1.githubusercontent.com/u/719763?v=4" width="75px;" alt=""/><br /><sub><b>Stew</b></sub></a><br /><a href="https://github.com/stewwan/@capacitor-community/intercom/commits?author=stewwan" title="Code">💻</a> <a href="https://github.com/stewwan/@capacitor-community/intercom/commits?author=stewwan" title="Documentation">📖</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!