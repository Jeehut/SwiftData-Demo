import AppFoundation

@Model
final class Profile {
   @Attribute(.unique)
   var name: String
   var symbolName: String

   // Contact Info
   var firstName: String?
   var lastName: String?
   var email: String?

   init(name: String, symbolName: String, firstName: String? = nil, lastName: String? = nil, email: String? = nil) {
      self.name = name
      self.symbolName = symbolName
      self.firstName = firstName
      self.lastName = lastName
      self.email = email
   }
}

extension Profile: Identifiable {
   var id: String { self.name }
}
