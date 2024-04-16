import Foundation
import Capacitor
import Intercom

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(IntercomPlugin)
public class IntercomPlugin: CAPPlugin {
    public override func load() {
        let apiKey = getConfig().getString("iosApiKey") ?? "ADD_IN_CAPACITOR_CONFIG_JSON"
        let appId = getConfig().getString("iosAppId") ?? "ADD_IN_CAPACITOR_CONFIG_JSON"
        Intercom.setApiKey(apiKey, forAppId: appId)
        
#if DEBUG
        Intercom.enableLogging()
#endif
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRegisterWithToken(notification:)), name: Notification.Name.capacitorDidRegisterForRemoteNotifications, object: nil)
    }
    
    
    @objc func didRegisterWithToken(notification: NSNotification) {
        guard let deviceToken = notification.object as? Data else {
            return
        }
        Intercom.setDeviceToken(deviceToken)
    }
    
    @objc func loadWithKeys(_ call: CAPPluginCall) {
        let appId = call.getString("appId")  as? String ?? "NO_APP_ID_PASSED"
        let apiKey = call.getString("apiKeyIOS") as? String ?? "NO_API_KEY_PASSED"
        
        Intercom.setApiKey(apiKey, forAppId: appId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRegisterWithToken(notification:)), name: Notification.Name(CAPNotifications.DidRegisterForRemoteNotificationsWithDeviceToken.name()), object: nil)
    }
    
    @objc func registerIdentifiedUser(_ call: CAPPluginCall) {
        let attributes = ICMUserAttributes()
        
        if let email = call.getString("email") {
            attributes.email = email
        }
        
        if let userId = call.getString("userId") {
            attributes.userId = userId
        }
        
        DispatchQueue.main.async {
            Intercom.loginUser(with: attributes) { result in
                switch result {
                case .success: call.resolve()
                case .failure(let error): call.reject("Error logging in: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc func registerUnidentifiedUser(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Intercom.loginUnidentifiedUser()
            call.resolve()
        }
    }
    
    @objc func updateUser(_ call: CAPPluginCall) {
        let userAttributes = ICMUserAttributes()
        
        if let userId = call.getString("userId") {
            userAttributes.userId = userId
        }
        if let email = call.getString("email") {
            userAttributes.email = email
        }
        if let name = call.getString("name") {
            userAttributes.name = name
        }
        if let phone = call.getString("phone") {
            userAttributes.phone = phone
        }
        if let languageOverride = call.getString("languageOverride") {
            userAttributes.languageOverride = languageOverride
        }
        if let customAttributes = call.getObject("customAttributes") {
            userAttributes.customAttributes = customAttributes
        }
        if let company = call.getObject("company") {
            let companyAttributes = ICMCompany()
            
            if let companyId = company["companyId"] as? String {
                companyAttributes.companyId = companyId
            }
            if let name = company["name"] as? String {
                companyAttributes.name = name
            }
            if let createdAt = company["createdAt"] as? TimeInterval {
                companyAttributes.createdAt = Date(timeIntervalSince1970: createdAt)
            }
            if let companyCustomAttributes = company["customAttributes"] as? JSObject {
                companyAttributes.customAttributes = companyCustomAttributes
            }
            
            userAttributes.companies = [companyAttributes]
        }
        
        DispatchQueue.main.async {
            Intercom.updateUser(with: userAttributes)
            call.resolve()
        }
    }
    
    @objc func logout(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Intercom.logout()
            call.resolve()
        }
    }
    
    @objc func logEvent(_ call: CAPPluginCall) {
        let eventName = call.getString("name")
        let metaData = call.getObject("data")
        
        if (eventName != nil && metaData != nil) {
            Intercom.logEvent(withName: eventName!, metaData: metaData!)
            
        } else if (eventName != nil) {
            Intercom.logEvent(withName: eventName!)
        }
        
        call.resolve()
    }
    
    @objc func displayMessenger(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Intercom.present();
            call.resolve()
        }
    }
    
    @objc func displayMessageComposer(_ call: CAPPluginCall) {
        guard let initialMessage = call.getString("message") else {
            call.reject("Enter an initial message")
            return
        }
        
        DispatchQueue.main.async {
            Intercom.presentMessageComposer(initialMessage);
            call.resolve()
        }
    }
    
    @objc func displayHelpCenter(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Intercom.present(.helpCenter)
            call.resolve()
        }
    }
    
    @objc func hideMessenger(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Intercom.hide()
            call.resolve()
        }
    }
    
    @objc func displayLauncher(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Intercom.setLauncherVisible(true)
            call.resolve()
        }
    }
    
    @objc func hideLauncher(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Intercom.setLauncherVisible(false)
            call.resolve()
        }
    }
    
    @objc func displayInAppMessages(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Intercom.setInAppMessagesVisible(true)
            call.resolve()
        }
    }
    
    @objc func hideInAppMessages(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            Intercom.setInAppMessagesVisible(false)
            call.resolve()
        }
    }
    
    @objc func displayCarousel(_ call: CAPPluginCall) {
        guard let carouselId = call.getString("carouselId") else {
            call.reject("carouselId not provided to displayCarousel.")
            return
        }
        
        DispatchQueue.main.async {
            let carouselToPresent = Intercom.Content.carousel(id: carouselId)
            Intercom.presentContent(carouselToPresent)
            call.resolve()
        }
    }
    
    @objc func startSurvey(_ call: CAPPluginCall) {
        guard let surveyId = call.getString("surveyId") else {
            call.reject("surveyId not provided to startSurvey.")
            return
        }
        
        DispatchQueue.main.async {
            Intercom.presentContent(Intercom.Content.survey(id: surveyId))
            call.resolve()
        }
    }
    
    @objc func setUserHash(_ call: CAPPluginCall) {
        guard let hmac = call.getString("hmac") else {
            call.reject("No hmac found. Read intercom docs and generate it.")
            return
        }
        
        DispatchQueue.main.async {
            Intercom.setUserHash(hmac)
            call.resolve()
        }
    }
    
    @objc func setBottomPadding(_ call: CAPPluginCall) {
        guard let value = call.getString("value"),
        let number = NumberFormatter().number(from: value) else {
            call.reject("Enter a value for padding bottom")
            return
        }
        
        DispatchQueue.main.async {
            Intercom.setBottomPadding(CGFloat(truncating: number))
            call.resolve()
        }
    }
    
    @objc func displayArticle(_ call: CAPPluginCall) {
        guard let articleId = call.getString("articleId") else {
            call.reject("articleId not provided to presentArticle.")
            return
        }
        
        DispatchQueue.main.async {
            let articleToPresent = Intercom.Content.article(id: articleId)
            Intercom.presentContent(articleToPresent)
            call.resolve()
        }
    }
}

