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
### gRPC Streams + Combine

Another new feature of [Tinkoff Invest API V2](https://github.com/Tinkoff/investAPI) is that now it's possible to subscribe to realtime streams for any instrument. Underhood it uses a bidirectional streaming RPC. So with the help of Combine Publishers we hide all complexity of gRPC streams as follows

```swift

// as we first address market stream, it creates a stream and now we may have multiple receiveValue calls over time
sdk.marketDataServiceStream.subscribeToCandels(figi: "BBG00ZKY1P71", interval: .oneMinute).sink { result in
   print(result)
} receiveValue: { result in
   switch result.payload {
   case .trade(let trade):
      print(trade.price.asAmount)
   default:
      break
   }
}.store(in: &cancellables)

// as market stream is now active, it just subscribes to new trades for provided figi
sdk.marketDataServiceStream.subscribeToTrades(figi: "BBG00ZKY1P71").sink { result in
   print(result)
} receiveValue: { result in
   switch result.payload {
   case .candle(let candle):  // note that receiveValue in both sink closures calls every time the stream gets any message (can be a ping message with no payload)
      print(candle.figi)     // so it's better to check result.payload value before perform any other actions 
   default:
      break
   }
}.store(in: &cancellables)

// closes the stream 
sdk.marketDataServiceStream.cancelAllSubscribtions()

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
