WORKSPACE=MTD.xcworkspace
SCHEME=MTD
TMP_DIR=$(PWD)/build
PROFILE_UUID=""

dev:
	xcodebuild build \
		-sdk iphoneos \
     	-workspace $(WORKSPACE) \
     	-scheme $(SCHEME) \
     	-configuration Release \
     	clean build \
     	CONFIGURATION_BUILD_DIR=$(TMP_DIR) \
     	PROVISIONING_PROFILE=$(PROFILE_UUID) | xcpretty --no-utf

	xcrun -sdk iphoneos \
		PackageApplication build/MTD.app \
		-o $(TMP_DIR)/MTD.ipa \
		--embed KSB_dist.mobileprovision\

pod:
	rm -fr Pods Podfile.lock MTD.xcworkspace
	pod install

clean:
	rm -rf $(HOME)/Library/Developer/Xcode/DerivedData/MTD-*
	if [ -a $(TMP_DIR) ]; then rm -R $(TMP_DIR); fi;
	xcodebuild clean