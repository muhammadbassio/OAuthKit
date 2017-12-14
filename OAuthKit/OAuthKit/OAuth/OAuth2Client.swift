//
//  OAuth2Client.swift
//  OAuthKit
//
//  Copyright © 2017 Muhammad Bassio. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import SafariServices



open class OAuth2Client {
  
  /// The OAuth2 client configuration.
  private(set) public var configuration:OAuth2Configuration
  
  /// The OAuth2 fetched access token.
  private(set)  public var token:OAuth2Token?
  
  private var safariAuthenticator: Any? = nil
  
  public var clientIsLoadingToken:(() -> Void) = {}
  public var clientDidFinishLoadingToken:(() -> Void) = {}
  public var clientDidFailLoadingToken:((_ NKError:Error) -> Void) = { error in
    
  }
  
  public init(configuration:OAuth2Configuration) {
    self.configuration = configuration
    self.token = nil
    self.loadToken()
  }
  
  /// Override to implement your own logic in subclass.
  open func loadToken() {
    if self.configuration.clientId != "" {
      let keychain = Keychain(service: "OAuth2Client.\(self.configuration.clientId)")
      do {
        if let accessToken = try keychain.get("accessToken.accessToken"), let type = try keychain.get("accessToken.tokenType"), let refreshToken = try keychain.get("accessToken.refreshToken") {
          self.token = OAuth2Token()
          self.token?.accessToken = accessToken
          self.token?.tokenType = type
          self.token?.refreshToken = refreshToken
          if let idToken = try keychain.get("accessToken.idToken") {
            self.token?.idToken = idToken
          }
          if let timeIntervalString = try keychain.get("accessToken.accessTokenExpiry") {
            if let timeInterval = Double(timeIntervalString) {
              let accessTokenExpiry = Date(timeIntervalSinceReferenceDate: timeInterval)
              self.token?.accessTokenExpiry = accessTokenExpiry
            }
          }
        }
      } catch let error {
        print("loadToken error: \(error)")
      }
    } else {
      print("error: No client Id provided")
    }
  }
  
  /// Override to implement your own logic in subclass.
  open func saveToken() {
    if self.configuration.clientId != "" {
      let keychain = Keychain(service: "OAuth2Client.\(self.configuration.clientId)")
      if let accessToken = self.token?.accessToken, let type = self.token?.tokenType, let refreshToken = self.token?.refreshToken {
        do {
          try keychain.synchronizable(true).set("\(accessToken)", key: "accessToken.accessToken")
          try keychain.synchronizable(true).set("\(type)", key: "accessToken.tokenType")
          try keychain.synchronizable(true).set("\(refreshToken)", key: "accessToken.refreshToken")
          if let idToken = self.token?.idToken {
            try keychain.synchronizable(true).set("\(idToken)", key: "accessToken.idToken")
          }
          if let accessTokenExpiry = self.token?.accessTokenExpiry {
            let timeInterval = accessTokenExpiry.timeIntervalSinceReferenceDate
            try keychain.synchronizable(true).set("\(timeInterval)", key: "accessToken.accessTokenExpiry")
          }
        } catch let error {
          print("saveToken error: \(error)")
        }
      }
    } else {
      print("error: No client Id provided")
    }
  }
  
  /// Override to implement your own logic in subclass.
  open func clearToken() {
    if self.configuration.clientId != "" {
      let keychain = Keychain(service: "OAuth2Client.\(self.configuration.clientId)")
      do {
        try keychain.remove("accessToken.accessToken")
        try keychain.remove("accessToken.tokenType")
        try keychain.remove("accessToken.refreshToken")
        try keychain.remove("accessToken.idToken")
        try keychain.remove("accessToken.accessTokenExpiry")
      } catch let error {
        print("error: \(error)")
      }
    } else {
      print("clearToken error: No client Id provided")
    }
  }
  
