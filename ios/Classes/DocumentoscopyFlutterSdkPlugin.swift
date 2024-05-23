import Flutter
import UIKit
import CSDocumentoscopySDK

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
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "openCSDocumentosCopy":
            if let arguments = call.arguments as? [String:Any] {
                let sdkParams: NSDictionary = [
                    "clientId": arguments["clientId"] as! String,
                    "clientSecretId": arguments["clientSecretId"] as! String,
                    "identifierId": arguments["identifierId"] as! String,
                    "cpf": arguments["cpf"] as! String,
                ];
                
                openCSDocumentosCopy(sdkParams: sdkParams, resultParam: result)
            } else {
                result(FlutterError(code: "MissingSdkParams", message: "Unable to get sdk params from payload", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // TODO -> Check how to properly get params.
    private func openCSDocumentosCopy(sdkParams: NSDictionary, resultParam: @escaping FlutterResult) {
        if let result = self.flutterResult {
            // Means that we are already running and somehow the button got triggered again.
            // In this case just return.
            
            return
        }
        
        if let clientId = sdkParams["clientId"] as? String, let clientSecretId = sdkParams["clientSecretId"] as? String, let identifierId = sdkParams["identifierId"] as? String, let cpf = sdkParams["cpf"] as? String {
                   
            self.flutterResult = resultParam

            DispatchQueue.main.async {
               let sdk = CSDocumentoscopy()

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