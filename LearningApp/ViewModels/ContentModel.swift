//
//  ContentModel.swift
//  LearningApp
//
//  Created by Scott on 11/8/21.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current lesson explanation
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    // Current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    
    init() {
        
        getLocalData()
        
    }
  
    
    func getLocalData() {
        
   
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
          
            let jsonData = try Data(contentsOf: jsonUrl!)
            
          
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            self.modules = modules
        }
        catch {
            print("Couldn't parse local data")
        }
        
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        }
        catch {
            print("Couldn't parse style data")
        }
        
    }
 
    
    func beginModule(_ moduleid:Int) {
        
     
        for index in 0..<modules.count {
            
            if modules[index].id == moduleid {
            
               
                currentModuleIndex = index
                break
            }
        }
        
      
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex:Int) {
        
       
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        
        
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson() {
        
      
        currentLessonIndex += 1
        
       
        if currentLessonIndex < currentModule!.content.lessons.count {
           
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        }
        else {
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    func hasNextLesson() -> Bool {
        
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    func beginTest(_ moduleId:Int) {
        
        beginModule(moduleId)
        
        currentQuestionIndex = 0
        
        if currentModule?.test.questions.count ?? 0  > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            codeText = addStyling(currentQuestion!.content)
            
        }
    }
    func nextQuestion() {
        
        currentQuestionIndex += 1
        
        if currentQuestionIndex < currentModule!.test.questions.count {
            
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
            
        }

        else {
            currentQuestionIndex = 0
            currentQuestion = nil
        }
    }
    
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
    
        if styleData != nil {
            data.append(styleData!)
        }
        
     
        data.append(Data(htmlString.utf8))
        
       
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
        }
        
        return resultString
    }
}
