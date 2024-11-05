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
            let chartWidth = geometry.size.width - 75
            let xStep = chartWidth / CGFloat(daysOfWeek.count - 1)
            VStack {
                HStack {
                    YAxisLabels()
                    
                    ZStack {
                        LineChartPath(data: data, chartWidth: chartWidth, xStep: xStep, chartHeight: geometry.size.height - 135) { point, score in
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

struct YAxisLabels: View {
    var body: some View {
        VStack(spacing: 10) {
            ForEach((0...5).reversed(), id: \.self) { i in
                Text("\(i * 20)")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(width: 40)
    }
}

struct XAxisLabels: View {
    let daysOfWeek: [String]
    var xStep: CGFloat
        
    var body: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .frame(width: xStep)
                    .lineLimit(1)
                    .padding(0-(xStep / 12.5))    // Needed to bring labels together
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
        Path { path in
            guard data.count > 1 else { return }
            
            let maxY = CGFloat(100)
            let minY = CGFloat(0)
            let yScale = chartHeight / (maxY - minY)
            let offsetX = (chartWidth - xStep * CGFloat(data.count - 1)) / 2
            let offsetY: CGFloat = 40
            
            // Start point
            let startPoint = CGPoint(x: 0, y: CGFloat(data[0].stressLevel) * yScale + offsetY)
            path.move(to: startPoint)
            
            for (index, dataPoint) in data.enumerated() {
                let x = offsetX + CGFloat(index) * xStep
                let y = CGFloat(dataPoint.stressLevel) * yScale + offsetY
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        .stroke(Color.blue, lineWidth: 2)
    }
}

// Main view
struct StressLevelChartView: View {
    @ObservedObject var viewModel = StressDataViewModel()
    
    var body: some View {
        VStack {
            Text("Daily Stress Levels")
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
