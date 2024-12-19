//
//  ContentView.swift
//  Improvify
//
//  Created by Maximiliano París Gaete on 12/18/24.
//

import SwiftUI
import SwiftData

struct HabitsListView: View {
    var habitsManager: HabitsManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                //Main Content
                List {
                    Section {
                        HStack {
                            
                            Image(systemName: "arrow.left").onTapGesture {
                                habitsManager.moveDayBackward()
                            }
                            
                            
                            Spacer()
                            Text(habitsManager.dateString)
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                            .onTapGesture {
                                habitsManager.moveDayForward()
                            }
                        }
                    }
                }
                
                // Phrase
                VStack {
                    Spacer()
                    Text("Habit is the intersection of knowledge (what to do), skill (how to do), and desire (want to do).")
                        .padding()
                    HStack {
                        Spacer()
                        Text("- Stephen R. Covery")
                    }
                    .padding()
                }
                .padding()
                
            }
            .navigationTitle(Text("Improvify"))
        }
    }
}
