# TinkoffInvestSwiftSDK
![Swift Version](https://img.shields.io/badge/swift-5.5-orange) ![LISENCE](https://img.shields.io/badge/LICENSE-MIT-green)

TinkoffInvestSwiftSDK is a SDK for [Tinkoff Invest API V2](https://github.com/Tinkoff/investAPI) which works over gRPC. Main purpose of TinkoffInvestSwiftSDK is to simplify Tinkoff Invest API V2 usage in Swift.


### gRPC + Swift Combine 

As [Tinkoff Invest API V2](https://github.com/Tinkoff/investAPI) works over gRPC and therefore all network layer and domain models can be generated using [grpc-swift](https://github.com/grpc/grpc-swift). But gRPC's implementation generated in Swift is quite unpleasant to work with. Also it takes quite a time to setup generation, setup all Swift gRPC stack just to make one request. 
TinkoffInvestSwiftSDK provides more Swifty interfaces for Tinkoff API gRPC implematation so you can start using it with a few lines of code:

```swift

import Combine
import TinkoffInvestSDK

let tokenProvider = DefaultTokenProvider(token: <your_token>) // generate your personal token for Tinkoff Invest API
lazy var sdk = TinkoffInvestSDK(tokenProvider: tokenProvider)
var cancellables = Set<AnyCancellable>()

sdk.userService.getAccounts().flatMap {
   sdk.portfolioService.getPortfolio(accountID: $0.accounts.first!.id)
}.sink { result in
  switch result {
  case .failure(let error):
      print(error.localizedDescription)
  case .finished:
      print("did finish loading getPortfolio")
  }
} receiveValue: { portfolio in
  print(portfolio.totalAmountShares.asMoneyAmount.value)
}.store(in: &cancellables)

```

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
