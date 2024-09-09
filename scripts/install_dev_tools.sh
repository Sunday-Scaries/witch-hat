#!/bin/bash

# Install pre-commit if it's not already installed
if ! command -v pre-commit &> /dev/null
then
    echo "pre-commit not found, installing..."
    pip install pre-commit
else
    echo "pre-commit is already installed"
fi

# Install pre-commit hooks
echo "Installing pre-commit hooks..."
pre-commit install

echo "Pre-commit hooks installed successfully!"
