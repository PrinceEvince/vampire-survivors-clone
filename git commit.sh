git add .
echo "Enter commit message:"
read message
git commit -m "$message"
echo ""
read -p "Done! Press enter to close"