  open func authorize(from controller:UIViewController) {
    var urltext = "\(self.configuration.authURL)?client_id=\(self.configuration.clientId)&redirect_uri=\(self.configuration.redirectURL)"
    if self.configuration.scope != "" {
      urltext = "\(urltext)&scope=\(self.configuration.scope)"
    }
    if self.configuration.responseType != "" {
      urltext = "\(urltext)&response_type=\(self.configuration.responseType)"
    }
    for (key, value) in self.configuration.parameters {
      urltext = "\(urltext)&\(key)=\(value)"
    }
    
    if #available(iOS 11.0, *) {
      self.safariAuthenticator = SFAuthenticationSession(url: URL(string: urltext.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!, callbackURLScheme: self.configuration.redirectURL, completionHandler: { (url, error) in
        self.handle(redirectURL: url!)
      })
      if let svc = self.safariAuthenticator as? SFAuthenticationSession {
        svc.start()
      }
    } else {
      let svc = SFSafariViewController(url: URL(string: urltext.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
      svc.title = self.configuration.preferredTitle
      if #available(iOS 10.0, *) {
        svc.preferredBarTintColor = self.configuration.preferredBarTintColor
        svc.preferredControlTintColor = self.configuration.preferredTintColor
      }
      svc.modalPresentationStyle = self.configuration.preferredPresentationStyle
      self.safariAuthenticator = svc
      controller.present(svc, animated: true, completion: nil)
    }
  }
  
  open func handle(redirectURL: URL) {
    if #available(iOS 11.0, *) { } else {
      if let svc = self.safariAuthenticator as? SFSafariViewController {
        svc.dismiss(animated: true, completion: nil)
        self.safariAuthenticator = nil
      }
    }
    // show loading
    let redirectString = redirectURL.absoluteString
    if self.configuration.redirectURL.isEmpty {
      self.clientDidFailLoadingToken(OAKError(localizedTitle: "No redirect URL", localizedDescription: "Oauth2 configuration is missing a redirect URL"))
      return
    }
    let components = URLComponents(url: redirectURL, resolvingAgainstBaseURL: true)
    if !(redirectString.hasPrefix(self.configuration.redirectURL)) && (!(redirectString.hasPrefix("urn:ietf:wg:oauth:2.0:oob")) && "localhost" != components?.host) {
      self.clientDidFailLoadingToken(OAKError(localizedTitle: "Redirect URL mismatch", localizedDescription: "Redirect URL mismatch: expecting \(self.configuration.redirectURL) , received: \(redirectString)"))
      return
    }
    if let queryItems = components?.queryItems {
      let codeItems = queryItems.filter({ (item) -> Bool in
        if item.name == "code" {
          return true
        }
        return false
      })
      if codeItems.count > 0 {
        self.clientIsLoadingToken()
        if let code = codeItems[0].value {
          let headers = ["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json"]
          let parameters = [
            "code": "\(code)",
            "client_id": "\(self.configuration.clientId)",
            "client_secret": "\(self.configuration.clientSecret)",
            "redirect_uri": "\(self.configuration.redirectURL)",
            "grant_type": "authorization_code"
          ]
          request(self.configuration.tokenURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (responseJSON) in
            do {
              let json = try JSON(data: responseJSON.data!)
              if let responseCode = responseJSON.response?.statusCode {
                if responseCode == 200 {
                  self.token = OAuth2Token()
                  self.token?.accessToken = json["access_token"].stringValue
                  self.token?.refreshToken = json["refresh_token"].stringValue
                  self.token?.tokenType = json["token_type"].stringValue
                  self.token?.idToken = json["id_token"].stringValue
                  self.token?.accessTokenExpiry = Date().addingTimeInterval(json["expires_in"].doubleValue)
                  self.saveToken()
                  self.clientDidFinishLoadingToken()
                }
                else {
                  self.clientDidFailLoadingToken(OAKError(localizedTitle: "Authentication failed", localizedDescription: "Authentication failed, resonse: \n\(json)"))
                }
              }
              else {
                self.clientDidFailLoadingToken(OAKError(localizedTitle: "Invalid response", localizedDescription: "Invalid OAuth2 token response"))
              }
            }
            catch {
              self.clientDidFailLoadingToken(OAKError(localizedTitle: "Invalid response", localizedDescription: "Invalid OAuth2 token response"))
            }
          }
        }
      }
      else {
        self.clientDidFailLoadingToken(OAKError(localizedTitle: "Unable to extract Code", localizedDescription: "Unable to extract code: query parameters has no \"code\" parameter"))
      }
    }
    else {
      self.clientDidFailLoadingToken(OAKError(localizedTitle: "Unable to extract Code", localizedDescription: "Unable to extract code: No query parameters in redirect URL"))
    }
  }
  
  open func refreshAccessToken() {
    if let tok = self.token?.refreshToken {
      let headers = ["Content-Type": "application/x-www-form-urlencoded"]
      let parameters = [
        "client_id": "\(self.configuration.clientId)",
        "client_secret": "\(self.configuration.clientSecret)",
        "refresh_token": "\(tok)",
        "grant_type": "refresh_token"
      ]
      request(self.configuration.tokenURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (responseJSON) in
        do {
          let json = try JSON(data: responseJSON.data!)
          if let responseCode = responseJSON.response?.statusCode {
            if responseCode == 200 {
              self.token = OAuth2Token()
              self.token?.accessToken = json["access_token"].stringValue
              self.token?.refreshToken = json["refresh_token"].stringValue
              self.token?.tokenType = json["token_type"].stringValue
              self.token?.idToken = json["id_token"].stringValue
              self.token?.accessTokenExpiry = Date().addingTimeInterval(json["expires_in"].doubleValue)
              self.saveToken()
              self.clientDidFinishLoadingToken()
            }
            else {
              self.clientDidFailLoadingToken(OAKError(localizedTitle: "Authentication failed", localizedDescription: "Authentication failed, resonse: \n\(json)"))
            }
          }
          else {
            self.clientDidFailLoadingToken(OAKError(localizedTitle: "Invalid response", localizedDescription: "Invalid OAuth2 token response"))
          }
        }
        catch {
          self.clientDidFailLoadingToken(OAKError(localizedTitle: "Invalid response", localizedDescription: "Invalid OAuth2 token response"))
        }
      }
    }
    else {
      self.clientDidFailLoadingToken(OAKError(localizedTitle: "RefreshToken missing", localizedDescription: "Invalid OAuth2 refresh token"))
    }
  }
  
  open func unauthorize() {
    self.token = nil
    self.clearToken()
  }
  
}
