# TinkoffInvestSwiftSDK
![Swift Version](https://img.shields.io/badge/swift-5.5-orange) ![LISENCE](https://img.shields.io/badge/LICENSE-MIT-green)

TinkoffInvestSwiftSDK is a SDK for [Tinkoff Invest API](https://github.com/Tinkoff/investAPI) which works over gRPC. Main purpose of TinkoffInvestSwiftSDK is to simplify Tinkoff Invest API V2 usage in Swift.

### Adding TinkoffInvestSwiftSDK to Your Project

You can easily add TinkoffInvestSwiftSDK to your project using either Swift Package Manager or CocoaPods.

#### Swift Package Manager

Add the package dependency to your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/JohnReeze/TinkoffInvestSwiftSDK.git", from: "0.2.0"),
],
```

#### CocoaPods

Add the following line to your `Podfile`:

```text
pod 'TinkoffInvestSwiftSDK', :git => "https://github.com/JohnReeze/TinkoffInvestSwiftSDK.git", :tag => "0.2.0"
```

## Compatibility

Since this library integrates with Combine, it only works on platforms that support Combine. This currently means the following minimum versions:

Platform | Minimum Supported Version
--- | ---
macOS | 10.15 (Catalina)
iOS & iPadOS | 15
