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
    
    // Appeler un numéro de téléphone
    func call(phoneNumber: String) {
        let cleanNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "-", with: "")
        
        if let url = URL(string: "tel://\(cleanNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // Envoyer un email
    func sendEmail(to email: String, subject: String = "", body: String = "") {
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
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // Envoyer un SMS
    func sendSMS(to phoneNumber: String) {
        let cleanNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "-", with: "")
        
        if let url = URL(string: "sms:\(cleanNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
