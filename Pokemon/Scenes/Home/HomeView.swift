//
//  HomeView.swift
//  Pokemon
//
//  Created by Sylvan  on 02/10/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Text("Hello universe")
    }
}

#Preview("Dark") {
    HomeView()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    HomeView()
}
