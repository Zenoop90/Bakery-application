//
//  ContentView.swift
//  Bakery App — iOS App Development Intern Project


import SwiftUI
public import Combine

// ─────────────────────────────────────────────
// MARK: - Data Models
// ─────────────────────────────────────────────

struct BakeryItem: Identifiable, Sendable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    let emoji: String
    let category: String
}

struct CartItem: Identifiable, Sendable {
    let id = UUID()
    let item: BakeryItem
    var quantity: Int
}

// ─────────────────────────────────────────────
// MARK: - App State (Observable)
// ─────────────────────────────────────────────

@MainActor
class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: String = ""
    @Published var cartItems: [CartItem] = []

    var cartTotal: Double {
        cartItems.reduce(0) { $0 + ($1.item.price * Double($1.quantity)) }
    }

    var cartCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }

    func addToCart(_ item: BakeryItem) {
        if let index = cartItems.firstIndex(where: { $0.item.id == item.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(CartItem(item: item, quantity: 1))
        }
    }

    func removeFromCart(_ cartItem: CartItem) {
        cartItems.removeAll { $0.id == cartItem.id }
    }

    func clearCart() {
        cartItems.removeAll()
    }
}

// ─────────────────────────────────────────────
// MARK: - Sample Data
// ─────────────────────────────────────────────

let sampleItems: [BakeryItem] = [
    BakeryItem(name: "Butter Croissant",      description: "Flaky, golden croissant made with premium French butter. Perfect for breakfast.",           price: 3.99,  emoji: "🥐", category: "Pastries"),
    BakeryItem(name: "Chocolate Cake",        description: "Rich triple-layered chocolate cake with dark chocolate ganache frosting.",                  price: 42.00, emoji: "🎂", category: "Cakes"),
    BakeryItem(name: "Blueberry Muffin",      description: "Soft, moist muffin loaded with fresh blueberries and a crunchy streusel topping.",          price: 2.99,  emoji: "🫐", category: "Muffins"),
    BakeryItem(name: "Sourdough Bread",       description: "Artisan slow-fermented sourdough with a crispy crust and airy crumb.",                     price: 8.50,  emoji: "🍞", category: "Breads"),
    BakeryItem(name: "Cinnamon Roll",         description: "Soft, gooey cinnamon roll drizzled with sweet cream-cheese glaze.",                        price: 4.50,  emoji: "🌀", category: "Pastries"),
    BakeryItem(name: "Strawberry Cheesecake", description: "New York-style cheesecake topped with fresh strawberry compote.",                           price: 38.00, emoji: "🍰", category: "Cakes"),
    BakeryItem(name: "Banana Bread",          description: "Moist, fragrant banana bread with walnuts and a hint of vanilla.",                         price: 7.00,  emoji: "🍌", category: "Breads"),
    BakeryItem(name: "Macaron",               description: "Delicate French almond macaron in assorted flavours — rose, pistachio, and lemon.",        price: 2.50,  emoji: "🍬", category: "Pastries"),
    BakeryItem(name: "Chocolate Chip Cookie", description: "Classic chewy cookie loaded with semi-sweet chocolate chips, fresh from the oven.",        price: 1.99,  emoji: "🍪", category: "Cookies"),
    BakeryItem(name: "Red Velvet Cupcake",    description: "Velvety red cupcake topped with a swirl of smooth cream-cheese frosting.",                 price: 3.50,  emoji: "🧁", category: "Cakes"),
    BakeryItem(name: "Pretzel",               description: "Warm, soft pretzel with a golden brown crust, served with honey-mustard dipping sauce.",   price: 3.00,  emoji: "🥨", category: "Breads"),
    BakeryItem(name: "Lemon Tart",            description: "Crisp buttery pastry shell filled with tangy lemon curd and topped with meringue kisses.", price: 5.50,  emoji: "🍋", category: "Pastries"),
]

let categories = ["All", "Pastries", "Cakes", "Breads", "Muffins", "Cookies"]

