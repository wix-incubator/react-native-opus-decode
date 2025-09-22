require "json"
package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-opus-decode"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.authors      = "Doron Pearl, Wix.com"
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.platforms    = { :ios => "12.0" }

  s.source       = { :git => "https://github.com/wix-incubator/react-native-opus-decode.git", :tag => s.version.to_s }

  s.source_files  = "ios/**/*.{m,mm,c,h}"
  s.exclude_files = [
    "ios/opus/Opus.xcframework/**", 
    "ios/Ogg.framework/**"
  ]

  s.public_header_files  = "ios/OpusDecode.h"
  s.private_header_files = [
    "ios/opusfile/**/*.h",
    "ios/oggsrc/**/*.h"
  ]

  s.vendored_frameworks = "ios/opus/Opus.xcframework"
  s.preserve_paths      = "ios/opus/Opus.xcframework/**/*"

  s.pod_target_xcconfig = {
    "HEADER_SEARCH_PATHS" => %w[
      $(PODS_TARGET_SRCROOT)/ios/opusfile
      $(PODS_TARGET_SRCROOT)/ios/opusfile/Include
      $(PODS_TARGET_SRCROOT)/ios/oggsrc/include
      $(PODS_TARGET_SRCROOT)/ios/opus/Opus.xcframework/ios-arm64/Headers
      $(PODS_TARGET_SRCROOT)/ios/opus/Opus.xcframework/ios-arm64-simulator/Headers
    ].join(" "),
    "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES" => "YES",
  }

  s.dependency "React-Core"
end