import SwiftUI

import SwiftUI

struct AddNewPatient: View {
    @StateObject private var viewModel: AddNewPatientViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(patient: Patient){
        // _ gives access to the property wrapper itself not the wrapped value
        _viewModel = StateObject(wrappedValue: AddNewPatientViewModel(patient: patient))
    }
   
    var body: some View {
        ZStack {
            // Background that fills entire screen
            CustomBakcground()
            
            if viewModel.isSavigPatient {
                ProgressView("Please wait...")
            } else {
                // Use VStack to organize the content vertically
                VStack {
                    Text("Add New Patient")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 39/255, green: 84/255, blue: 138/255))
                        .padding(.top, 50)
                        .padding(.bottom, 30)
                    
                    VStack(spacing: 24) {
                        customInputField(title: "First Name", text: $viewModel.firstName, icon: "person", isShowError: $viewModel.isShowFirstNameError, errorMsg: $viewModel.firstNameErrorMsg)
                        
                        customInputField(title: "Last Name", text: $viewModel.lastName, icon: "person", isShowError: $viewModel.isShowLastNameError, errorMsg: $viewModel.lastNameErrorMsg)
                        
                        Button("Save") {
                            viewModel.savePatient()
                        }
                        .foregroundColor(Color(red: 39/255, green: 84/255, blue: 138/255))
                        .buttonStyle(.borderless)
                        .padding()
                        
                    }
                    .padding(.horizontal)
                    
                    Spacer() // Push content to the top
                }
            }
        }
    }
    
    private func customInputField(title: String, text: Binding<String>, icon: String, isShowError: Binding<Bool>, errorMsg: Binding<String>) -> some View {
        
        VStack(spacing: 0) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .padding(.all, 6)
                VStack {
                    TextField("\(title)", text: text)
                        .font(.body)
                        .padding(.leading, 10)
                        .foregroundColor(Color(red: 24/255, green: 59/255, blue: 78/255))
                }
                Spacer()
            }
            .padding(.all, 20)
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            
            // Use animation for the error message
            VStack {
                if isShowError.wrappedValue {
                    HStack {
                        Text("Error: \(errorMsg.wrappedValue)")
                            .foregroundColor(.red)
                            .padding(.all, 10)
                        Spacer()
                    }
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.top, 8)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isShowError.wrappedValue)
        }
        .animation(.easeInOut(duration: 0.3), value: isShowError.wrappedValue)
    }
}
    
struct CustomBakcground: View{
    var body: some View{
        GeometryReader{ geometry in
            Color(red: 245/255, green: 238/255, blue: 220/255)
                .ignoresSafeArea()
            
            Circle()
                .fill(Color(red: 194/255, green: 179/255, blue: 140/255))
                .frame(width: geometry.size.width, height: geometry.size.height)
                .position(x: geometry.size.width / 2, y: 0)
        }
    }
}

#Preview {
    AddNewPatient(patient: Patient())
}
