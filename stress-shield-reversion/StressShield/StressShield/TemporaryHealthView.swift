import SwiftUI

struct TemporaryHealthView: View {
    @StateObject var viewModel = HealthViewModel()
    
    var body: some View {
        VStack {
            // Display HRV Data
            if !viewModel.heartRateVariabilityDataAveraged.isEmpty {
                VStack(alignment: .leading) {
                    Text("Heart Rate Variability Data")
                        .font(.headline)
                    ForEach(viewModel.heartRateVariabilityDataAveraged.keys.sorted(), id: \.self) { date in
                        Text("\(date): \(viewModel.heartRateVariabilityDataAveraged[date] ?? 0.0, specifier: "%.2f")")
                    }
                }
                .padding()
            }
            
            // Display Sleep Data
            if !viewModel.sleepDataPerDay.isEmpty {
                VStack(alignment: .leading) {
                    Text("Sleep Data")
                        .font(.headline)
                    ForEach(viewModel.sleepDataPerDay.keys.sorted(), id: \.self) { date in
                        Text("\(date): \(viewModel.sleepDataPerDay[date] ?? 0.0, specifier: "%.2f") hours")
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchHealthData { error in
                if let error = error {
                    // Handle error (e.g., show an alert)
                    print("Failed to fetch data: \(error.localizedDescription)")
                }
            }
        }
    }
}