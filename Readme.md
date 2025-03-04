#  🚀 GoForge   
### Fast, production-ready Go Project starter 


## ✨ Features

- 📦 **Cross-Platform** - Works on **Windows, macOS, and Linux**
- ⚡ **Fast Setup** - One-command installation and execution
- 🏗️ **Go Modules** - Uses `go mod` for dependency management
- 📂 **Auto-Generated Project** - Creates `main.go`, `go.mod`, and more
- 🌍 **Environment Variable Support** - Reads from `.env` if available
- 🐳 **Docker Support** - Optional containerized execution

---

## 📥 Installation & Setup

### 🔧 **Prerequisites**
Ensure you have the following installed:
- [Go 1.21+](https://go.dev/dl/)
- [Git](https://git-scm.com/downloads)
- [Docker (Optional)](https://www.docker.com/get-started)

### 🚀 **Quick Start**
Run the setup script to initialize your project:

```sh
chmod +x setup.sh  # Give execute permission (Linux/macOS)
./setup.sh         # Run the script
```
For **Windows (Git Bash)**, use:
```sh
bash setup.sh
```

## 📁 Project Structure

```md
GoForge/  
│── main.go           # Entry point of the application  
│── go.mod            # Go module dependencies  
│── .env              # Environment variables (if applicable)  
│── Dockerfile        # Docker containerization (Optional)  
│── setup.sh          # Automated project setup script  
└── README.md         # Documentation  
```

## 📜 Running the Project
### 🏃 **Run Locally**
```sh
go run main.go
```
or build and execute:
```sh
go build -o app main.go
./app
```

### 🐳 **Run with Docker**
```sh
docker build -t GoForge .
docker run -p 8080:8080 GoForge
```
Sure! Here’s a **shorter** version of the steps to create your own Go module:  

---

## **📦 Creating Your Own Go Module**  

**Create a package**  
```sh
./forge-module.sh
```

---

## 🌍 Environment Variables
If a `.env` file exists, it will be loaded automatically.

Example `.env`:
```
PORT=8080
APP_ENV=production
```
---

## 📡 API Endpoints
| Method | Endpoint  | Description  |
|--------|----------|--------------|
| GET    | `/`      | Returns "Hello, Go App!" |

---

## 🛠️ Customization
Modify `main.go` to fit your application needs. You can add **routes, database connections, logging, and more!**

---