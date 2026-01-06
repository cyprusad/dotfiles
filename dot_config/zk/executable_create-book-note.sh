#!/bin/bash

# Script to create book notes with fuzzy book selection
# Usage: ./create-book-note.sh

# Find the notebook root (parent directory of .zk)
notebook_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$notebook_root"

# Get list of bibliography files (without .md extension)
book_list=$(ls bibliography/ | grep -v README.md | sed 's/\.md$//')

# Use fzf to select a book
selected_book=$(echo "$book_list" | fzf --prompt="Select book for new note: ")

if [ -n "$selected_book" ]; then
    echo "Selected book: $selected_book"
    echo "Creating new book note..."
    # Create the note with template applied
    note_path=$(zk new book-notes --extra book="$selected_book" --print-path 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$note_path" ]; then
        echo "Book note created: $note_path"
        echo "Opening in your editor..."
        # Try to open in editor, but don't fail if it doesn't work
        ${EDITOR:-nvim} "$note_path" 2>/dev/null || echo "Please open $note_path in your editor manually"
    else
        echo "Failed to create book note"
    fi
else
    echo "No book selected."
fi