// ─────────────────────────────────────────────
// MARK: - Color Theme
// ─────────────────────────────────────────────

extension Color {
    static let warmBrown    = Color(red: 0.55, green: 0.30, blue: 0.10)
    static let softCream    = Color(red: 1.00, green: 0.97, blue: 0.88)
    static let goldenYellow = Color(red: 0.95, green: 0.75, blue: 0.20)
}

// ─────────────────────────────────────────────
// MARK: - Best Sellers Data
// ─────────────────────────────────────────────

let bestSellers: [BakeryItem] = [
    sampleItems[0],  // Butter Croissant
    sampleItems[2],  // Blueberry Muffin
    sampleItems[4],  // Cinnamon Roll
    sampleItems[8],  // Chocolate Chip Cookie
]

// ─────────────────────────────────────────────
// MARK: - Bakery Quotes
// ─────────────────────────────────────────────

let bakeryQuotes: [(text: String, author: String)] = [
    (text: "Life is what you bake it.", author: "Sweet Crumbs"),
    (text: "Good bread is the most fundamentally satisfying of all foods.", author: "James Beard"),
    (text: "Baking is love made edible.", author: "Unknown"),
    (text: "A day without bread is a day lost.", author: "Old Proverb"),
    (text: "First we eat, then we do everything else.", author: "M.F.K. Fisher"),
    (text: "Stressed is just desserts spelled backwards.", author: "Unknown"),
]

// ─────────────────────────────────────────────
// MARK: - QuoteCardView
// ─────────────────────────────────────────────

struct QuoteCardView: View {
    @State private var currentIndex = 0
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    var body: some View {
        let quote = bakeryQuotes[currentIndex]
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: [Color(red: 0.40, green: 0.20, blue: 0.05), Color.warmBrown],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))

            VStack(spacing: 12) {
                Text("❝")
                    .font(.system(size: 36))
                    .foregroundColor(.white.opacity(0.6))

                Text(quote.text)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .transition(.opacity)
                    .id(currentIndex)          // forces SwiftUI to re-render on change

                Text("— \(quote.author)")
                    .font(.caption)
                    .foregroundColor(.goldenYellow)
                    .italic()

                // Dot indicator
                HStack(spacing: 6) {
                    ForEach(0..<bakeryQuotes.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentIndex ? Color.goldenYellow : Color.white.opacity(0.35))
                            .frame(width: 6, height: 6)
                    }
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentIndex = (currentIndex + 1) % bakeryQuotes.count
            }
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - BestSellerRow
// ─────────────────────────────────────────────

struct BestSellerRow: View {
    let rank: Int
    let item: BakeryItem

    private var medal: String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return "🏅"
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            Text(medal).font(.title2).frame(width: 34)

            Text(item.emoji)
                .font(.system(size: 36))
                .frame(width: 52, height: 52)
                .background(Color.softCream)
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.warmBrown)
                Text(item.category)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.warmBrown)
                Text("Top Pick")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Color.goldenYellow)
                    .cornerRadius(6)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.06), radius: 5, y: 2)
    }
}

// ─────────────────────────────────────────────
// MARK: - ContentView (Entry Point)
// ─────────────────────────────────────────────

