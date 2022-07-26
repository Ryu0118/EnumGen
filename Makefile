BINARY_PATH = ./.build/x86_64-apple-macosx/release/EnumGenCLI

.PHONY: release
release:
	mkdir -p release
	swift build -c release
	cp $(BINARY_PATH) release/enumgen
	zip release/enumgen.zip release/enumgen
