import AppFoundation
import CryptoKit

@MainActor
let modelContainer: ModelContainer = {
   do {
      let container = try ModelContainer(for: Profile.self)

      // seed profiles if needed
      var profileFetchDescriptor = FetchDescriptor<Profile>()
      profileFetchDescriptor.fetchLimit = 1
      if try container.mainContext.fetch(profileFetchDescriptor).count == 0 {
         container.mainContext.insert(Profile(name: "Sample", symbolName: "person", firstName: "Jane", lastName: "Smith", email: "jane@smith.com"))
      }

      try container.mainContext.save()
      return container
   } catch {
      fatalError("Failed to seed database with error: \(error.localizedDescription)")
   }
}()

@main
struct ContabankApp: App {
   let container = modelContainer
   var body: some Scene {
      WindowGroup {
         MyDataTabContentView()
      }
      .modelContainer(container)
   }
}
