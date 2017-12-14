//
//  ViewController.swift
//  Example
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

import UIKit
import OAuthKit

class ViewController: UIViewController {
  
  @IBOutlet var spinner:UIActivityIndicatorView?
  @IBOutlet var progressLabel:UILabel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func authGoogle() {
    if let app = UIApplication.shared.delegate as? AppDelegate {
      app.auth = OAuth2Client(configuration: OAuth2Configuration(clientId: "137865357678-opatlf959msgha35ra4tfsugg1pa4gvl.apps.googleusercontent.com", authURL: "https://accounts.google.com/o/oauth2/auth", tokenURL: "https://www.googleapis.com/oauth2/v4/token", scope: "https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/youtube.readonly https://www.googleapis.com/auth/youtubepartner https://www.googleapis.com/auth/youtubepartner-channel-audit https://www.googleapis.com/auth/youtube.upload", redirectURL: "com.googleusercontent.apps.137865357678-opatlf959msgha35ra4tfsugg1pa4gvl:/oauth2Callback", responseType: "code"))
      app.auth.configuration.parameters = ["access_type":"offline", "hl":"en"]
      app.auth.authorize(from: self)
      app.auth.clientIsLoadingToken = {
        self.spinner?.startAnimating()
        self.progressLabel?.text = "Loading OAuth2 token ..."
      }
      app.auth.clientDidFinishLoadingToken = {
        self.spinner?.stopAnimating()
        self.progressLabel?.text = "token:\n\(app.auth.token?.accessToken ?? "No token !!!")"
      }
      app.auth.clientDidFailLoadingToken = { error in
        self.spinner?.stopAnimating()
        self.progressLabel?.text = "error:\n\(error.localizedDescription)"
      }
    }
  }
  
  @IBAction func showAuth() {
    self.authGoogle()
  }
  
  func authFacebook() {
    if let app = UIApplication.shared.delegate as? AppDelegate {
      app.auth = OAuth2Client(configuration: OAuth2Configuration(clientId: "2038205793072526", clientSecret: "d55207243c6ead9e3a3685f74e771273", authURL: "https://www.facebook.com/v2.8/dialog/oauth", tokenURL: "https://graph.facebook.com/v2.8/oauth/access_token", scope: "public_profile,email", redirectURL: "fb2038205793072526://authorize/"))
      app.auth.authorize(from: self)
      app.auth.clientIsLoadingToken = {
        self.spinner?.startAnimating()
        self.progressLabel?.text = "Loading OAuth2 token ..."
      }
      app.auth.clientDidFinishLoadingToken = {
        self.spinner?.stopAnimating()
        self.progressLabel?.text = "token: \(app.auth.token?.accessToken ?? "No token !!!")"
      }
      app.auth.clientDidFailLoadingToken = { error in
        self.spinner?.stopAnimating()
        self.progressLabel?.text = "error: \(error.localizedDescription)"
      }
    }
  }
  
  func authGithub() {
    if let app = UIApplication.shared.delegate as? AppDelegate {
      app.auth = OAuth2Client(configuration: OAuth2Configuration(clientId: "1353b15928664b321dfd", clientSecret: "8346c2ba411fbed47bc1885859d4957fa487d3d5", authURL: "https://github.com/login/oauth/authorize", tokenURL: "https://github.com/login/oauth/access_token", scope: "user,user:email", redirectURL: "ghexample://authorize"))
      app.auth.authorize(from: self)
      app.auth.clientIsLoadingToken = {
        self.spinner?.startAnimating()
        self.progressLabel?.text = "Loading OAuth2 token ..."
      }
      app.auth.clientDidFinishLoadingToken = {
        self.spinner?.stopAnimating()
        self.progressLabel?.text = "token: \(app.auth.token?.accessToken ?? "No token !!!")"
      }
      app.auth.clientDidFailLoadingToken = { error in
        self.spinner?.stopAnimating()
        self.progressLabel?.text = "error: \(error.localizedDescription)"
      }
    }
  }
  
}

