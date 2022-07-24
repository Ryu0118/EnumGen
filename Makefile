BINARY_PATH = /Users/shibuya/Swift-Library/EnumGen/.build/x86_64-apple-macosx/release/EnumGenCLI

.PHONY: release
release:
	mkdir -p release
	swift build -c release
	cp $(BINARY_PATH) release/enumgen