struct ContentView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        if appState.isLoggedIn {
            HomeView()
                .environmentObject(appState)
        } else {
            LoginView()
                .environmentObject(appState)
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - Login_View
// ─────────────────────────────────────────────

struct Login_View: View {
    @EnvironmentObject var appState: AppState
    @State private var email: String    = ""
    @State private var password: String = ""
    @State private var showError        = false
    @State private var errorMessage     = ""
    @State private var isLoading        = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.warmBrown, Color.softCream],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {

                        // Header
                        VStack(spacing: 8) {
                            Text("🥖")
                                .font(.system(size: 80))
                            Text("Sweet Crumbs")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Bakery & Café")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top, 60)

                        // Card
                        VStack(spacing: 20) {
                            Text("Welcome Back!")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.warmBrown)

                            VStack(alignment: .leading, spacing: 6) {
                                Label("Email", systemImage: "envelope")
                                    .font(.caption).foregroundColor(.gray)
                                TextField("you@example.com", text: $email)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .padding(12)
                                    .background(Color.softCream)
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.warmBrown.opacity(0.3), lineWidth: 1))
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Label("Password", systemImage: "lock")
                                    .font(.caption).foregroundColor(.gray)
                                SecureField("••••••••", text: $password)
                                    .padding(12)
                                    .background(Color.softCream)
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.warmBrown.opacity(0.3), lineWidth: 1))
                            }

                            if showError {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }

                            Button { handleLogin() } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.warmBrown)
                                        .frame(height: 50)
                                    if isLoading {
                                        ProgressView().tint(.white)
                                    } else {
                                        Text("Log In")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                }
                            }

                            HStack {
                                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                                Text("OR").font(.caption).foregroundColor(.gray)
                                Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                            }

                            NavigationLink(destination: SignUp_View()) {
                                Text("Don't have an account? ")
                                    .foregroundColor(.gray) 
                                Text("Sign Up")
                                    .foregroundColor(.warmBrown)
                                    .fontWeight(.semibold)
                            }
                            .font(.subheadline)
                        }
                        .padding(24)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 24)

                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func handleLogin() {
        showError    = false
        errorMessage = ""
        guard !email.isEmpty    else { errorMessage = "Please enter your email.";    showError = true; return }
        guard !password.isEmpty else { errorMessage = "Please enter your password."; showError = true; return }
        guard password.count >= 6 else { errorMessage = "Password must be at least 6 characters."; showError = true; return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoading = false
            let name = email.components(separatedBy: "@").first ?? "User"
            appState.currentUser = name.capitalized
            appState.isLoggedIn  = true
        }
    }
}

// Alias so ContentView can use Login_View via LoginView name
typealias LoginView = Login_View

// ─────────────────────────────────────────────
// MARK: - SignUp_View
// ─────────────────────────────────────────────

