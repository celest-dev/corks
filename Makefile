.PHONY: protos clean

DART_OUT := $(PWD)/dart/lib/src/proto
GO_OUT := $(PWD)/go/proto

protos:
	buf lint
	buf generate
	cd dart; dart format .; dart analyze --fatal-infos --fatal-warnings .
	cd go; go mod tidy

clean:
	rm -rf $(DART_OUT)
	rm -rf $(GO_OUT)
