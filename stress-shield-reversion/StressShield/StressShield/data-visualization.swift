//
//  data-visualization.swift
//  StressShield
//
//  Created by Austin Tarrach on 11/3/24.
//

import Foundation
import SwiftUI


// This struct will hold the users data
struct UserStressData: Identifiable {
    let id = UUID()
    let date: Date
    let stressLevel: Int
}

// Sample view model to provide stress data
class StressDataViewModel: ObservableObject {
    @Published var stressData: [UserStressData] = []
    
    init() {
        // Populate with sample data
        let calendar = Calendar.current
        for day in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -day, to: Date()) {
                let stressLevel = Int.random(in: 0...100)
                stressData.append(UserStressData(date: date, stressLevel: stressLevel))
            }
        }
        stressData.sort { $0.date < $1.date } // Ensure data is sorted by date
    }
}

// Custom LineChart view
struct LineChartView: View {
    var data: [UserStressData]
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    @State private var showTooltip = false
    @State private var tooltipPosition: CGPoint = .zero
    @State private var tooltipText: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            let chartWidth = geometry.size.width - 80
            let chartHeight = geometry.size.height - 135
            let xStep = chartWidth / CGFloat(daysOfWeek.count - 1)
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black)
                VStack {
                    
                    HStack {
                        
                        YAxisLabels()
                        
                        ZStack {
                            LineChartPath(data: data, chartWidth: chartWidth, xStep: xStep, chartHeight: chartHeight) { point, score in
                                self.showTooltip = true
                                self.tooltipPosition = point
                                self.tooltipText = "\(score)"
                            } onExit: {
                                self.showTooltip = false
                            }
                            
                            if showTooltip {
                                TooltipView(text: tooltipText)
                                    .position(x: tooltipPosition.x, y: tooltipPosition.y - 20) // Position above the point
                            }
                            
                            XAxisLabels(daysOfWeek: daysOfWeek, xStep: xStep)
                        }
                    }
                    
                    Spacer()
                    
                    Text("Day") // X-axis title
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 10)
                }
            }
        }
            
    }
}

// Subview for the tooltip
struct TooltipView: View {
    let text: String

    var body: some View {
        Text(text)
            .padding(5)
            .background(Color.white)
            .cornerRadius(5)
            .shadow(radius: 3)
    }
}

// Subview for y-axis labels
struct YAxisLabels: View {
    var body: some View {
        
        VStack(spacing: 12) {
            
            ForEach((0...5).reversed(), id: \.self) { i in
                Text("\(i * 20)")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
            }
        }

        .frame(width: 50)
        .padding(.bottom, 15)
        
    }
}

struct XAxisLabels: View {
    let daysOfWeek: [String]
    var xStep: CGFloat
        
    var body: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .foregroundColor(.white)
                    .frame(width: xStep * (3/4))
                    .lineLimit(1)
            }
        }
        .offset(x: -xStep / 2, y: 105) // Offset down for x-axis labels
    }
}

// Subview for the chart line path
struct LineChartPath: View {
    var data: [UserStressData]
    var chartWidth: CGFloat
    var xStep: CGFloat
    var chartHeight: CGFloat
    var onHover: (CGPoint, Int) -> Void
    var onExit: () -> Void
    
    var body: some View {
        let maxY = CGFloat(100)
        let minY = CGFloat(0)
        let yScale = chartHeight / (maxY - minY)
        let offsetY: CGFloat = 40
        ZStack {
            // Guide lines at y levels 0, 50, and 100
            Path { path in
                let maxY = CGFloat(100)
                let yLevels: [CGFloat] = [0, 50, 100] // y levels for guide lines
                let yScale = chartHeight / maxY
                
                for yLevel in yLevels {
                    let yPosition = chartHeight - yLevel * yScale + offsetY
                    path.move(to: CGPoint(x: 0, y: yPosition))
                    path.addLine(to: CGPoint(x: chartWidth, y: yPosition))
                }
            }
            .stroke(Color.gray.opacity(0.8), style: StrokeStyle(lineWidth: 1, dash: [5])) // Dashed gray line
            
            // Main chart Path
            Path { path in
                guard data.count > 1 else { return }

                let offsetX = (chartWidth - xStep * CGFloat(data.count - 1)) / 2
                
                
                let startPoint = CGPoint(x: offsetX, y: chartHeight + offsetY - CGFloat(data[0].stressLevel) * yScale)
                path.move(to: startPoint)
                
                for index in 1..<data.count {
                    let prev_x = CGFloat(index - 1) * xStep
                    let prev_y = chartHeight + offsetY - CGFloat(data[index - 1].stressLevel) * yScale
                    let curr_x = CGFloat(index) * xStep
                    let curr_y = chartHeight + offsetY - CGFloat(data[index].stressLevel) * yScale
                    let previousPoint = CGPoint(x: prev_x, y: prev_y)
                    let currentPoint = CGPoint(x: curr_x, y: curr_y)
                    
                    let midPoint = CGPoint(x: (previousPoint.x + currentPoint.x) / 2, y: (previousPoint.y + currentPoint.y) / 2)
                                    
                    path.addQuadCurve(to: midPoint, control: previousPoint)
                    
                    
                }
            }
            .stroke(Color.purple, lineWidth: 2)
        }
    }
}

// Main view
struct StressLevelChartView: View {
    @ObservedObject var viewModel = StressDataViewModel()
    
    var body: some View {
        VStack {
            Text("Daily Stress Levels by Week")
                .font(.title)
                .padding()
            
            LineChartView(data: viewModel.stressData)
                .frame(height: 300)
                .padding()
        }
    }
}

struct StressLevelChartView_Previews: PreviewProvider {
    static var previews: some View {
        StressLevelChartView()
    }
}