struct SignUp_View: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    @State private var fullName  = ""
    @State private var email     = ""
    @State private var password  = ""
    @State private var confirm   = ""
    @State private var showError = false
    @State private var errorMsg  = ""
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color.softCream.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text("🧁")
                        .font(.system(size: 60))
                        .padding(.top, 20)

                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.warmBrown)

                    VStack(spacing: 16) {
                        inputField(label: "Full Name",        icon: "person",    placeholder: "John Doe",           text: $fullName,  secure: false)
                        inputField(label: "Email",            icon: "envelope",  placeholder: "you@example.com",    text: $email,     secure: false)
                        inputField(label: "Password",         icon: "lock",      placeholder: "Min. 6 characters",  text: $password,  secure: true)
                        inputField(label: "Confirm Password", icon: "lock.fill", placeholder: "Re-enter password",  text: $confirm,   secure: true)
                    }

                    if showError {
                        Text(errorMsg)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }

                    Button { handleSignUp() } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.warmBrown)
                                .frame(height: 50)
                            if isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text("Sign Up")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                    }

                    Button("Already have an account? Log In") { dismiss() }
                        .font(.subheadline)
                        .foregroundColor(.warmBrown)
                }
                .padding(24)
            }
        }
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func inputField(label: String, icon: String, placeholder: String, text: Binding<String>, secure: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(label, systemImage: icon)
                .font(.caption).foregroundColor(.gray)
            if secure {
                SecureField(placeholder, text: text)
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.warmBrown.opacity(0.3), lineWidth: 1))
            } else {
                TextField(placeholder, text: text)
                    .autocapitalization(.none)
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.warmBrown.opacity(0.3), lineWidth: 1))
            }
        }
    }

    private func handleSignUp() {
        showError = false; errorMsg = ""
        guard !fullName.isEmpty   else { errorMsg = "Please enter your full name."; showError = true; return }
        guard !email.isEmpty      else { errorMsg = "Please enter your email.";     showError = true; return }
        // Single guard handles both empty AND too-short passwords
        guard password.count >= 6 else {
            errorMsg = password.isEmpty
                ? "Please enter a password."
                : "Password must be at least 6 characters. You entered \(password.count)."
            showError = true; return
        }
        guard password == confirm else  { errorMsg = "Passwords do not match.";     showError = true; return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoading = false
            appState.currentUser = fullName.components(separatedBy: " ").first ?? fullName
            appState.isLoggedIn  = true
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - HomeView
// ─────────────────────────────────────────────

struct HomeView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ZStack {
                Color.softCream.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // Greeting banner
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(
                                    colors: [Color.warmBrown, Color(red: 0.75, green: 0.45, blue: 0.20)],
                                    startPoint: .leading, endPoint: .trailing
                                ))
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Hello, \(appState.currentUser)! 👋")
                                        .font(.title2).fontWeight(.bold).foregroundColor(.white)
                                    Text("What would you like today?")
                                        .font(.subheadline).foregroundColor(.white.opacity(0.85))
                                }
                                Spacer()
                                Text("🥖").font(.system(size: 60))
                            }
                            .padding(20)
                        }
                        .padding(.horizontal)

                        // Quick actions
                        Text("Quick Actions")
                            .font(.headline).foregroundColor(.warmBrown).padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            NavigationLink(destination: MenuView()) {
                                QuickActionCard(emoji: "🍰", title: "Full Menu",  subtitle: "Browse all items",       color: Color.warmBrown)
                            }
                            NavigationLink(destination: CartView()) {
                                QuickActionCard(emoji: "🛒", title: "My Cart",   subtitle: "\(appState.cartCount) items", color: Color(red: 0.20, green: 0.55, blue: 0.30))
                            }
                            NavigationLink(destination: AboutView()) {
                                QuickActionCard(emoji: "ℹ️", title: "About Us",  subtitle: "Our story",              color: Color(red: 0.20, green: 0.40, blue: 0.65))
                            }
                            NavigationLink(destination: ProfileView()) {
                                QuickActionCard(emoji: "👤", title: "Profile",   subtitle: appState.currentUser,     color: Color(red: 0.55, green: 0.20, blue: 0.55))
                            }
                        }
                        .padding(.horizontal)

                        // ── Daily Quote Card ──────────────────────────
                        QuoteCardView()
                            .padding(.horizontal)

                        // ── Best Sellers ──────────────────────────────
                        HStack {
                            Text("🏆 Best Sellers")
                                .font(.headline).foregroundColor(.warmBrown)
                            Spacer()
                            NavigationLink(destination: MenuView()) {
                                Text("See all")
                                    .font(.caption).foregroundColor(.warmBrown)
                                    .underline()
                            }
                        }
                        .padding(.horizontal)

                        VStack(spacing: 12) {
                            ForEach(Array(bestSellers.enumerated()), id: \.element.id) { index, item in
                                NavigationLink(destination: ItemDetailView(item: item)) {
                                    BestSellerRow(rank: index + 1, item: item)
                                }
                            }
                        }
                        .padding(.horizontal)

                        // Featured items
                        Text("Today's Specials 🌟")
                            .font(.headline).foregroundColor(.warmBrown).padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(sampleItems.prefix(6)) { item in
                                    NavigationLink(destination: ItemDetailView(item: item)) {
                                        FeaturedItemCard(item: item)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Categories
                        Text("Categories")
                            .font(.headline).foregroundColor(.warmBrown).padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(categories.dropFirst(), id: \.self) { cat in
                                    NavigationLink(destination: MenuView(initialCategory: cat)) {
                                        CategoryPill(name: cat)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        Spacer(minLength: 30)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Sweet Crumbs 🥐")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CartView()) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart").font(.title3).foregroundColor(.warmBrown)
                            if appState.cartCount > 0 {
                                Text("\(appState.cartCount)")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white).padding(3)
                                    .background(Color.red).clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        appState.isLoggedIn = false
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.warmBrown)
                    }
                }
            }
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - MenuView
// ─────────────────────────────────────────────

