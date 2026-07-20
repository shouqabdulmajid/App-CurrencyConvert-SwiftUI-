import SwiftUI

struct ExchangeRateResponse: Codable {
    let rates: [String: Double]
}

struct ContentView: View {
    @State private var showWelcomeScreen: Bool = true
    @State private var inputAmount: String = ""
    @State private var resultAmount: Double = 0.0
    @State private var isLoading: Bool = false
    
    @AppStorage("favoriteCurrency") private var selectedCurrency: String = "USD"
    
    let availableCurrencies = ["USD", "EUR", "AED", "GBP", "JPY"]
    
    var body: some View {
        if showWelcomeScreen {
            NavigationStack {
                ZStack {
                    LinearGradient(colors: [Color.blue.opacity(0.2), Color(.systemBackground)],
                                   startPoint: .top,
                                   endPoint: .bottom)
                    .ignoresSafeArea()
                    
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "circle.grid.cross.down.filled")
                            .font(.system(size: 90))
                            .foregroundColor(.white)
                            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 10)
                        
                        VStack(spacing: 12) {
                            Text("مرحباً بك في محول العملات الذكي")
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            Text("التطبيق الآمن لمعرفة أسعار الصرف الحية فوراً من الإنترنت")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                showWelcomeScreen = false
                            }
                        }) {
                            Text("ابدأ الآن")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(14)
                                .shadow(color: Color.blue.opacity(0.4), radius: 8, x: 0, y: 5)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                    }
                }
            }
        } else {
            NavigationStack {
                ZStack {
                    LinearGradient(colors: [Color.blue.opacity(0.15), Color(.systemBackground)],
                                   startPoint: .top,
                                   endPoint: .bottom)
                    .ignoresSafeArea()
                    
                    VStack(spacing: 25) {
                        
                        Image(systemName: "globe.asia.australia.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.green)
                            .padding(.top, 20)
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            Text("المبلغ بالريال السعودي (SAR):")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            TextField("أدخلي المبلغ هنا...", text: $inputAmount)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(12)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            Text("اختر العملة:")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Picker("العملة", selection: $selectedCurrency) {
                                ForEach(availableCurrencies, id: \.self) { currency in
                                    Text(currency)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            fetchLiveRatesAndConvert()
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .padding(.horizontal, 5)
                                }
                                Text(isLoading ? "جاري جلب الأسعار..." : "تحويل بأسعار حية ")
                            }
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isLoading ? Color.gray : Color.blue)
                            .cornerRadius(12)
                            .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 4)
                        }
                        .disabled(isLoading)
                        .padding(.horizontal)
                        
                        VStack(spacing: 10) {
                            Text("النتيجة التقريبية الحية:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(String(format: "%.2f", resultAmount))
                                .font(.system(size: 55, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                            
                            Text(selectedCurrency)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
                .navigationTitle("محول العملات الذكي")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation(.spring()) {
                                showWelcomeScreen = true
                            }
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: "chevron.left")
                                Text("الرئيسية")
                            }
                            .foregroundColor(.indigo)
                        }
                    }
                }
            }
        }
    }
    
    func fetchLiveRatesAndConvert() {
        let amount = Double(inputAmount) ?? 0.0
        guard amount > 0 else { return }
        
        isLoading = true
        
        guard let url = URL(string: "https://open.er-api.com/v6/latest/SAR") else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(ExchangeRateResponse.self, from: data) {
                    
                    DispatchQueue.main.async {
                        if let rate = decodedResponse.rates[selectedCurrency] {
                            self.resultAmount = amount * rate
                        }
                        self.isLoading = false
                    }
                } else {
                    DispatchQueue.main.async { self.isLoading = false }
                }
            } else {
                DispatchQueue.main.async { self.isLoading = false }
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
