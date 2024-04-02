import UIKit

class ViewModel: ObservableObject {
    private(set) var connectivityProvider : ConProvider
    
    init(connectivityProvider: ConProvider) {
        self.connectivityProvider = connectivityProvider
        self.connectivityProvider.connect()
    }
}
