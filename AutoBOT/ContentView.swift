import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    
    @State private var messageText = ""
    @State var messages: [String] = ["Welcome To Auto Bot 1.0"]
    
    var body: some View {
        VStack {
            HStack{
                Text("AutoBOT")
                    .font(.largeTitle)
                    .bold()
                Image(systemName: "bonjour")
                    .font(.system(size: 30))
                    .foregroundColor(Color.blue)
            }
            ScrollView{
                ForEach(messages, id: \.self){ message in
                    if message.contains("[USER]"){
                        let newMessage = message.replacingOccurrences(of: "[USER]", with: "")
                        
                        HStack{
                            Spacer()
                            Text(newMessage)
                                .padding()
                                .foregroundColor(.white)
                                .background(.blue.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                        }
                    }else{
                        HStack{
                            Text(message)
                                .padding()
                                .background(.gray.opacity(0.15))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                    }
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
            
            HStack{
                TextField("Type Something...", text: $messageText, axis: .vertical)
                    .lineLimit(5)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .autocorrectionDisabled(true)
                    .cornerRadius(10)
                    .onSubmit {
                        sendMessage(message: messageText)
                    }
                Button{
                    sendMessage(message: messageText)
                }label: {
                    Image(systemName: "paperplane.fill")
                }
                .font(.system(size: 26))
                .padding(.horizontal, 10)
            }
        }
        .padding()
    }
    
    func generateResponse(for message: String) {
        Task {
            do {
                let result = try await model.generateContent(message)
                if let responseText = result.text {
                    DispatchQueue.main.async {
                        withAnimation {
                            messages.append(responseText)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        withAnimation {
                            messages.append("No response found")
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    withAnimation {
                        messages.append("Something went wrong\n\(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func sendMessage(message: String) {
        withAnimation {
            messages.append("[USER] " + message)
            self.messageText = ""
        }
        generateResponse(for: message)
    }
}

#Preview {
    ContentView()
}
