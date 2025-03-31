import SwiftUI

struct CreateAccountController: View {
    @State private var text: String = ""
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Create Account")
                    .font(.system(size: 18))
                    .padding(.horizontal)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.bottom, -20)
                    .foregroundColor(Color(red: 239/255, green: 131/255, blue: 26/255)) // Normalize RGB
                Text("Provide Your info")
                    .font(.caption)
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                    .foregroundColor(.gray.opacity(0.8))
                    
                Text("Full name")
                    .font(.system(size: 14))
                    .padding(.leading, 20)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)

                TextField("Full name", text: $text)
                    .frame(height: 50)
                    .padding(.leading, 15)
                    .background(RoundedRectangle(cornerRadius: 30).fill(Color.white.opacity(0.2)))
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                Text("Email")
                    .font(.system(size: 14))
                    .padding(.leading, 20)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)

                TextField("Email", text: $text)
                    .frame(height: 50)
                    .padding(.leading, 15)
                    .background(RoundedRectangle(cornerRadius: 30).fill(Color.white.opacity(0.2)))
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                Text("Password")
                    .font(.system(size: 14))
                    .padding(.leading, 20)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)

                TextField("Password", text: $text)
                    .frame(height: 50)
                    .padding(.leading, 15)
                    .background(RoundedRectangle(cornerRadius: 30).fill(Color.white.opacity(0.2)))
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
            }
            Text("Create Account Screen")
                .font(.title)
                .padding()

            Text("Enter your details to create an account")
                .font(.subheadline)
                .padding()

            Spacer()
        }
        .navigationTitle("manal")
    }
    func customTextField(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.system(size: 14))
                .padding(.leading, 20)
                .fontWeight(.semibold)

            TextField(label, text: text)
                .frame(height: 50)
                .padding(.leading, 15)
                .background(RoundedRectangle(cornerRadius: 30).fill(Color.white.opacity(0.2)))
                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
    }
}
