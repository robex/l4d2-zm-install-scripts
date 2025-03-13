#!/bin/bash


# Download custom maps (uncomment if wanted, requires around 40GB disk space)
cd /home/steam/l4d2/addons/

#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Function to print error messages
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Check if the current directory ends with /left4dead2/addons
current_dir=$(pwd)
expected_dir="/l4d2/addons"

if [[ ! "$current_dir" == *"$expected_dir" ]]; then
    error_exit "Script must be run from your L4D2 \"addons\" folder. Current directory: $current_dir"
fi

# Check for required commands
for cmd in curl md5sum 7z; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        error_exit "Required command '$cmd' is not installed. Please install it and retry."
    fi
done

# URL of the CSV file
CSV_URL="https://l4d2center.com/maps/servers/index.csv"

# Temporary file to store CSV
TEMP_CSV=$(mktemp)

# Ensure temporary file is removed on exit
trap 'rm -f "$TEMP_CSV"' EXIT

echo "Downloading CSV from $CSV_URL..."
curl -sSL -o "$TEMP_CSV" "$CSV_URL" || error_exit "Failed to download CSV."

declare -A map_md5
declare -A map_links

# Read CSV and populate associative arrays
{
    # Skip the first line (header)
    IFS= read -r header

    while IFS=';' read -r Name Size MD5 DownloadLink || [[ $Name ]]; do
        # Trim whitespace
        Name=$(echo "$Name" | xargs)
        MD5=$(echo "$MD5" | xargs)
        DownloadLink=$(echo "$DownloadLink" | xargs)
        
        # Populate associative arrays
        map_md5["$Name"]="$MD5"
        map_links["$Name"]="$DownloadLink"
    done
} < "$TEMP_CSV"

# Get list of expected VPK files
expected_vpk=("${!map_md5[@]}")

# Remove VPK files not in expected list or with mismatched MD5
echo "Cleaning up existing VPK files..."
for file in *.vpk; do
    # Check if it's a regular file
    if [[ -f "$file" ]]; then
        if [[ -z "${map_md5["$file"]}" ]]; then
            echo "Removing unexpected file: $file"
            rm -f "$file"
        else
            # Calculate MD5
            echo "Calculating MD5 for existing file: $file..."
            current_md5=$(md5sum "$file" | awk '{print $1}')
            expected_md5="${map_md5["$file"]}"
            
            if [[ "$current_md5" != "$expected_md5" ]]; then
                echo "MD5 mismatch for $file. Removing."
                rm -f "$file"
            fi
        fi
    fi
done

# Download and extract missing or updated VPK files
echo "Processing required VPK files..."
for vpk in "${expected_vpk[@]}"; do
    if [[ ! -f "$vpk" ]]; then
        echo "Downloading and extracting $vpk..."
        download_url="${map_links["$vpk"]}"
        
        if [[ -z "$download_url" ]]; then
            echo "No download link found for $vpk. Skipping."
            continue
        fi

        encoded_url=$(echo "$download_url" | sed 's/ /%20/g')
        
        # Download the .7z file to a temporary location
        TEMP_7Z=$(mktemp --suffix=.7z)
        curl -# -L -o "$TEMP_7Z" "$encoded_url"
        
        # Check if the download was successful
        if [[ $? -ne 0 ]]; then
            echo "Failed to download $download_url. Skipping."
            rm -f "$TEMP_7Z"
            continue
        fi
        
        # Extract the .7z file
        7z x -y "$TEMP_7Z" || { echo "Failed to extract $TEMP_7Z. Skipping."; rm -f "$TEMP_7Z"; continue; }
        
        # Remove the temporary .7z file
        rm -f "$TEMP_7Z"
        
    else
        echo "$vpk is already up to date."
    fi
done

echo "Synchronization complete."
