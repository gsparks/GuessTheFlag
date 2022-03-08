//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Gregory Sparks on 11/30/21.
//

import SwiftUI

struct PromptText: ViewModifier {
    var boldLevel: String
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.subheadline.weight((boldLevel == "heavy") ? .heavy : .semibold ))
    }
}

extension View {
    func promptText(_ boldLevel: String) -> some View {
        modifier(PromptText(boldLevel: boldLevel))
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var question = 1
    @State private var showingRestart = false
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var animationAmount = 0.0
    
    struct FlagImage: View {
        var imageName: String
        
        var body: some View {
            Image(imageName)
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
                .rotation3DEffect(.degrees(360), axis: (x: 0, y: 1, z: 0))
            
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .promptText("heavy")
                    Text(countries[correctAnswer])
                        .promptText("semibold")
                }
                
                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        FlagImage(imageName: countries[number])
                    }
                    .rotation3DEffect(.degrees(number == correctAnswer ? self.animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                }
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Final Score:", isPresented: $showingRestart) {
            Button("Restart", action: restart)
        } message: {
            Text("\(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
            withAnimation() {
                self.animationAmount += 360
            }
            
        } else {
            scoreTitle = "Wrong, that's the flag of \(countries[number])"
            score -= 1
        }
        
        question += 1
        if question > 8 {
            showingRestart = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restart() {
        showingScore = false
        scoreTitle = ""
        score = 0
        question = 1
        showingRestart = false
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
