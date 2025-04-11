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
            VStack(spacing: 24){
                customInputField(title: "First Name", text: $viewModel.firstName, icon: "person", isShowError: $viewModel.isShowFirstNameError, errorMsg: $viewModel.firstNameErrorMsg)
                customInputField(title: "Last Name", text: $viewModel.lastName, icon: "person", isShowError: $viewModel.isShowLastNameError, errorMsg: $viewModel.lastNameErrorMsg)
                
                Button("Save"){
                    
                }
                .buttonStyle(.borderless)
            }
            
        }
    }
    
    private func customInputField(title: String, text: Binding<String>, icon: String, isShowError: Binding<Bool>, errorMsg: Binding<String>)-> some View{
        HStack{
            Image(systemName: icon)
                .foregroundColor(.blue)
                .padding(.all, 6)
            VStack{
                
                TextField("\(title)", text: text)
                    .font(.body)
                    .padding(.leading, 10)
                    .foregroundColor(Color(red: 24/255, green: 59/255, blue: 78/255))
            }
        }
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
