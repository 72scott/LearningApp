//
//  TestView.swift
//  LearningApp
//
//  Created by chog on 24/8/21.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    @State var selectedAnswerIndex = -1
    @State var numCorrect = 0
    
    var body: some View {
        
        if model.currentQuestion != nil {
            
            VStack (alignment: .leading) {
                //Question Number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                //Question
                CodeTextView()
                    .padding(.horizontal, 20)
                //Answers
                ScrollView {
                    
                    VStack{
                        ForEach (0..<model.currentQuestion!.answers.count, id: \.self)  { index in
                         
                            Button {
                                selectedAnswerIndex = index
                                
                            } label: {
                                
                            ZStack {
                                
                                RectangleCard(color: index == selectedAnswerIndex ? .gray: .white)
                                    .frame(height: 48)
                            
                                Text(model.currentQuestion!.answers[index])
                            }
                        }
                    }
                }
                    .accentColor(.black)
                    .padding()
                
                //Button
                    Button {
                        
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                        
                    } label: {
                        
                        ZStack {
                            
                            RectangleCard(color: .green)
                                .frame(height: 48)
                            
                            Text("Submit")
                                .bold()
                                
                                .foregroundColor(Color.white)
                            
                        }
                    
                    .padding()
            }
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        }
        else {
            ProgressView()
            
        }
    }
        
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
