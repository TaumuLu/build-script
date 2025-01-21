#!/bin/bash

set -e

CF_API_URL="https://api.cloudflare.com/client/v4"

# Function to show usage
show_usage() {
    echo "Usage: $0 {purge|warm} -t <api-token> -z <zone-id> [urls...]"
    echo "Options:"
    echo "  -t  Cloudflare API Token"
    echo "  -z  Cloudflare Zone ID"
    echo "Commands:"
    echo "  purge - Purge all Cloudflare cache"
    echo "  warm <urls> - Warm up cache for specified URLs"
    exit 1
}

# Check if command is provided
if [ $# -lt 1 ]; then
    show_usage
fi

# Store the command
COMMAND=$1
shift

# Parse options
while getopts ":t:z:" opt; do
    case ${opt} in
        t) CF_API_TOKEN=$OPTARG ;;
        z) CF_ZONE_ID=$OPTARG ;;
        \?) echo "Invalid option: -$OPTARG"; show_usage ;;
        :) echo "Option -$OPTARG requires an argument"; show_usage ;;
    esac
done
shift $((OPTIND -1))

# Check if required parameters are provided
if [ -z "$CF_API_TOKEN" ] || [ -z "$CF_ZONE_ID" ]; then
    echo "Error: API Token and Zone ID are required"
    show_usage
fi

# Function to purge cache
purge_cache() {
    echo "Purging Cloudflare cache..."
    curl -X POST "${CF_API_URL}/zones/${CF_ZONE_ID}/purge_cache" \
        -H "Authorization: Bearer ${CF_API_TOKEN}" \
        -H "Content-Type: application/json" \
        --data '{"purge_everything":true}'
    echo -e "\nCache purge completed!"
}

# Function to warm up cache
warm_cache() {
    if [ $# -eq 0 ]; then
        echo "Error: Please provide at least one URL to warm up"
        show_usage
    fi

    echo "URLs to warm up:"
    echo "------------------------"
    printf '%s\n' "$@"
    echo "------------------------"
    echo "Total URLs: $#"
    echo ""

    for url in "$@"; do
        echo "Warming up: $url"
        curl -s -o /dev/null -H "User-Agent: Cloudflare-Warmer" "$url"
    done
    echo "Cache warm-up completed!"
}

# Main script
case "$COMMAND" in
    "purge")
        purge_cache
        ;;
    "warm")
        if [ $# -eq 0 ]; then
            echo "Error: Please provide URLs to warm up"
            show_usage
        fi
        warm_cache "$@"
        ;;
    *)
        show_usage
        ;;
esac
