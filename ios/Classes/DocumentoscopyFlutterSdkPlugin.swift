import Flutter
import UIKit
import CSDocumentoscopySDK

extension UIColor {
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
      var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
      
      if cString.hasPrefix("#") { cString.removeFirst() }
      
      if cString.count != 6 {
        self.init("ff0000") // return red color for wrong hex input
        return
      }
      
      var rgbValue: UInt64 = 0
      Scanner(string: cString).scanHexInt64(&rgbValue)
      
      self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: alpha)
    }
}

public class DocumentoscopyFlutterSdkPlugin: NSObject, FlutterPlugin {
    
    private let LOG_TAG = "[CSDocumentosCopyFlutter]"
    private var flutterResult: FlutterResult?;
    
    private func resetFlutterResult() -> Void {
        self.flutterResult = nil
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "documentoscopy_flutter_sdk", binaryMessenger: registrar.messenger())
        let instance = DocumentoscopyFlutterSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "openCSDocumentosCopy":
            if let arguments = call.arguments as? [String:Any] {
                let sdkParams: NSDictionary = [
                    "clientId": arguments["clientId"] as! String,
                    "clientSecretId": arguments["clientSecretId"] as! String,
                    "identifierId": arguments["identifierId"] as! String,
                    "cpf": arguments["cpf"] as! String,
                    "primaryColor": arguments["primaryColor"] as! String,
                    "secondaryColor": arguments["secondaryColor"] as! String,
                    "tertiaryColor": arguments["tertiaryColor"] as! String,
                    "titleColor": arguments["titleColor"] as! String,
                    "paragraphColor": arguments["paragraphColor"] as! String
                ];
                
                openCSDocumentosCopy(sdkParams: sdkParams, resultParam: result)
            } else {
                result(FlutterError(code: "MissingSdkParams", message: "Unable to get sdk params from payload", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func openCSDocumentosCopy(sdkParams: NSDictionary, resultParam: @escaping FlutterResult) {
        if self.flutterResult != nil {
            // Means that we are already running and somehow the button got triggered again.
            // In this case just return.
            
            return
        }
        
        if let clientId = sdkParams["clientId"] as? String, let clientSecretId = sdkParams["clientSecretId"] as? String, let identifierId = sdkParams["identifierId"] as? String, let cpf = sdkParams["cpf"] as? String {
            
            self.flutterResult = resultParam
            
            DispatchQueue.main.async {
                let primaryColor = sdkParams["primaryColor"] != nil ? UIColor(sdkParams["primaryColor"] as! String) : nil;
                let secondaryColor = sdkParams["secondaryColor"] != nil ? UIColor(sdkParams["secondaryColor"] as! String) : nil;
                let tertiaryColor = sdkParams["tertiaryColor"] != nil ? UIColor(sdkParams["tertiaryColor"] as! String) : nil;
                let titleColor = sdkParams["titleColor"] != nil ? UIColor(sdkParams["titleColor"] as! String) : nil;
                let paragraphColor = sdkParams["paragraphColor"] != nil ? UIColor(sdkParams["paragraphColor"] as! String) : nil;
                
                let sdk = CSDocumentoscopy(configuration: CSDocumentoscopyConfig(colors: CSDocumentoscopyColorsConfig(
                    primaryColor: primaryColor, secondaryColor: secondaryColor, tertiaryColor: tertiaryColor, titleColor: titleColor, paragraphColor: paragraphColor)));
                
                if let viewController = UIApplication.shared.keyWindow?.rootViewController {
                    sdk.delegate = self
                    sdk.initialize(clientId: clientId, clientSecret: clientSecretId, identifierId: identifierId, cpf: cpf, viewController: viewController)
                } else {
                    resultParam(FlutterError(code: "ViewControllerMissing", message: "Unable to find view controller", details: nil))
                }
            }
        } else {
            resultParam(FlutterError(code: "MissingParameters", message: "Missing clientId, clientSecretId, identifierId or CPF or all of them", details: nil))
        }
    }
}

extension DocumentoscopyFlutterSdkPlugin: CSDocumentoscopyDelegate {
    public func didOpen() {
        NSLog("\(LOG_TAG) - called didOpen")
    }
    
    public func didTapClose() {
        NSLog("\(LOG_TAG) - called didTapClose")
        
        if let result = self.flutterResult {
            result(FlutterError(code: "UserCancel", message: "UserCancel", details: nil))
        }
        
        self.resetFlutterResult()
    }
    
    public func didFinishCapture(result: CSDocumentoscopyResult) {
        NSLog("\(LOG_TAG) - called didFinishCapture")
        
        let responseMap = NSMutableDictionary();
        responseMap.setValue(result.documentType.rawValue, forKey: "documentType")
        responseMap.setValue(result.sessionId, forKey: "sessionId")
        
        if let result = self.flutterResult {
            result(responseMap)
        }
        
        self.resetFlutterResult()
    }
    
    public func didReceiveError(error: CSDocumentoscopyError) {
        NSLog("\(LOG_TAG) - called didReceiveError")
        
        if let result = self.flutterResult {
            result(FlutterError(code: String(error.errorCode), message: String(error.text), details: nil))
        }
        
        self.resetFlutterResult()
    }
}
