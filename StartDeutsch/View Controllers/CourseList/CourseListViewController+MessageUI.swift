//
//  CourseListViewController+MessageUI.swift
//  StartDeutsch
//
//  Created by Zhazira Garipolla on 5/30/20.
//  Copyright © 2020 Zhazira Garipolla. All rights reserved.
//

import MessageUI

extension CourseListViewController: MFMailComposeViewControllerDelegate{
    
    @objc func didTapHelpButton(_ sender: UIButton) {
        // Modify following variables with your text / recipient
        let recipientEmail = "help.startdeutsch@gmail.com"
        var body: String = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            body.append("App Version: \(version)\n")
        }
        
        let os = ProcessInfo().operatingSystemVersion
        let osVersionString = "\(os.majorVersion.description).\(os.minorVersion.description).\(os.patchVersion.description)"
        body.append("Device iOS version: \(osVersionString)\n")
        body.append("Model: \(modelIdentifier())")
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setMessageBody(body, isHTML: false)
            present(mail, animated: true)
        }
        else {
             UIApplication.shared.open(URL(string: "https://startdeutschapp.wixsite.com/startdeutsch")!, options: [:], completionHandler: nil)
        }
    }
    
    func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
