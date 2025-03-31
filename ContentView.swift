import SwiftUI

struct Product: Identifiable, Decodable {
    let id = UUID()
    let item_price: String
    let item_title: String
    let item_rating: String
    let item_image: String
}

class Stack {
    var prods = [Product]()
    var emptyProduct: Product {
        Product(item_price: "-1", item_title: "", item_rating: "", item_image: "")
    }
    
    func push(_ prod: Product) {
        prods.append(prod)
    }
    
    func pop() -> Product {
        if prods.count == 0 {
            return emptyProduct
        }
        else {
            return prods.removeLast()
        }
    }
}

struct Cart: Identifiable {
    let id = UUID()
    let item: Product
}

struct ContentView: View {
    @State private var products: [Product] = []
    @State private var cartItems: [Cart] = []
    @State private var isLoading = true
    @State private var index = 0
    @State private var showLogin = true
    @State private var reloadAgain = false
    @State private var stack: Stack = Stack()

    var body: some View {
        NavigationStack {  // Wrap everything inside NavigationStack
            VStack {
                if isLoading {
                    Image("manallogo").resizable().scaledToFit().frame(width: 200, height: 200)
                }
                else if showLogin {
                    LoginView(showLogin: $showLogin)
                }
                else if products.isEmpty {
                    Text("no products found")
                }
                else {
                    ZStack {
                        ForEach(products.indices.reversed(), id: \.self) { index in
                            ProductCard(
                                product: products[index],
                                onRemove: { removeProduct(at: index) },
                                addToCart: { addToCartAndRemove(at: index) }
                            )
                            .stacked(at: index, in: products.count) // Stacking effect
                        }
                    }
                }
            }
            .onAppear(perform: fetchProducts)
        }
    }


    func fetchProducts() {

        print("Fetching data...")  // Debugging

        guard let url = URL(string: "http://127.0.0.1:8000/") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    let decodedProducts = try JSONDecoder().decode([Product].self, from: data)
                    DispatchQueue.main.async {
                        for item in decodedProducts {
                            stack.push(item)
                        }
                        for val in 1...10 {
                            products.append(stack.pop())
                        }
                        isLoading = false
                        /*if user already logged in
                         showLogin= false
                         else{
                         showLogin = true}
                         */
                        showLogin = true
                        print("Fetched products: \(products)")  // Debugging
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }

    func addToCartAndRemove(at index: Int) {
        let product = products[index]
        cartItems.append(Cart(item: product))
        removeProduct(at: index)
        printCart()
    }
    func removeProduct(at index: Int) {
        withAnimation {
            products.remove(at: index)
            let prodNew = stack.pop()
            if prodNew.item_price == "-1" {
                return
            }
            else {
                products.append(prodNew)
            }
        }
    }
    func removeProduct(_ product: Product) {
        withAnimation {
            products.removeAll { $0.id == product.id }
        }
    }

    func printCart() {
        for item in cartItems {
            print("Product: \(item.item.item_title), Price: \(item.item.item_price), Rating: \(item.item.item_rating)")
        }
    }
}

struct ProductCard: View {
    let product: Product
    var onRemove: (() -> Void)? = nil
    var addToCart: (() -> Void)? = nil

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: product.item_image)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            Text(product.item_title).font(.headline)
            Text("Price: \(product.item_price)").font(.subheadline)
            Text("Rating: \(product.item_rating)").font(.subheadline)
        }
        .frame(width: 300, height: 600)
        .background(Color.blue)
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 100 {
                        addToCart?()  // Add product to cart
                    } else if gesture.translation.width < -100 {
                        onRemove?()  // Remove product from products list
                    }
                }
        )
    }
}
struct LoginView: View {
    @Binding var showLogin: Bool
    @State private var isLoggedIn = false
    @State private var createAccount = false

    var body: some View {
        NavigationStack {
            VStack {
                if isLoggedIn {
                    Text("Welcome!")
                        .font(.largeTitle)
                } else {
                    logoLoginIn()
                    Spacer()

                    (Text("By tapping 'Create Account' you agree to our").font(.custom(" Gotham-Bold", size: 14)) +
                     Text(" Terms. ").underline().font(.custom(" Gotham-Bold", size: 14)) +
                     Text("Privacy Policy.").underline().font(.custom(" Gotham-Bold", size: 14)) +
                     Text(" Learn how we process your data in our Privacy Policy.").font(.custom(" Gotham-Bold", size: 14)))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding()

                    VStack(spacing: 25) {
                        NavigationLink(destination: CreateAccountController()) {
                            Text("Create account")
                                .padding().padding(.horizontal, 50)
                                .background(Color.white)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.black)
                                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.black, lineWidth: 2))
                        }

                        Button("Sign in") {
                            isLoggedIn = true //temp
                            showLogin = false
                        }
                        .padding().padding(.horizontal, 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.black, lineWidth: 2))
                    }
                }
            }
            .padding()
            
        }
        
    }

}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 5)
    }
}
extension View {
    func logoLoginIn() -> some View {
        Image("manallogin")
            .resizable()
            .scaledToFit()
            .frame(width: 250, height: 250)
    }
}

#Preview {
    ContentView()
}
