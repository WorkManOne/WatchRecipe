import SwiftUI

struct RecipeAdd: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var recipes: Recipes
    @State private var name = ""
    @State private var ingredFirst:[String] = []
    @State private var ingredSecond:[String] = []
    @State private var steps:[String] = []
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Название", text: $name)
                Section (header: Text("Ингридиенты")) {
                    ForEach(0..<ingredFirst.count, id: \.self) { ingredient in
                        VStack {
                            HStack {
                                TextField("Ингридиент", text: $ingredFirst[ingredient])
                                Text(":")
                                TextField("Грамм", text: $ingredSecond[ingredient])
                                    .keyboardType(.numberPad)
                            }
                        }
                    }
                    Button(action: {
                        ingredFirst.append("")
                        ingredSecond.append("")
                    }) {
                        Image(systemName: "plus")
                    }
                }
                Section (header: Text("Шаги")) {
                    ForEach(0..<steps.count, id: \.self) { step in
                        VStack {
                            HStack {
                                Text("Шаг \(step+1)")
                            }
                            HStack {
                                TextField("Описание шага", text: $steps[step])
                            }
                        }
                    }
                    Button(action: {
                        steps.append("")
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationBarTitle("Добавить")
            .navigationBarItems(trailing: Button(action: {
                var safeIngredSecond:[Int] = []
                for i in 0..<ingredSecond.count {
                    safeIngredSecond.append(Int(ingredSecond[i]) ?? 0)
                }
                let item = Recipe(name: self.name, steps: self.steps, ingredFirst: self.ingredFirst, ingredSecond: safeIngredSecond)
                self.recipes.items.append(item)
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Сохранить")
            })
        }
    }
    
}


struct RecipeAdd_Previews: PreviewProvider {
    static var previews: some View {
        RecipeAdd(recipes: Recipes())
    }
}
