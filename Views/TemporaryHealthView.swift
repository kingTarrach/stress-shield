import SwiftUI

struct TemporaryHealthView: View {
    @StateObject private var viewModel = HealthViewModel()
        
        var body: some View {
            NavigationView {
                VStack {
                    if viewModel.isAuthorized {
                        // Show health data
                        List {
                            Section(header: Text("Heart Rate Variability")) {
                                ForEach(viewModel.heartRateVariability.keys.sorted(), id: \.self) { date in
                                    HStack {
                                        Text(date)
                                        Spacer()
                                        Text("\(viewModel.heartRateVariability[date]!, specifier: "%.1f")")
                                    }
                                }
                            }
                            
                            Section(header: Text("Sleep Data")) {
                                ForEach(viewModel.sleepData.keys.sorted(), id: \.self) { date in
                                    HStack {
                                        Text(date)
                                        Spacer()
                                        Text("\(viewModel.sleepData[date]!, specifier: "%.1f") hours")
                                    }
                                }
                            }
                        }
                    } else {
                        // Prompt user to authorize HealthKit
                        VStack {
                            Text("Health Data Access Needed")
                                .font(.headline)
                                .padding()
                            
                            Text("To use this app, please grant access to Health data in the Health app settings.")
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Button(action: {
                                viewModel.checkAuthorizationAndFetchData()
                            }) {
                                Text("Authorize HealthKit")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding()
                        }
                    }
                }
                .navigationTitle("Health Data")
                .onAppear {
                    viewModel.checkAuthorizationAndFetchData()
                }
            }
        }
}


#Preview {
    TemporaryHealthView()
}
