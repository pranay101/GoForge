#!/bin/bash

# List directories in the current folder
echo "📂 Available directories:"
select DIR in */ "Current (.)"; do
    if [[ "$DIR" == "Current (.)" ]]; then
        TARGET_DIR="."
    elif [[ -n "$DIR" ]]; then
        TARGET_DIR="${DIR%/}"  # Remove trailing slash
    else
        echo "❌ Invalid selection. Try again."
        continue
    fi
    break
done

# Ensure selected directory contains a Go module
if [ ! -f "$TARGET_DIR/go.mod" ]; then
    echo "❌ No 'go.mod' file found in '$TARGET_DIR'! Make sure it's a Go module."
    exit 1
fi

# Ask user for the new package name
read -p "Enter the name of your new package: " PACKAGE_NAME

# Create package directory inside the target directory
mkdir -p "$TARGET_DIR/$PACKAGE_NAME"

# Create a sample file inside the package
cat > "$TARGET_DIR/$PACKAGE_NAME/$PACKAGE_NAME.go" <<EOL
package $PACKAGE_NAME

import "fmt"

// ExampleFunc prints a message from $PACKAGE_NAME.
func ExampleFunc() {
    fmt.Println("Hello from $PACKAGE_NAME package!")
}
EOL

# Suggest usage example in main.go
if [ -f "$TARGET_DIR/main.go" ]; then
    echo "✅ Package '$PACKAGE_NAME' created in '$TARGET_DIR'!"
    echo "🔹 To use it, add this to 'main.go':"
    echo ""
    echo "  import \"./$PACKAGE_NAME\""
    echo "  func main() {"
    echo "      $PACKAGE_NAME.ExampleFunc()"
    echo "  }"
else
    echo "✅ Package '$PACKAGE_NAME' created. Add it to your Go files as needed!"
fi
