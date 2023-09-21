import SwiftData

extension PersistentModel {
   var isPersisted: Bool {
      self.persistentModelID.storeIdentifier != nil
   }
}