struct MenuView: View {
    @EnvironmentObject var appState: AppState
    @State var initialCategory: String = "All"
    @State private var selectedCategory: String = "All"
    @State private var searchText: String = ""

    var filteredItems: [BakeryItem] {
        sampleItems.filter { item in
            let matchCat    = selectedCategory == "All" || item.category == selectedCategory
            let matchSearch = searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
            return matchCat && matchSearch
        }
    }

    var body: some View {
        ZStack {
            Color.softCream.ignoresSafeArea()
            VStack(spacing: 0) {

                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.gray)
                    TextField("Search items...", text: $searchText).autocapitalization(.none)
                }
                .padding(10)
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal).padding(.top, 8)

                // Category filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(categories, id: \.self) { cat in
                            Button { selectedCategory = cat } label: {
                                Text(cat)
                                    .font(.subheadline).fontWeight(.medium)
                                    .padding(.horizontal, 16).padding(.vertical, 8)
                                    .background(selectedCategory == cat ? Color.warmBrown : Color.white)
                                    .foregroundColor(selectedCategory == cat ? .white : .warmBrown)
                                    .cornerRadius(20)
                                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.warmBrown, lineWidth: 1))
                            }
                        }
                    }
                    .padding(.horizontal).padding(.vertical, 10)
                }

                if filteredItems.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Text("🔍").font(.system(size: 50))
                        Text("No items found").foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(filteredItems) { item in
                                NavigationLink(destination: ItemDetailView(item: item)) {
                                    MenuItemCard(item: item)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Our Menu")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { selectedCategory = initialCategory }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: CartView()) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart").foregroundColor(.warmBrown)
                        if appState.cartCount > 0 {
                            Text("\(appState.cartCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white).padding(3)
                                .background(Color.red).clipShape(Circle())
                                .offset(x: 8, y: -8)
                        }
                    }
                }
            }
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - ItemDetailView
// ─────────────────────────────────────────────

struct ItemDetailView: View {
    @EnvironmentObject var appState: AppState
    let item: BakeryItem
    @State private var quantity  = 1
    @State private var showToast = false

    var body: some View {
        ZStack {
            Color.softCream.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {

                    // Hero
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(
                                colors: [Color.warmBrown.opacity(0.15), Color.goldenYellow.opacity(0.3)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ))
                            .frame(height: 260)
                        Text(item.emoji).font(.system(size: 120))
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.title2).fontWeight(.bold).foregroundColor(.warmBrown)
                                Text(item.category)
                                    .font(.caption).foregroundColor(.white)
                                    .padding(.horizontal, 10).padding(.vertical, 4)
                                    .background(Color.warmBrown).cornerRadius(10)
                            }
                            Spacer()
                            Text("$\(item.price, specifier: "%.2f")")
                                .font(.title).fontWeight(.bold).foregroundColor(.warmBrown)
                        }

                        Divider()

                        Text("Description")
                            .font(.headline).foregroundColor(.warmBrown)
                        Text(item.description)
                            .font(.body).foregroundColor(.secondary).lineSpacing(4)

                        Divider()

