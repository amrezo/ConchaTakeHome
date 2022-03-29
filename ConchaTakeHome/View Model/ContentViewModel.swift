//
//  ContentViewModel.swift
//  ConchaTakeHome
//
//  Created by Amr Al-Refae on 2022-03-29.
//

import Foundation
import SwiftUI

final class ContentViewModel: ObservableObject {
    
    @Published var sliderHeight: CGFloat = 0 // Slider value offset
    @Published var currentValue: Double = 0 // Current value to display
    @Published var maxHeight: CGFloat = 350 // Vertical Slider max height
    
    // API values
    @Published var ticks: [Double] = []
    @Published var sesssionID: Int = 0
    @Published var loading: Bool = false
    @Published var complete: Bool = false
    
    // Slider values to store and display
    @Published var sliders = [Slider]()
    
    @Published var chosenCurrentIndex: Int = 0 // Chosen ticks index
    
    func startChoice() {
        
        loading = true
        
        let choiceData = ["choice": "start"]
        
        let url = URL(string: "https://iostestserver-su6iqkb5pq-uc.a.run.app/test_start")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        let jsonData = try? JSONEncoder().encode(choiceData)
        request.httpBody = jsonData
                    
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Check to see if there's data, otherwise throw error
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let response = try? JSONDecoder().decode(TickValues.self, from: data)
            
            if let response = response {
                                
                DispatchQueue.main.async {
                    self.ticks = response.ticks ?? []
                    self.sesssionID = response.sessionID
                    
                    self.loading = false
                    self.currentValue = self.ticks.first!
                }
            }
        }

        task.resume()
    }
    
    func nextChoice(sessionID: Int, choice: Int) {
        
        let slider = Slider(id: sliders.count + 1, choice: choice, value: ticks[chosenCurrentIndex])
        sliders.append(slider)
        
        loading = true
        
        let choiceData = [
            "session_id": "\(sessionID)",
            "choice": "\(choice - 1)"
        ]
                
        let url = URL(string: "https://iostestserver-su6iqkb5pq-uc.a.run.app/test_next")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        let jsonData = try? JSONEncoder().encode(choiceData)
        request.httpBody = jsonData
                    
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Check to see if there's data, otherwise throw error
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let response = try? JSONDecoder().decode(TickValues.self, from: data)
            
            if let response = response {
                                
                DispatchQueue.main.async {
                    self.ticks = response.ticks ?? []
                    
                    self.complete = response.complete == "true" ? true : false
                    
                    self.loading = false
                    
                    if response.complete == "false" {
                        self.currentValue = self.ticks.first!
                    }

                }
                
            }
        }

        task.resume()
    }

    func startOver() {
        sliders = []
        ticks = []
        sesssionID = 0
        sliderHeight = 0
        complete = false
        startChoice()
    }
    
}
