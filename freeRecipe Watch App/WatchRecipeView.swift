import SwiftUI

struct WatchRecipeView: View {
    
    @ObservedObject var recipes: Recipes
    var indice:Int
    
    var body: some View {
        NavigationView {
            Form {
                Section (header: Text("Ингридиенты")){
                    ForEach (0..<recipes.items[indice].ingredFirst.count, id: \.self) { ingr in
                        Text("\(recipes.items[indice].ingredFirst[ingr]): \(recipes.items[indice].ingredSecond[ingr]) г")
                    }
                }
                Section (header: Text("Шаги")) {
                    List {
                        ForEach (0..<recipes.items[indice].steps.count, id: \.self) { step in
                            VStack {
                                Text("Шаг: \(step+1)")
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                Text(recipes.items[indice].steps[step])
                            }
                        }
                        
                    }
                }
            }
            .navigationTitle(recipes.items[indice].name)
        }
    }
}

struct WatchRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        let r:Recipes = Recipes()
        r.items.append(Recipe(name: "Nigga", steps: ["asd","asfasf"], ingredFirst: ["perez", "sol"], ingredSecond: [124, 12]))
        return WatchRecipeView(recipes: r, indice: 0 )
    }
}
