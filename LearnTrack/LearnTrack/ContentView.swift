//
//  ContentView.swift
//  LearnTrack
//
//  Vue de contenu principale (remplacée par MainTabView)
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthService.shared)
}
