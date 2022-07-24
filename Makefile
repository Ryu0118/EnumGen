BINARY_PATH = ./.build/x86_64-apple-macosx/release/EnumGenCLI

.PHONY: release
release:
	mkdir -p release
	swift build -c release
	cp $(BINARY_PATH) release/enumgen

.PHONY: test
test:
	make release --no-print-directory
	release/enumgen release/sfsymbols.txt --enum-name SFSymbols --delimiter -
	cat release/SFSymbols.swift
	
