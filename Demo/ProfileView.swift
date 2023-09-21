import AppFoundation

struct ProfileView: View {
   enum Field: Hashable {
      case profileName
      case firstName
      case lastName
      case email
   }

   let profile: Profile

   @Environment(\.dismiss)
   var dismiss

   @Environment(\.modelContext)
   var modelContext

   // TODO: add more symbols
   let selectableSymbolNames: [String] = ["person", "building.2"]

   @State
   var name: String = ""

   @State
   var symbolName: String = ""

   // Contact Info
   @State
   var firstName: String = ""

   @State
   var lastName: String = ""

   @State
   var email: String = ""

   @FocusState
   var focusedField: Field?

   init(profile: Profile) {
      self.profile = profile
      self.name = profile.name
      self.symbolName = profile.symbolName

      if let firstName = profile.firstName { self.firstName = firstName }
      if let lastName = profile.lastName { self.lastName = lastName }
      if let email = profile.email { self.email = email }
   }

   var body: some View {
      Form {
         Section("Profile") {
            LabeledContent("Name") {
               TextField("e.g. Work", text: self.$name)
                  .foregroundStyle(Color.accentColor)
                  .focused(self.$focusedField, equals: .profileName)
            }
            .labeledContentStyle(.vertical())

            #warning("🧑‍💻 implement a collection view instead? or add the name of the symbol? maybe a searchable sheet?")
            Picker(selection: self.$symbolName) {
               ForEach(self.selectableSymbolNames, id: \.self) { symbolName in
                  Image(systemName: symbolName)
               }
            } label: {
               Text("Symbol")
            }
            .labeledContentStyle(.automatic)
         }

         Section("Name") {
            LabeledContent("First name") {
               TextField("e.g. Jane", text: self.$firstName)
                  .foregroundStyle(Color.accentColor)
                  .textContentType(.givenName)
                  .focused(self.$focusedField, equals: .firstName)
                  .submitLabel(.next)
                  .onSubmit {
                     self.focusedField = .lastName
                  }
            }
            .labeledContentStyle(.vertical())

            LabeledContent("Last name") {
               TextField("e.g. Roe", text: self.$lastName)
                  .foregroundStyle(Color.accentColor)
                  .textContentType(.familyName)
                  .focused(self.$focusedField, equals: .lastName)
            }
            .labeledContentStyle(.vertical())
         }
      }
      .defaultFocus(self.$focusedField, .profileName)
      .labeledContentStyle(.vertical())
      .pickerStyle(.menu)
      .toolbar {
         ToolbarItem(placement: .primaryAction) {
            Button("Save") {
               self.profile.name = self.name
               self.profile.symbolName = self.symbolName
               self.profile.firstName = self.firstName
               self.profile.lastName = self.lastName
               self.profile.email = self.email

               do {
                  try self.modelContext.save()
               } catch {
                  Logger().error("Failed to save profile with error: \(error.localizedDescription)")
               }
               self.dismiss()
            }
         }
      }
   }
}

#Preview("Edit") {
   NavigationStack {
      Color.gray
         .navigationDestination(isPresented: .constant(true)) {
            ProfileView(profile: Profile(name: "Personal", symbolName: "person"))
         }
   }
}

#Preview("New") {
   Color.gray
      .sheet(isPresented: .constant(true)) {
         NavigationStack {
            ProfileView(profile: Profile(name: "", symbolName: ""))
               .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") {} } }
         }
      }
}
