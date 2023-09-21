import AppFoundation

struct MyDataTabContentView: View {
   @Environment(\.modelContext)
   var modelContext

   @Query
   var profiles: [Profile]

   @State
   var selectedProfile: Profile?

   @State
   var showNewProfile: Bool = false

   var body: some View {
      NavigationStack {
         Form {
            Section {
               Picker("Profile to share", selection: self.$selectedProfile) {
                  ForEach(self.profiles) { profile in
                     Label(profile.name, systemImage: profile.symbolName).tag(profile as Profile?)
                  }
               }

               Button {
                  #warning("🧑‍💻 not yet implemented")
               } label: {
                  Label("Connect with another person", systemImage: "person.line.dotted.person")
                     .frame(maxWidth: .infinity, alignment: .center)
               }
               .font(.headline)
            } header: {
               Text("Connecting")
            } footer: {
               Text("Connect with people you know to always have access to their latest contact information.")
            }
            .pickerStyle(.menu)

            Section {
               ForEach(self.profiles) { profile in
                  NavigationLink(value: profile, label: { Label(profile.name, systemImage: profile.symbolName) })
               }

               Button {
                   selectedProfile = .init(name: "", symbolName: "")
               } label: {
                  Label("New profile", systemImage: "plus")
               }
               .sheet(item:$selectedProfile) { profile in
                  NavigationStack {
                     ProfileView(profile: profile)
                        .toolbar {
                           ToolbarItem(placement: .cancellationAction) {
                              Button("Cancel") {
                                 self.showNewProfile = false
                              }
                           }
                        }
                  }
               }
            } header: {
               Text("Your profiles")
            } footer: {
               Text("Make changes to your contact information to update all your contacts that have access.")
            }
         }
         .navigationDestination(for: Profile.self) { profile in
            ProfileView(profile: profile)
         }
         .navigationTitle("My Data")
      }
   }
}

#if DEBUG
#Preview {
   TabView {
      MyDataTabContentView()
         .tabItem { Label("My Data", systemImage: "person.crop.circle.fill") }
   }
}
#endif
