//
//  NewRecipeView.swift
//  NewRecipeView
//
//  Created by Dennis Beatty on 8/10/21.
//

import SwiftUI

struct NewRecipeView: View {
    @ObservedObject var vm: NewRecipeViewModel
    
    init(category: Category, delegate: NewRecipeViewModelDelegate) {
        vm = NewRecipeViewModel(category: category, delegate: delegate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("New Recipe")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal, 20)
                .padding(.top, 32)
                .padding(.bottom, 16)
            
            ScrollView() {
                VStack(alignment: .leading, spacing: 6) {
                    Group {
                        Text("Name")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        TextField("Name", text: $vm.name)
                            .autocapitalization(.words)
                            .padding(12)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                        
                        Text("Category")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.top, 12)
                        
                        Button {
                            withAnimation {
                                vm.showCategoryPicker.toggle()
                            }
                        } label: {
                            ZStack(alignment: .trailing) {
                                Text(vm.category.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(12)
                                    .accentColor(.black)
                                    .font(.body)
                                    .frame(height: 50)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(8)
                                
                                Image(systemName: "chevron.down")
                                    .rotationEffect(.degrees(vm.showCategoryPicker ? 180 : 0))
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                                    .frame(width: 44, height: 44)
                            }
                        }
                        
                        if vm.showCategoryPicker {
                            Picker(selection: $vm.selectedCategorySlug, label: Text("Category").frame(maxWidth: .infinity), content: {
                                ForEach(vm.categories) { category in
                                    Text(category.name)
                                }
                            })
                            .pickerStyle(.wheel)
                            .onTapGesture {
                                withAnimation {
                                    vm.showCategoryPicker = false
                                }
                            }
                        }
                        
                        Text("Author")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.top, 12)
                        
                        TextField("Author", text: $vm.author)
                            .autocapitalization(.words)
                            .padding(12)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    ZStack(alignment: .trailing) {
                        Text("Ingredients")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            vm.addIngredient()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .offset(x: 10)
                        }
                    }
                    
                    LazyVStack {
                        ForEach($vm.ingredients, id: \.self) { ingredient in
                            SingleAxisGeometryReader { width in
                                HStack {
                                    TextField("Amount", text: ingredient.amount)
                                        .autocapitalization(.none)
                                        .padding(12)
                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(8)
                                        .frame(width: width * 0.3)
                                    
                                    TextField("Name", text: ingredient.name)
                                        .autocapitalization(.none)
                                        .padding(12)
                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    ZStack(alignment: .trailing) {
                        Text("Instructions")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            vm.addInstruction()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .offset(x: 10)
                        }
                    }
                    
                    LazyVStack {
                        ForEach($vm.instructions, id: \.self) { instruction in
                            HStack {
                                TextField("Instruction", text: instruction.text)
                                    .autocapitalization(.sentences)
                                    .padding(12)
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        vm.createRecipe()
                    } label: {
                        Text("Add recipe")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(width: 260, height: 50)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .alert(item: $vm.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
}

class PreviewDelegate: NewRecipeViewModelDelegate {
    func didCreateRecipe(_ recipe: Recipe) {}
}

struct NewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecipeView(category: Category(name: "Appetizers", recipes: nil, slug: "appetizers"), delegate: PreviewDelegate())
    }
}
