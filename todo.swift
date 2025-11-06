import Darwin

var tasks = [String]()

func showMenu() {
    print("\n1. Add Task\n2. Remove Task\n3. View Tasks\n4. Exit")
}

while true {
    showMenu()
    if let choice = readLine() {
        switch choice {
        case "1":
            print("Enter task:")
            if let task = readLine() { tasks.append(task) }
        case "2":
            print("Enter task number to remove:")
            if let indexStr = readLine(), let index = Int(indexStr), index <= tasks.count {
                tasks.remove(at: index-1)
            }
        case "3":
            for (i, t) in tasks.enumerated() {
                print("\(i+1). \(t)")
            }
        case "4":
            print("Exiting...")
            exit(0)
        default:
            print("Invalid choice.")
        }
    }
}

