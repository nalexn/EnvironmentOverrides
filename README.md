# SwiftUI Environment Overrides

![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS-lightgrey) [![blog](https://img.shields.io/badge/blog-github-blue)](https://nalexn.github.io/?utm_source=nalexn_github) [![venmo](https://img.shields.io/badge/%F0%9F%8D%BA-Venmo-brightgreen)](https://venmo.com/nallexn)

A tiny library that adds a control panel for testing how SwiftUI app adapts for different color themes, accessibility settings, and localizations.

#### Make your QA team happy!

<div style="max-width:255px; display: block; margin-left: auto; margin-right: auto;"><img src="https://github.com/nalexn/blob_files/blob/master/images/EnvironmentOverrides.gif?raw=true"></div>

Inspired by "Environment Overrides" pane in Xcode, but allows to QA the actual running app instead of the preview in Xcode.

Supported settings that you can toggle on the fly:

* [Light / Dark mode](https://developer.apple.com/design/human-interface-guidelines/macos/visual-design/dark-mode/)
* [Localization](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/Introduction/Introduction.html)
* [Dynamic Type Text Size](https://developer.apple.com/documentation/uikit/uifont/scaling_fonts_automatically)
* [Right-to-Left User Interface](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/SupportingRight-To-LeftLanguages/SupportingRight-To-LeftLanguages.html)
* [Accessibility](https://developer.apple.com/documentation/uikit/accessibility/)

You can quickly take screenshots in different languages for iTunes Connect (the panel hides itself).

Attach the control panel with just one line of code:

```swift
ContentView()
    .attachEnvironmentOverrides()
```

Integration with Swift Package Manager:

1. In Xcode select **File ⭢ Swift Packages ⭢ Add Package Dependency...**
2. Copy-paste repository URL: **https://github.com/nalexn/EnvironmentOverrides**
3. Hit **Next** two times
4. Hit **Finish**


