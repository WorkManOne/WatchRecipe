import SwiftUI

struct Recipe : Identifiable, Codable {
    var id = UUID()
    var name:String
    var steps:[String]
    var ingredFirst:[String]
    var ingredSecond:[Int]
}

class Recipes : ObservableObject {
    @Published var items = [Recipe]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Recipe].self, from: items) {
                self.items = decoded
                return
            }
        }
    }
}

struct RecipeRowView : View {
    var recipe: Recipe
    
    var body: some View {
        Text(recipe.name)
    }
}

struct ContentView: View {
    let viewModel = ViewModel(connectivityProvider: ConProvider())
    @State private var showUpdate = false
    @ObservedObject var recipes = Recipes()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(recipes.items.indices, id: \.self) { item in
                        NavigationLink(destination: WatchRecipeView(recipes: recipes, indice: item)) {
                            RecipeRowView(recipe: recipes.items[item])
                        }
                    }
                    
                }
                
                .navigationBarTitle("Ваши рецепты")
                Button(action: {
                    self.showUpdate = true
                }) {
                    Text("Обновить")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 3)
                        .foregroundColor(.white)
                        .font(.headline)
                        .background(.green)
                        .clipShape(Capsule())
                }.alert(isPresented: $showUpdate) {
                    Alert(title: Text("Обновить?"),
                          message: Text("Вы уверены что хотите обновить данные? Убедитесь что вы отправили их с iPhone и подключены к нему"),
                          primaryButton: .default(Text("Да")) {
                        viewModel.connectivityProvider.connect()
                        self.recipes.items.removeAll()
                        for i in 0..<viewModel.connectivityProvider.recievedInfo.count {
                            var safeCopy = Recipe(name: viewModel.connectivityProvider.recievedInfo[i].name!, steps: viewModel.connectivityProvider.recievedInfo[i].steps!, ingredFirst: viewModel.connectivityProvider.recievedInfo[i].ingredFirst!, ingredSecond: viewModel.connectivityProvider.recievedInfo[i].ingredSecond!)
                            self.recipes.items.append(safeCopy)
                        }
                    },
                          secondaryButton: .cancel(Text("Отмена"))
                    )
                }
                
            }
        }.onAppear() {
            //Insert on appear
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
