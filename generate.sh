while read input
do
  protoc Sources/contracts/$input \
       --proto_path=Sources/contracts \
       --plugin=gRPC-plugins/protoc-gen-swift \
       --swift_opt=Visibility=Public \
       --swift_out=Sources/TinkoffInvestSDK/gRPCModels \
       --plugin=gRPC-plugins/protoc-gen-grpc-swift \
       --grpc-swift_opt=Visibility=Public \
       --grpc-swift_out=Sources/TinkoffInvestSDK/gRPCModels
done
