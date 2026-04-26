
filepath="$HELIX_PATH"

if [ -z "$filepath" ]; then
  echo "Error: HELIX_PATH is not set. Are you running this script from within Helix?"
  exit 1
fi

# Extract the filename and the extension 
filename=$(basename -- "$filepath")
extension="${filename##*.}"




echo "--- Running smart script for: $filename ---"


# Use a 'case' statement to decide what to do based on the extension
case "$extension" in
  fnl)
    SINGLE_LINE_PREFIX=";;"
    MULTI_LINE_PREFIX=";;"
    DELIMITER="~"
    ;;
  sh)
    SINGLE_LINE_PREFIX="#"
    MULTI_LINE_PREFIX="#"
    DELIMITER="~"
    ;;
  *)
    SINGLE_LINE_PREFIX="//"
    MULTI_LINE_PREFIX="/* */"
    DELIMITER="~"
    ;;
esac

echo "--- Script finished ---"
