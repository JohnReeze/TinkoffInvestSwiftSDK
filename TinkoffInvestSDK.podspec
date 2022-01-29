Pod::Spec.new do |spec|

  spec.name = "TinkoffInvestSDK"
  spec.version = "0.2.0"
  spec.summary = "Swift SDK for Tinkoff Invest gRPC API"
  spec.description  = <<-DESC
                      TinkoffInvestSDK provides completely configured Swift SDK for Tinkoff Invest gRPC API
                      DESC
  spec.license = { :type => "MIT", :file => "LICENSE" }
  spec.source = { :git => "https://github.com/JohnReeze/TinkoffInvestSwiftSDK", :tag => "#{spec.version}" }
  spec.author = { "Mikhail Monakov" => "mm.monakov@gmail.com" }
  spec.homepage = "https://github.com/JohnReeze/TinkoffInvestSwiftSDK"

  spec.swift_version = "5.5"
  spec.ios.deployment_target = "15.0"
  spec.osx.deployment_target = "10.15"
  spec.source_files = 'Sources/TinkoffInvestSDK/**/*.swift'

  spec.dependency "gRPC-Swift", "1.6.0"
  spec.dependency "CombineGRPC", "1.0.8"

end
