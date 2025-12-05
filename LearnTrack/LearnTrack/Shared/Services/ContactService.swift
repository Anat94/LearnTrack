//
//  ContactService.swift
//  LearnTrack
//
//  Service pour les actions de contact (appel, email, SMS)
//

import Foundation
import UIKit
import MessageUI

class ContactService {
    static let shared = ContactService()
    
    private init() {}
    
    // MARK: - Helpers
    private func topViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }),
              var top = window.rootViewController else { return nil }
        while let presented = top.presentedViewController { top = presented }
        return top
    }
    
    private func alert(_ title: String, _ message: String) {
        guard let vc = topViewController() else { return }
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(ac, animated: true)
    }
    
    private func sanitizePhone(_ input: String) -> String {
        var result = input.trimmingCharacters(in: .whitespacesAndNewlines)
        // Keep digits and plus
        result = result.filter { $0.isNumber || $0 == "+" }
        return result
    }
    
    // Appeler un numéro de téléphone
    func call(phoneNumber: String) {
        let cleanNumber = sanitizePhone(phoneNumber)
        guard let url = URL(string: "tel://\(cleanNumber)") else { return }
        UIApplication.shared.open(url, options: [:]) { success in
            if !success {
                self.alert("Impossible d'appeler", "Aucune application téléphonique disponible sur cet appareil.")
                UIPasteboard.general.string = cleanNumber
            }
        }
    }
    
    // Envoyer un email
    func sendEmail(to email: String, subject: String = "", body: String = "") {
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.setToRecipients([email])
            if !subject.isEmpty { mailVC.setSubject(subject) }
            if !body.isEmpty { mailVC.setMessageBody(body, isHTML: false) }
            mailVC.mailComposeDelegate = self
            topViewController()?.present(mailVC, animated: true)
            return
        }
        var components = URLComponents(string: "mailto:\(email)")
        var queryItems: [URLQueryItem] = []
        
        if !subject.isEmpty {
            queryItems.append(URLQueryItem(name: "subject", value: subject))
        }
        
        if !body.isEmpty {
            queryItems.append(URLQueryItem(name: "body", value: body))
        }
        
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        
        if let url = components?.url {
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                    self.alert("Impossible d'envoyer l'email", "Configurez une app Mail ou copiez l'adresse depuis la fiche.")
                    UIPasteboard.general.string = email
                }
            }
        }
    }
    
    // Envoyer un SMS
    func sendSMS(to phoneNumber: String) {
        let cleanNumber = sanitizePhone(phoneNumber)
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.recipients = [cleanNumber]
            messageVC.messageComposeDelegate = self
            topViewController()?.present(messageVC, animated: true)
            return
        }
        if let url = URL(string: "sms:\(cleanNumber)") {
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                    self.alert("Impossible d'envoyer le SMS", "Aucune app Messages disponible sur cet appareil.")
                    UIPasteboard.general.string = cleanNumber
                }
            }
        }
    }
    
    // Ouvrir dans Plans
    func openInMaps(address: String) {
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let url = URL(string: "maps://?address=\(encodedAddress)") {
            UIApplication.shared.open(url, options: [:]) { success in
                if !success, let googleMapsURL = URL(string: "comgooglemaps://?q=\(encodedAddress)") {
                    UIApplication.shared.open(googleMapsURL, options: [:]) { success in
                        if !success, let webURL = URL(string: "https://maps.apple.com/?address=\(encodedAddress)") {
                            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                        }
                    }
                }
            }
        }
    }
}

extension ContactService: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
}