                        // Quantity
                        HStack {
                            Text("Quantity").font(.headline).foregroundColor(.warmBrown)
                            Spacer()
                            HStack(spacing: 16) {
                                Button { if quantity > 1 { quantity -= 1 } } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(quantity > 1 ? .warmBrown : .gray)
                                }
                                Text("\(quantity)").font(.title3).fontWeight(.semibold).frame(minWidth: 30)
                                Button { quantity += 1 } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2).foregroundColor(.warmBrown)
                                }
                            }
                        }

                        HStack {
                            Text("Total").font(.headline)
                            Spacer()
                            Text("$\(item.price * Double(quantity), specifier: "%.2f")")
                                .font(.title3).fontWeight(.bold).foregroundColor(.warmBrown)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4)

                        Button {
                            for _ in 0..<quantity { appState.addToCart(item) }
                            withAnimation { showToast = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { showToast = false }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "cart.badge.plus")
                                Text("Add to Cart").fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.warmBrown)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                        }
                    }
                    .padding(20)
                }
            }

            if showToast {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                        Text("Added to cart!").fontWeight(.medium)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(radius: 8)
                    .padding(.bottom, 30)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// ─────────────────────────────────────────────
// MARK: - CartView
// ─────────────────────────────────────────────

struct CartView: View {
    @EnvironmentObject var appState: AppState
    @State private var showOrderPlaced = false

    var body: some View {
        ZStack {
            Color.softCream.ignoresSafeArea()

            if appState.cartItems.isEmpty {
                VStack(spacing: 16) {
                    Text("🛒").font(.system(size: 70))
                    Text("Your cart is empty").font(.title3).foregroundColor(.gray)
                    Text("Go to the menu and add some goodies!")
                        .font(.subheadline).foregroundColor(.gray.opacity(0.8)).multilineTextAlignment(.center)
                    NavigationLink(destination: MenuView()) {
                        Text("Browse Menu")
                            .font(.headline).foregroundColor(.white)
                            .padding().background(Color.warmBrown).cornerRadius(12)
                    }
                }
                .padding()
            } else {
                VStack(spacing: 0) {
                    List {
                        ForEach(appState.cartItems) { cartItem in
                            HStack(spacing: 14) {
                                Text(cartItem.item.emoji)
                                    .font(.system(size: 36))
                                    .frame(width: 50, height: 50)
                                    .background(Color.softCream).cornerRadius(10)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(cartItem.item.name)
                                        .font(.subheadline).fontWeight(.semibold).foregroundColor(.warmBrown)
                                    Text("$\(cartItem.item.price, specifier: "%.2f") each")
                                        .font(.caption).foregroundColor(.gray)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("x\(cartItem.quantity)")
                                        .font(.subheadline).fontWeight(.bold).foregroundColor(.warmBrown)
                                    Text("$\(cartItem.item.price * Double(cartItem.quantity), specifier: "%.2f")")
                                        .font(.caption).foregroundColor(.gray)
                                }
                                Button { appState.removeFromCart(cartItem) } label: {
                                    Image(systemName: "trash").foregroundColor(.red.opacity(0.7))
                                }
                            }
                            .listRowBackground(Color.white)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)

                    // Order summary
                    VStack(spacing: 12) {
                        HStack { Text("Subtotal"); Spacer(); Text("$\(appState.cartTotal, specifier: "%.2f")") }
                        HStack { Text("Delivery Fee"); Spacer(); Text("$2.00") }
                        HStack { Text("Tax (8%)"); Spacer(); Text("$\(appState.cartTotal * 0.08, specifier: "%.2f")") }
                        Divider()
                        HStack {
                            Text("Total").fontWeight(.bold).font(.title3)
                            Spacer()
                            Text("$\((appState.cartTotal + 2.0) * 1.08, specifier: "%.2f")")
                                .fontWeight(.bold).font(.title3).foregroundColor(.warmBrown)
                        }

                        Button {
                            appState.clearCart()
                            showOrderPlaced = true
                        } label: {
                            Text("Place Order 🎉")
                                .font(.headline).foregroundColor(.white)
                                .frame(maxWidth: .infinity).padding()
                                .background(Color.warmBrown).cornerRadius(14)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.08), radius: 8, y: -4)
                    .padding()
                }
            }
        }
        .navigationTitle("My Cart 🛒")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Order Placed! 🎉", isPresented: $showOrderPlaced) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your order has been placed. It will be ready in 20-30 minutes. Thank you for choosing Sweet Crumbs!")
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - AboutView
// ─────────────────────────────────────────────

struct AboutView: View {
    var body: some View {
        ZStack {
            Color.softCream.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 24) {

                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                colors: [Color.warmBrown, Color(red: 0.75, green: 0.45, blue: 0.20)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ))
                        VStack(spacing: 8) {
                            Text("🥖🧁🍰").font(.system(size: 50))
                            Text("Sweet Crumbs Bakery").font(.title2).fontWeight(.bold).foregroundColor(.white)
                            Text("Est. 2010").foregroundColor(.white.opacity(0.8))
                        }
                        .padding(30)
                    }
                    .padding(.horizontal)

                    InfoCard(title: "Our Story", icon: "book.closed") {
                        Text("Sweet Crumbs began in 2010 as a small family kitchen experiment. What started with Grandma Rosa's secret butter croissant recipe quickly grew into a beloved neighbourhood bakery. Today we serve over 500 happy customers daily, all from scratch, every single morning.")
                            .foregroundColor(.secondary).lineSpacing(4)
                    }

                    InfoCard(title: "Our Values", icon: "heart") {
                        VStack(alignment: .leading, spacing: 10) {
                            ValueRow(icon: "leaf",          text: "100% natural, no artificial additives")
                            ValueRow(icon: "clock",         text: "Fresh baked every morning by 6 AM")
                            ValueRow(icon: "hand.thumbsup", text: "Community-first — locally sourced ingredients")
                            ValueRow(icon: "sparkles",      text: "Handcrafted with love in every batch")
                        }
                    }

                    InfoCard(title: "Opening Hours", icon: "clock.fill") {
                        VStack(spacing: 8) {
                            HoursRow(day: "Monday – Friday", hours: "6:00 AM – 8:00 PM")
                            HoursRow(day: "Saturday",        hours: "7:00 AM – 9:00 PM")
                            HoursRow(day: "Sunday",          hours: "8:00 AM – 6:00 PM")
                        }
                    }

                    InfoCard(title: "Contact Us", icon: "phone.fill") {
                        VStack(alignment: .leading, spacing: 10) {
                            ValueRow(icon: "map",      text: "12 Maple Street, Sweet Town, CA 90210")
                            ValueRow(icon: "phone",    text: "+1 (555) 123-4567")
                            ValueRow(icon: "envelope", text: "hello@sweetcrumbs.com")
                            ValueRow(icon: "globe",    text: "www.sweetcrumbs.com")
                        }
                    }

                    Spacer(minLength: 30)
                }
                .padding(.top)
            }
        }
        .navigationTitle("About Us")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// ─────────────────────────────────────────────
