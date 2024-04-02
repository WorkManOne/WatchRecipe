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
    let connect = ConProvider()
    
    @ObservedObject var recipes = Recipes()
    @State private var showAddView = false
    @State private var showUpdate = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(recipes.items.indices, id: \.self) { item in
                        NavigationLink(destination: RecipeView(recipes: recipes, indice: item)) {
                            RecipeRowView(recipe: recipes.items[item])
                        }
                    }.onDelete(perform: removeItem)
                    
                }
                
                .navigationBarTitle("Ваши рецепты")
                .navigationBarItems(trailing: Button(action: {
                    self.showAddView = true
                }){
                    Image(systemName: "plus")
                }.sheet(isPresented: $showAddView) {
                    RecipeAdd(recipes: recipes)
                })
                Button(action: {
                    viewModel.connectivityProvider.connect()
                    viewModel.connectivityProvider.initToSend(recipes: recipes)
                    self.recipes.items.removeAll()
                    for i in 0..<viewModel.connectivityProvider.info.count {
                        var safeCopy = Recipe(name: viewModel.connectivityProvider.info[i].name!, steps: viewModel.connectivityProvider.info[i].steps!, ingredFirst: viewModel.connectivityProvider.info[i].ingredFirst!, ingredSecond: viewModel.connectivityProvider.info[i].ingredSecond!)
                        self.recipes.items.append(safeCopy)
                    }
                    self.showUpdate = true
                })
                { Text("Синхронизировать с Apple Watch")
                        .padding()
                        .background(.green)
                        .foregroundColor(.white)
                        .font(.headline)
                        .clipShape(Capsule())
                }.alert(isPresented: $showUpdate) {
                    Alert(title: Text("Отправка произведена"),
                          message: Text("Откройте приложение на часах и нажмите кнопку 'Обновить', если рецепты не появятся, убедитесь что вы подключены к Apple Watch"),
                          dismissButton: .default(Text("ОК")))
                }
            }
        }.onAppear() {
            connect.connect()
        }
    }
    func removeItem(as offsets:IndexSet) {
            recipes.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
