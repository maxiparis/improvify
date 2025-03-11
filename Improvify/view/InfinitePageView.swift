//
//  InfinitePageView.swift
//  Improvify
//
//  Created by Maximiliano Paris Gaete on 1/16/25.
//


import SwiftUI

struct InfinitePageView<C, T>: View where C: View, T: Hashable {
    @Binding var selection: T

    let before: (T) -> T
    let after: (T) -> T

    @ViewBuilder let view: (T) -> C

    @Binding var currentTab: Int
    
    var body: some View {
        let previousIndex = before(selection)
        let nextIndex = after(selection)
        
        TabView(selection: $currentTab) {
            view(previousIndex)
                .tag(-1)

            view(selection)
                .onAppear {
                    currentTab = 0
                }
                .onDisappear {
                    if currentTab != 0 {
                        selection = currentTab < 0 ? previousIndex : nextIndex
                        currentTab = 0
                    }
                }
                .tag(0)

            view(nextIndex)
                .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: selection) { _ , _ in
            currentTab = 0
        }
        .disabled(currentTab != 0) // Prevent double swiping issue
    }
}