// MARK: - ProfileView
// ─────────────────────────────────────────────

struct ProfileView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Color.softCream.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 24) {

                    VStack(spacing: 12) {
                        ZStack {
                            Circle().fill(Color.warmBrown.opacity(0.15)).frame(width: 100, height: 100)
                            Text(String(appState.currentUser.prefix(1)))
                                .font(.system(size: 44, weight: .bold)).foregroundColor(.warmBrown)
                        }
                        Text(appState.currentUser).font(.title2).fontWeight(.bold).foregroundColor(.warmBrown)
                        Text("Sweet Crumbs Member").font(.subheadline).foregroundColor(.gray)
                    }
                    .padding(.top, 20)

                    HStack(spacing: 0) {
                        StatBox(value: "12",                     label: "Orders")
                        Divider().frame(height: 40)
                        StatBox(value: "\(appState.cartCount)",  label: "In Cart")
                        Divider().frame(height: 40)
                        StatBox(value: "Gold",                   label: "Tier")
                    }
                    .background(Color.white).cornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 6)
                    .padding(.horizontal)

                    VStack(spacing: 2) {
                        ProfileRow(icon: "person",              title: "Edit Profile")
                        ProfileRow(icon: "bell",                title: "Notifications")
                        ProfileRow(icon: "creditcard",          title: "Payment Methods")
                        ProfileRow(icon: "mappin.and.ellipse",  title: "Delivery Addresses")
                        ProfileRow(icon: "star",                title: "Favourites")
                        ProfileRow(icon: "questionmark.circle", title: "Help & Support")
                    }
                    .background(Color.white).cornerRadius(16)
                    .shadow(color: .black.opacity(0.06), radius: 6)
                    .padding(.horizontal)

                    Button {
                        appState.isLoggedIn = false
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out").fontWeight(.semibold)
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.white).cornerRadius(14)
                        .shadow(color: .black.opacity(0.06), radius: 6)
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 30)
                }
            }
        }
        .navigationTitle("My Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// ─────────────────────────────────────────────
// MARK: - Reusable Sub-components
// ─────────────────────────────────────────────

struct QuickActionCard: View {
    let emoji: String; let title: String; let subtitle: String; let color: Color
    var body: some View {
        HStack(spacing: 12) {
            Text(emoji).font(.system(size: 30))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline).fontWeight(.semibold).foregroundColor(.white)
                Text(subtitle).font(.caption).foregroundColor(.white.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(color)
        .cornerRadius(14)
        .shadow(color: color.opacity(0.35), radius: 6, y: 3)
    }
}

struct FeaturedItemCard: View {
    let item: BakeryItem
    var body: some View {
        VStack(spacing: 10) {
            Text(item.emoji).font(.system(size: 50))
                .frame(width: 120, height: 90).background(Color.white).cornerRadius(12)
            Text(item.name).font(.caption).fontWeight(.semibold).foregroundColor(.warmBrown)
                .multilineTextAlignment(.center).frame(maxWidth: 120)
            Text("$\(item.price, specifier: "%.2f")").font(.caption2).foregroundColor(.gray)
        }
        .frame(width: 130).padding(10).background(Color.softCream).cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.warmBrown.opacity(0.12), lineWidth: 1))
    }
}

