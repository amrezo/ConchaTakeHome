//
//  ContentView.swift
//  ConchaTakeHome
//
//  Created by Amr Al-Refae on 2022-03-28.
//

import SwiftUI

struct ContentView: View {
    
    // ViewModel
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        
        ZStack {
            
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            if !viewModel.complete {
                VStack {
                    // Title
                    Text("Please take this test")
                        .font(.system(.title, design: .serif))
                        .padding()
                    
                    Text("Current value: \(String(format: "%.2f", viewModel.currentValue))")
                        .bold()
                        .font(.system(.body, design: .rounded))
                    
                        // Custom vertical slider
                        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                            
                            // Slider background area
                            Capsule()
                                .fill(Color.black.opacity(0.1))
                                .frame(width: 20, height: viewModel.maxHeight)
                            
                            // Slider gradient fill
                            Capsule()
                                .fill(LinearGradient(colors: [Color("GradientStart"), Color("GradientEnd")], startPoint: .bottom, endPoint: .top))
                                .frame(width: 20, height: -viewModel.sliderHeight + 20)
                            
                            // Slider ticker lines
                            VStack(spacing:  (viewModel.maxHeight - 10) / 16) {
                                ForEach(0..<16, id: \.self) { index in
                                    
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 20, height: 1)
                                    
                                }
                            }
                            .offset(y: -10)
                            
                            // Slider circle
                            Circle()
                                .fill(Color(.white))
                                .frame(width: 20, height: 20)
                                .background(Circle().stroke(Color("SliderCircle").opacity(0.5), lineWidth: 25))
                                .offset(y: viewModel.sliderHeight)
                                .gesture(DragGesture(minimumDistance: 0).onChanged({ value in

                                    // Limit slider circle value
                                    if value.location.y >= -viewModel.maxHeight + 20 && value.location.y <= 0  {
                                        viewModel.sliderHeight = value.location.y
                                    }
                                    
                                    // Figure out which tick is being selected and update current value
                                    let sectionHeight = Int(viewModel.maxHeight) / viewModel.ticks.count
                                    let currentIndex = abs(Int(viewModel.sliderHeight) / sectionHeight)
                                    
                                    viewModel.chosenCurrentIndex = currentIndex
                                    
                                    viewModel.currentValue = viewModel.ticks[currentIndex]
                                    
                                    
                                    
                                }))
                        }
                        .padding()
                    
                    
                    
                    Button {
                        viewModel.nextChoice(sessionID: viewModel.sesssionID, choice: viewModel.chosenCurrentIndex)
                        viewModel.sliderHeight = 0
                        viewModel.currentValue = 0
                        
                    } label: {
                        Text("NEXT")
                            .bold()
                            .font(.caption)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(viewModel.sliderHeight == 0 ? Color("ButtonInactiveColor") : Color("ButtonColor"))
                            .foregroundColor(viewModel.sliderHeight == 0 ? Color.white : Color.black)
                            .clipShape(Capsule())
                            .padding(.top, 30)
                            .padding(.horizontal, 35)
                    }
                    .disabled(viewModel.sliderHeight == 0)


                }
                
                // Up-down buttons to control slider
                VStack {
                    
                    Button {
                        
                        let sectionHeight = Int(viewModel.maxHeight) / viewModel.ticks.count
                        
                        if viewModel.sliderHeight >= -viewModel.maxHeight + 40 && viewModel.sliderHeight <= 0 {
                            viewModel.sliderHeight -= CGFloat(sectionHeight)
                        }
                        
                        let currentIndex = abs(Int(viewModel.sliderHeight) / sectionHeight)
                        
                        viewModel.chosenCurrentIndex = currentIndex
                        
                        viewModel.currentValue = viewModel.ticks[currentIndex]
                        
                    } label: {
                        Image(systemName: "chevron.up.circle.fill")
                            .foregroundColor(.white)
                            .background(Capsule().frame(width: 49, height: 49).foregroundColor(Color("ButtonColor")))
                            .cornerRadius(100)
                            .font(.system(size: 50))
                            .padding()
                            .shadow(color: Color.black.opacity(0.09), radius: 5, x: 0, y: 0)
                    }
                    
                    Button {
                        
                        let sectionHeight = Int(viewModel.maxHeight) / viewModel.ticks.count
                        
                        if viewModel.sliderHeight >= -viewModel.maxHeight && viewModel.sliderHeight <= -CGFloat(sectionHeight) {
                            viewModel.sliderHeight += CGFloat(sectionHeight)
                        }
                        
                        let currentIndex = abs(Int(viewModel.sliderHeight) / sectionHeight)
                        
                        viewModel.chosenCurrentIndex = currentIndex
                        
                        viewModel.currentValue = viewModel.ticks[currentIndex]
                        
                    } label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .foregroundColor(.white)
                            .background(Capsule().frame(width: 49, height: 49).foregroundColor(Color("ButtonColor")))
                            .cornerRadius(100)
                            .font(.system(size: 50))
                            .padding()
                            .shadow(color: Color.black.opacity(0.09), radius: 5, x: 0, y: 0)
                    }
                }
                .offset(x: 100)
                
            } else {
                // Results Title
                VStack {
                    Text("Slider Results")
                        .font(.system(.title, design: .serif))
                        .padding()
                    
                    ForEach(viewModel.sliders, id:\.id) { slider in
                        HStack {
                            Text("Slider \(slider.id):")
                                .padding(.horizontal)
                                .font(.system(.body, design: .rounded).italic())
                            
                            Text("\(slider.choice)")
                                .bold()
                                .padding(.horizontal)
                                .font(.system(.body, design: .rounded))
                            
                            Text("\(String(format: "%.2f", slider.value))")
                                .bold()
                                .padding(.horizontal)
                                .font(.system(.body, design: .rounded))
                            
                            
                        }
                        
                    }
                    
                    Button {
                        // Start over
                        viewModel.startOver()
                        
                    } label: {
                        Text("START OVER")
                            .bold()
                            .font(.caption)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .background(Color("ButtonColor"))
                            .foregroundColor(Color.black)
                            .clipShape(Capsule())
                            .padding(.top, 30)
                            .padding(.horizontal, 35)
                    }
                }
                
            }
            
            if viewModel.loading {
                ZStack {
                    Color.black.opacity(0.8)
                        .edgesIgnoringSafeArea(.all)
                    
                    Text("Loading...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                    
                }
            }
        }
        .onAppear {
            viewModel.startChoice()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
            
    }
}
