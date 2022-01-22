
update:
	git clone https://github.com/Tinkoff/investAPI tmp
	rm -rf Sources/contracts/
	rm -rf Sources/TinkoffInvestSDK/gRPCModels
	cp -R tmp/src/docs/contracts/ Sources/contracts
	rm -rf tmp

	mkdir Sources/TinkoffInvestSDK/gRPCModels
	find Sources/contracts/ -type f -name "*.proto" -exec basename {} \; | ./generate.sh
	find Sources/TinkoffInvestSDK/gRPCModels -type f -exec sed -i '' 's/Tinkoff_Public_Invest_Api_Contract_V1_//g' {} \;
	rm -rf Sources/contracts/