struct MenuItemCard: View {
    let item: BakeryItem
    var body: some View {
        VStack(spacing: 10) {
            Text(item.emoji).font(.system(size: 48))
                .frame(maxWidth: .infinity).frame(height: 80).background(Color.white).cornerRadius(12)
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name).font(.subheadline).fontWeight(.semibold).foregroundColor(.warmBrown).lineLimit(1)
                Text(item.description).font(.caption2).foregroundColor(.secondary).lineLimit(2)
                Text("$\(item.price, specifier: "%.2f")").font(.subheadline).fontWeight(.bold).foregroundColor(.warmBrown)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12).background(Color.white).cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 5, y: 2)
    }
}

struct CategoryPill: View {
    let name: String
    var body: some View {
        Text(name).font(.subheadline).fontWeight(.medium)
            .padding(.horizontal, 18).padding(.vertical, 10)
            .background(Color.warmBrown).foregroundColor(.white).cornerRadius(20)
    }
}

struct InfoCard<Content: View>: View {
    let title: String; let icon: String
    @ViewBuilder let content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon).font(.headline).foregroundColor(.warmBrown)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16).background(Color.white).cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 6)
        .padding(.horizontal)
    }
}

struct ValueRow: View {
    let icon: String; let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon).foregroundColor(.warmBrown).frame(width: 20)
            Text(text).font(.subheadline).foregroundColor(.secondary)
        }
    }
}

struct HoursRow: View {
    let day: String; let hours: String
    var body: some View {
        HStack {
            Text(day).font(.subheadline).foregroundColor(.secondary)
            Spacer()
            Text(hours).font(.subheadline).fontWeight(.semibold).foregroundColor(.warmBrown)
        }
    }
}

struct StatBox: View {
    let value: String; let label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.title3).fontWeight(.bold).foregroundColor(.warmBrown)
            Text(label).font(.caption).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 12)
    }
}

struct ProfileRow: View {
    let icon: String; let title: String
    var body: some View {
        HStack {
            Image(systemName: icon).frame(width: 28).foregroundColor(.warmBrown)
            Text(title).foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.gray.opacity(0.5)).font(.caption)
        }
        .padding(.horizontal, 16).padding(.vertical, 14).background(Color.white)
    }
}

// ─────────────────────────────────────────────
// MARK: - Preview
// ─────────────────────────────────────────────

#Preview {
    ContentView()
}
