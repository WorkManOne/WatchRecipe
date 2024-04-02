import SwiftUI

struct RecipeView: View {
    
    @ObservedObject var recipes: Recipes
    var indice:Int
    
    var body: some View {
        NavigationView {
            Form {
                Section (header: Text("Ингридиенты")){
                    ForEach (0..<recipes.items[indice].ingredFirst.count, id: \.self) { ingr in
                        Text("\(recipes.items[indice].ingredFirst[ingr]): \(recipes.items[indice].ingredSecond[ingr]) г")
                    }.onDelete(perform: removeIngred)
                        .onMove(perform: moveIngred)
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
                        }.onDelete(perform: removeStep)
                            .onMove(perform: moveStep)
                        
                    }
                }
            }
            .navigationTitle(recipes.items[indice].name)
            .navigationBarItems(trailing: EditButton())
        }
    }
    func removeStep(as offsets:IndexSet) {
        recipes.items[indice].steps.remove(atOffsets: offsets)
    }
    func removeIngred(as offsets:IndexSet) {
        recipes.items[indice].ingredFirst.remove(atOffsets: offsets)
        recipes.items[indice].ingredSecond.remove(atOffsets: offsets)
    }
    func moveStep(from source: IndexSet, to destination:Int ){
        recipes.items[indice].steps.move(fromOffsets: source, toOffset: destination)
    }
    func moveIngred(from source: IndexSet, to destination:Int ){
        recipes.items[indice].ingredFirst.move(fromOffsets: source, toOffset: destination)
        recipes.items[indice].ingredSecond.move(fromOffsets: source, toOffset: destination)
    }
}

struct RecipeView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let r:Recipes = Recipes()
        r.items.append(Recipe(name: "Nigga", steps: ["asd","asfasf"], ingredFirst: ["perez", "sol"], ingredSecond: [124, 12]))
        return RecipeView(recipes: r, indice: 0 )
    }
}
