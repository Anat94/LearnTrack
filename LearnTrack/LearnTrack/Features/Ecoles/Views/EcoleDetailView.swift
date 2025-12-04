//
//  EcoleDetailView.swift
//  LearnTrack
//
//  Détail d'une école
//

import SwiftUI

struct EcoleDetailView: View {
    let ecole: Ecole
    @StateObject private var viewModel = EcoleViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // En-tête
                VStack(spacing: 12) {
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(ecole.initiales)
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.purple)
                        )
                    
                    Text(ecole.nom)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                
                // Boutons d'action rapide
                HStack(spacing: 12) {
                    ActionButton(icon: "phone.fill", title: "Appeler", color: .green) {
                        ContactService.shared.call(phoneNumber: ecole.telephone)
                    }
                    
                    ActionButton(icon: "envelope.fill", title: "Email", color: .blue) {
                        ContactService.shared.sendEmail(to: ecole.email)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Contact
                InfoSection(title: "Contact", icon: "person.fill") {
                    Text(ecole.nomContact)
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    ContactRow(icon: "phone", label: "Téléphone", value: ecole.telephone) {
                        ContactService.shared.call(phoneNumber: ecole.telephone)
                    }
                    
                    ContactRow(icon: "envelope", label: "Email", value: ecole.email) {
                        ContactService.shared.sendEmail(to: ecole.email)
                    }
                }
                
                // Adresse
                if let adresse = ecole.adresseComplete {
                    Divider()
                    
                    InfoSection(title: "Adresse", icon: "mappin.circle.fill") {
                        Text(adresse)
                            .font(.body)
                        
                        Button(action: {
                            ContactService.shared.openInMaps(address: adresse)
                        }) {
                            Label("Ouvrir dans Plans", systemImage: "map.fill")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 4)
                    }
                }
                
                // Boutons d'action
                VStack(spacing: 12) {
                    Button(action: { showingEditSheet = true }) {
                        Label("Modifier", systemImage: "pencil")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    if authService.userRole == .admin {
                        Button(action: { showingDeleteAlert = true }) {
                            Label("Supprimer", systemImage: "trash")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditSheet) {
            EcoleFormView(viewModel: viewModel, ecoleToEdit: ecole)
        }
        .alert("Supprimer l'école ?", isPresented: $showingDeleteAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) {
                Task {
                    try? await viewModel.deleteEcole(ecole)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        EcoleDetailView(ecole: Ecole(
            nom: "École Supérieure de Formation",
            rue: "45 avenue des Sciences",
            codePostal: "75013",
            ville: "Paris",
            nomContact: "Pierre Durand",
            email: "contact@ecole.fr",
            telephone: "01 45 67 89 01"
        ))
        .environmentObject(AuthService.shared)
    }
}
