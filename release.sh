podspec-bump -w
git commit -am "bump `podspec-bump --dump-version`" 
git tag "`podspec-bump --dump-version`"
git push --tags
pod trunk push iOSFileSystem.podspec --verbose --allow-warning
