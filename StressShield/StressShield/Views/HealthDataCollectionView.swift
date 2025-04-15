import SwiftUI

struct HealthDataCollectionView: View {
    @StateObject private var viewModel = HealthViewModel()

    var body: some View {
        Group {
            if !viewModel.isAuthorized {
                VStack {
                    Text("Health Data Access Needed")
                        .font(.headline)
                        .padding()

                    Text("Please grant access to Health data in the Health app settings.")
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
            } else {
                // Show nothing when authorized
                EmptyView()
            }
        }
        .onAppear {
            viewModel.checkAuthorizationAndFetchData()
        }
    }
}



#Preview {
    HealthDataCollectionView()
}
