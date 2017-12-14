//
//  OAuth2Configuration.swift
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
#if os(iOS)
  import UIKit
#elseif os(macOS)
  //import Cocoa
#endif

open class OAuth2Configuration {
  
  /// Other OAuth2 parameters.
  public var parameters: [String:String] = [:]
  
  /// The client id.
  private(set) public var clientId: String = ""
  
  /// The client secret, usually only needed for code grant (ex: Google).
  private(set) public var clientSecret: String = ""
  
  /// The scope currently in use.
  private(set) public var scope: String = ""
  
  /// The URL to authorize against.
  private(set) public var authURL: String = ""
  
  /// The URL string where we can exchange a code for a token.
  private(set) public var tokenURL: String = ""
  
  /// The redirect URL string to use.
  private(set) public var redirectURL: String = ""
  
  /// The response type expected from an authorize call, e.g. "code" for Google.
  private(set) public var responseType: String = "code"
  
  // SFSafariViewController configuration
  #if os(iOS)
  /// The SFSafariViewController title.
  public final var preferredTitle: String = ""
  
  /// The SFSafariViewController tintColor.
  public final var preferredBarTintColor: UIColor = UIColor.white
  
  /// The SFSafariViewController tintColor.
  public final var preferredTintColor: UIColor = UIColor.black
  
  /// The SFSafariViewController presentationStyle.
  public final var preferredPresentationStyle: UIModalPresentationStyle = UIModalPresentationStyle.formSheet
  #endif
  
  public init(clientId:String, clientSecret:String, authURL:String, tokenURL:String, scope:String, redirectURL:String) {
    self.clientId = clientId
    self.clientSecret = clientSecret
    self.authURL = authURL
    self.tokenURL = tokenURL
    self.scope = scope
    self.redirectURL = redirectURL
  }
  
  public init(clientId:String, authURL:String, tokenURL:String, scope:String, redirectURL:String, responseType:String) {
    self.clientId = clientId
    self.authURL = authURL
    self.tokenURL = tokenURL
    self.scope = scope
    self.redirectURL = redirectURL
    self.responseType = responseType
  }
  
  public init(clientId:String, authURL:String, tokenURL:String, scope:String, redirectURL:String) {
    self.clientId = clientId
    self.authURL = authURL
    self.tokenURL = tokenURL
    self.scope = scope
    self.redirectURL = redirectURL
  }
  
  public init(clientId:String, authURL:String, tokenURL:String, redirectURL:String) {
    self.clientId = clientId
    self.authURL = authURL
    self.tokenURL = tokenURL
    self.redirectURL = redirectURL
  }
  
  public init() {
    
  }
  
}
