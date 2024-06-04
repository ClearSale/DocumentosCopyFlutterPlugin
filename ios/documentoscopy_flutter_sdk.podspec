#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint documentoscopy_flutter_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'documentoscopy_flutter_sdk'
  s.version          = '1.0.0'
  s.summary          = 'CSDocumentosCopy Flutter SDK'
  s.description      = <<-DESC
ClearSale DocumentosCopy Flutter SDK
                       DESC
  s.homepage         = 'https://devs.plataformadatatrust.clearsale.com.br/docs/sdk-captura-de-documentos-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'ClearSale' => 'matheus.castro-ext@clear.sale' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  
  s.info_plist = {
      "NSCameraUsageDescription" => "This app requires access to the camera."
  }
  
  s.static_framework = true
  s.dependency 'CSDocumentoscopySDK'
end
