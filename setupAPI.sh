#!/bin/bash

# Function to print warning messages in red
print_warning() {
    echo -e "\033[1;31mWARNING: $1\033[0m"
}

# Function to check if venv is installed and install if not
check_and_install_venv() {
    if ! command -v python3 >/dev/null 2>&1; then
        print_warning "Python 3 is not installed. Please install Python 3 from https://www.python.org/downloads/"
        exit 1
    fi

    if ! command -v python3 -m venv >/dev/null 2>&1; then
        echo "Installing virtualenv..."
        python3 -m pip install virtualenv
    fi
}

# Function to create virtual environment
create_virtualenv() {
    echo "Creating virtual environment..."
    python3 -m venv venv
    source venv/bin/activate
}

# Function to install FastAPI and related dependencies
install_fastapi() {
    echo "Installing FastAPI and related dependencies..."
    if [[ "$1" == "complete" ]]; then
        python3 -m pip install "fastapi[all]"
    else
        python3 -m pip install fastapi uvicorn
    fi
}

# Function to install database related dependencies
install_db_dependencies() {
    read -p "Do you prefer NoSQL or SQL for your project? [NoSQL/SQL]: " db_choice
    case "$db_choice" in
    [Nn]*)
        python3 -m pip install motor
        ;;
    [Ss]*)
        python3 -m pip install sqlalchemy
        ;;
    *)
        echo "Invalid choice. No database dependencies will be installed."
        ;;
    esac
}

# Function to create directory structure
create_directory_structure() {
    mkdir api
    touch api/__init__.py
}

# Function to create main.py
create_main_py() {
    echo "from fastapi import FastAPI

app = FastAPI()

@app.get('/')
async def read_root():
    return {'message': 'Welcome to FastAPI, created by bash script'}" >main.py
}

# Function to create .gitignore file
create_gitignore() {
    echo "__pycache__/
venv/
*.env
*.pyc" >.gitignore
}

# Function to create requirements.txt
create_requirements_txt() {
    python3 -m pip freeze >requirements.txt
}

# Function to print completion message
print_completion_message() {
    echo "Project setup completed successfully!"
    echo "Consider using RUFF as a linter in Visual Studio Code."
}

# Function to open Visual Studio Code
open_vscode() {
    read -p "Do you want to start coding now? [y/n]: " start_coding
    case "$start_coding" in
    [Yy]*)
        code .
        ;;
    *)
        echo "Thank you! Happy coding!"
        ;;
    esac
}

# Main function
main() {
    read -p "Enter the name of your project: " project_name
    mkdir "$project_name"
    cd "$project_name" || exit

    # Check Python version
    python_version=$(python3 --version | awk '{print $2}')
    echo "Python version: $python_version"

    check_and_install_venv
    create_virtualenv

    read -p "Do you want a complete installation of FastAPI? [y/n]: " fastapi_choice
    if [[ "$fastapi_choice" == [Yy]* ]]; then
        install_fastapi "complete"
    else
        install_fastapi "basic"
    fi

    install_db_dependencies
    create_directory_structure
    create_main_py
    create_gitignore
    create_requirements_txt
    print_completion_message
    open_vscode
}

# Execute main function
main
