# shellcheck shell=bash

# ANSI Escape Codes:
#
# Just so you can be pretty in your messages :)
#
# Example: Build a colorful sentence.
# => echo -e "I ${RED}love ${BLUE}chef${NC} friends!"
#
# Or use the helper methods:
# => green "Hola!"
#
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'

function yellow(){
  echo -e "${YELLOW}$1${NC}"
}

function red() {
  echo -e "${RED}$1${NC}"
}

function green() {
  echo -e "${GREEN}$1${NC}"
}

function blue() {
  echo -e "${BLUE}$1${NC}"
}
