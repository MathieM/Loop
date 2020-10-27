ARGS =  # Additional args
PIPEFAIL = set -o pipefail && 
XCODEBUILD = $(PIPEFAIL) xcodebuild -project Loop.xcodeproj
XCPRETTY = | xcpretty
XCPRETTY_TRAVIS = $(XCPRETTY) -f `xcpretty-travis-formatter`


## 
## Project
## -------
## 

build-and-test: # Build the app target
build-and-test: cartage build test

ci: # Build and test the app target like ci (but local)
ci: build-and-test

cartage: # Cartage script
cartage: 
	- $(XCODEBUILD) -target Cartfile  | tee cartfile-xcodebuild.log $(XCPRETTY) $(ARGS)

build: # Build the app target
build: 
	- $(XCODEBUILD) -scheme Loop build CODE_SIGN_IDENTITY="" CODE_SIGNING_ALLOWED=NO  | tee loop-build-xcodebuild.log $(XCPRETTY) $(ARGS)
	- $(XCODEBUILD) -scheme Learn build CODE_SIGN_IDENTITY="" CODE_SIGNING_ALLOWED=NO  | tee learn-build-xcodebuild.log $(XCPRETTY) $(ARGS)

test: # Run the test target
test: 
	- $(XCODEBUILD) -scheme LoopTests -destination 'name=iPhone 8' test  | tee loop-test-xcodebuild.log $(XCPRETTY) $(ARGS)
	- $(XCODEBUILD) -scheme DoseMathTests -destination 'name=iPhone 8' test  | tee dose-math-test-xcodebuild.log $(XCPRETTY) $(ARGS) 

.PHONY: build-and-test ci cartage build test

## 
## Travis
## -------
## 

pre-travis: 
	- $(eval XCPRETTY := $(XCPRETTY_TRAVIS))

travis: # Build and test the app target like travis
travis: pre-travis travis-build travis-test

travis-before: # Before script in travis
travis-before: pre-travis cartage

travis-build: # Build the app target in travis
travis-build: pre-travis build

travis-test: # Run the test target in travis
travis-test: pre-travis test

.PHONY: pre-travis travis travis-before travis-build travis-test

.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help
