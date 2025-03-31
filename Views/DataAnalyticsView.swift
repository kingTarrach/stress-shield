//
//  data-visualization.swift
//  StressShield
//
//  Created by Austin Tarrach on 11/3/24.
//

import Foundation
import SwiftUI

struct LineChartView<T: HealthData>: View {
    var data: [T]
    var title: String
    var scale: String


    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .foregroundColor(.black)
                .padding()
            
            GeometryReader { geometry in
                let minY = T.minValue  // Get min from data type
                let maxY = T.maxValue  // Get max from data type
                let chartWidth = geometry.size.width - 80
                let chartHeight = geometry.size.height - 115
                let xStep = chartWidth / 6.0 // Calculate xStep (will be used both for data and x-axis labels)
                
                

                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.8))
                    
                    HStack {
                        YAxisLabels(minValue: minY, maxValue: maxY)
                            .padding(.leading, 8)
                        LineChartPath(
                            data: data,
                            chartWidth: chartWidth,
                            xStep: xStep,
                            chartHeight: chartHeight,
                            minY: minY,
                            maxY: maxY
                        )
                    }
                }
                
                // Add X-Axis Labels
                XAxisLabels(
                    chartWidth: chartWidth,
                    xStep: xStep,
                    scale: scale
                )
                .position(x: geometry.size.width / 2.5, y: chartHeight + 83)
            }
            .frame(height: 260)
            
            Text(scale)
                .font(.title3)
                .foregroundColor(.black)
            
            Spacer()
        }
    }
}


// Subview for the tooltip - UNUSED CURRENTLY
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
    let minValue: CGFloat
    let maxValue: CGFloat

    var body: some View {
        VStack(spacing: 12) {
            ForEach((0...5).reversed(), id: \.self) { i in
                let value = minValue + (CGFloat(i) * (maxValue - minValue) / 5)
                Text("\(Int(value))") // Convert to readable number
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(width: 50)
        .padding(.bottom, 15)
    }
}

// X-axis labels based on changable chartdata
struct XAxisLabels: View {
    var chartWidth: CGFloat
    var xStep: CGFloat
    var offsetX: CGFloat = 50
    var scale: String  // Scale can be "Hour", "Day", or "Week"

    var body: some View {
        HStack {
            ForEach(0..<7, id: \.self) { index in
                let reversedIndex = 6 - index  // Reverse order
                let formattedDate = generateDynamicLabel(index: reversedIndex, scale: scale)

                Text(formattedDate)
                    .foregroundColor(.white)
                    .font(.caption)
                    .frame(width: xStep * 0.83, alignment: .center)
                    .minimumScaleFactor(0.83)
                    .lineLimit(1)
            }
        }
        .frame(width: chartWidth)
        .offset(x: offsetX)
    }

    // Function to dynamically generate X-axis labels
    func generateDynamicLabel(index: Int, scale: String) -> String {
        let calendar = Calendar.current
        let now = Date()  // Get current time
        let formatter = DateFormatter()
        var adjustedDate: Date

        switch scale {
        case "Minute":
            // Generate minutes going backwards (9:32 PM, 9:31 PM, etc.)
            adjustedDate = calendar.date(byAdding: .minute, value: -index, to: now) ?? now
            formatter.dateFormat = "h:mma"  // Example: "9:32PM"
        case "Hour":
            // Generate hours going backwards (9:32 PM, 8:32 PM, etc.)
            adjustedDate = calendar.date(byAdding: .hour, value: -index, to: now) ?? now
            formatter.dateFormat = "h:mma"  // Example: "9:32PM"

        case "Day":
            // Generate days going backwards (3/3, 3/2, etc.)
            adjustedDate = calendar.date(byAdding: .day, value: -index, to: now) ?? now
            formatter.dateFormat = "M/d/yy"  // Example: "3/3/25"

        case "Week":
            // Generate weeks going backwards (Week starts on Sunday)
            adjustedDate = calendar.date(byAdding: .day, value: -(index * 7), to: now) ?? now
            formatter.dateFormat = "M/d/yy"  // Example: "2/24/24"

        default:
            adjustedDate = now
            formatter.dateFormat = "M/d/yy"  // Default fallback
        }

        return formatter.string(from: adjustedDate)
    }
}




// MARK: - Chart Path
struct LineChartPath<T: HealthData>: View {
    var data: [T]
    var chartWidth: CGFloat
    var xStep: CGFloat
    var chartHeight: CGFloat
    var minY: CGFloat
    var maxY: CGFloat
    
    var body: some View {
        Path { path in
            guard data.count > 1 else { return }
            let yScale = chartHeight / (maxY - minY)
            let offsetX: CGFloat = 16
            let offsetY: CGFloat = 60
            
            // Ensure the first data point has a valid value
            guard let firstValue = data[0].value else { return }
            
            let startPoint = CGPoint(
                x: chartWidth - offsetX,
                y: (maxY - CGFloat(firstValue)) * yScale + offsetY
            )
            path.move(to: startPoint)
            
            for index in 1..<data.count {
                guard let value = data[index].value else { continue } // Skip if value is nil
                
                let x = chartWidth - (CGFloat(index) * xStep) - offsetX
                let y = (maxY - CGFloat(value)) * yScale + offsetY
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        .stroke(Color.purple, lineWidth: 2)
    }
}


// Main Tab View
struct DataAnalyticsView: View {
    //Potentially Useless
    //@ObservedObject var viewModel = DataViewModel()
    
    let firestoreService = FirestoreService()
    @StateObject var stressViewModel = DataViewModel<Stress>()
       @StateObject var hrvViewModel = DataViewModel<HRVAverage>()
       @StateObject var sleepViewModel = DataViewModel<SleepTotal>()
    
    var body: some View {
        TabView {
            LineChartView(
                data: stressViewModel.healthData,
                title: "Stress Levels Over Time",
                scale: "Day"
            )
            .tag(0)
            
            LineChartView(
                data: hrvViewModel.healthData,
                title: "Heart Rate Variability Over Time",
                scale: "Day"
            )
            .tag(1)
            
            LineChartView(
                data: sleepViewModel.healthData,
                title: "Sleep Duration Over Time",
                scale: "Day"
            )
            .tag(2)
        }
        .tabViewStyle(PageTabViewStyle()) // Enables swipe navigation
        // When graphs appear, begin loading the data in for the graphs
        .onAppear {
            //firestoreService.addTestHealthData()
            
            let lastFetchDate = UserDefaults.standard.object(forKey: "lastFetchDate") as? Date
            let calendar = Calendar.current

            if let lastDate = lastFetchDate, calendar.isDateInToday(lastDate) {
                    print("Data already fetched today. Skipping API call.")
            } else {
                print("Fetching new data...")
                hrvViewModel.fetchData(from: "HRVAverage", timeScale: "Day")
                sleepViewModel.fetchData(from: "SleepTotal", timeScale: "Day")
                stressViewModel.fetchData(from: "Stress", timeScale: "Day")
            }
            //print("Chart Data:", hrvViewModel.healthData)
            
        }
    }
}

// Load preview
struct StressLevelChartView_Previews: PreviewProvider {
    static var previews: some View {
        DataAnalyticsView()
    }
}
