# AutoToggleHeaderFooterView

[![Version](https://img.shields.io/cocoapods/v/AutoToggleHeaderFooterView.svg?style=flat)](http://cocoapods.org/pods/AutoToggleHeaderFooterView)
[![License](https://img.shields.io/cocoapods/l/AutoToggleHeaderFooterView.svg?style=flat)](http://cocoapods.org/pods/AutoToggleHeaderFooterView)
[![Platform](https://img.shields.io/cocoapods/p/AutoToggleHeaderFooterView.svg?style=flat)](http://cocoapods.org/pods/AutoToggleHeaderFooterView)

A header and footer toggle display-state depending on the scroll or time interval


## Requirements

- iOS 8.0+
- Swift 3.0.2

## Gif

![movie](https://cloud.githubusercontent.com/assets/9880704/24184555/e81a9e00-0f11-11e7-84a7-49ca89f5cbfd.gif)


## Try Demo

You can try Demo app quickly.

```
$ pod try 'AutoToggleHeaderFooterView'
```


## Usage

### Require call this!

```swift
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    // If scrollview under the translucent NavigationBar, use this.
    autoToggleView.register(scrollView: tableView)
}


// UIScrollViewDelegate

func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
    autoToggleView.showHeaderFooter(withDuration: 0.3)
    return true
}
```

### TableView Example

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    // Initialize with any header or footer
    let autoToggleView = AutoToggleHeaderFooterView(header: header, footer: footer)
    autoToggleView.addScrollView(tableView)

    // Add to any view
    view.addSubview(autoToggleView)

    // If scrollview under the translucent NavigationBar, use this.
    // And call `AutoToggleHeaderFooterView.register(scrollView:) at `viewDidLayoutSubviews`.
    autoToggleView.makeEdgesEqualToSuperview()

    // Or not under the NavigationBar
//    automaticallyAdjustsScrollViewInsets = false
//    makeEdgesFitToLayoutGuide(view: autoToggleView)
}

```

### WebView Example

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    let autoToggleView = AutoToggleHeaderFooterView(header: header, footer: footer)
    autoToggleView.addSubview(self.webView)
    autoToggleView.register(scrollView: self.webView.scrollView)

    automaticallyAdjustsScrollViewInsets = false

    view.addSubview(autoToggleView)
    makeEdgesFitToLayoutGuide(view: autoToggleView)

    webView.makeEdgesEqualToSuperview()
    webView.load(URLRequest(url: URL(string: "https://www.recruit-lifestyle.co.jp/")!))
}
```


### Change options

```swift
public var isTimerEnabled = true
public var isScrollHeaderFooterEnabled = true
public var showAnimationDuration = TimeInterval(0.5)
public var autoShowTimeInterval = TimeInterval(3.0)
```


## Installation

AutoToggleHeaderFooterView is available through [CocoaPods](http://cocoapods.org) or [Carthage](https://github.com/Carthage/Carthage).

### CocoaPods

To install it, simply add the following line to your Podfile:

```ruby
pod "AutoToggleHeaderFooterView"
```

### Carthage

To install it, simply add the following line to your Cartfile:

```
github "recruit-lifestyle/AutoToggleHeaderFooterView"
```


## Credits

AutoToggleHeaderFooterView is owned and maintained by [RECRUIT LIFESTYLE CO., LTD.](http://www.recruit-lifestyle.co.jp/)

AutoToggleHeaderFooterView was originally created by [Tomoya Hayakawa](https://github.com/simorgh3196)


## License

```
Copyright 2017 RECRUIT LIFESTYLE CO., LTD.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
