//
//  ContentView.swift
//  Animations
//
//  Created by Henrieke Baunack on 10/25/23.
//

import SwiftUI

struct FlagView: View {
    var imageRef : String
    var body: some View {
        Image(imageRef).clipShape(.rect(cornerRadius: 10))
    }
}

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    @State var flagIsTapped = [false, false, false]
    @State var scoreTitle = ""
    @State var alertShown = false
    @State var finalAlertShown = false
    @State var score = 0
    @State var questionCounter = 0
    @State var degree = 0.0
    @State var opacity = 1.0
    @State var scaleAmount = 1.0
    var numQuestionsPerGame = 8
    var body: some View {
        ZStack{
            RadialGradient(stops: [.init(color: .cyan, location: 0.3), .init(color: .mint, location: 0.3)],center: .top, startRadius: 200, endRadius: 700).ignoresSafeArea()
           // RadialGradient(colors: [.white, .mint], center: .top, startRadius: 200, endRadius: 500).ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess the flag").font(.largeTitle).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                VStack(spacing:15){
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.black)
                            .font(.subheadline).fontWeight(.heavy)
                        Text(countries[correctAnswer]).foregroundStyle(.black).font(.largeTitle).fontWeight(.semibold)
                    }
                    ForEach(0..<3){ number in
                        Button{
                            print("\(countries[number]) clicked")
                            flagTapped(number: number)
                            questionCounter += 1
                            flagIsTapped[number] = true
                            if questionCounter < numQuestionsPerGame {
                                alertShown = true
                            }
                            else{
                                finalAlertShown = true
                            }
                            withAnimation{
                                degree += 360
                                opacity = 0.25
                                scaleAmount = 0.75
                            }
                        } label: {
                            //Image(countries[number]).clipShape(.rect(cornerRadius: 10))
                            FlagView(imageRef: countries[number])
                                .rotation3DEffect(.degrees(flagIsTapped[number] ? degree : 0 ),  axis: (x: 0, y: 1, z: 0))
                                .opacity(!flagIsTapped[number] ? opacity : 1.0)
                                .scaleEffect(!flagIsTapped[number] ? scaleAmount : 1)
                            
                        }
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 30))
                //.padding(.horizontal, 20)
                Spacer()
                Text("Score: \(score)").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
                Spacer()
            }.padding(20)
        }.alert(scoreTitle, isPresented: $alertShown){
            Button("Continue", action: shuffleQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert(scoreTitle, isPresented: $finalAlertShown){
            Button("New Game", action: restartGame)
        } message: {
            Text("Your FINAL score is \(score)")
        }
    }
    
    func flagTapped(number:Int){
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
            print(score)
        } else{
            scoreTitle = "Wrong, that is the flag of \(countries[number])!"
            score -= 1
            print(score)
        }
    }
    func shuffleQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        flagIsTapped = [false, false, false]
        scaleAmount = 1.0
        opacity = 1
    }
    func restartGame(){
        shuffleQuestion()
        score = 0
        questionCounter = 0
        flagIsTapped = [false, false, false]
    }
    
    
}
#Preview {
    ContentView()
}
