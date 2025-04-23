#!/data/data/com.termux/files/usr/bin/bash

# Color codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color

clear
echo -e "${CYAN}==============================="
echo -e "   ${YELLOW}YouTube Video Downloader by Yusuf Khan"
echo -e "${CYAN}===============================${NC}"
echo ""

# Storage permission enable karo (pehli baar)
termux-setup-storage

# Download folder ka path set karo
DOWNLOAD_DIR="/storage/emulated/0/Download"

echo -ne "${BLUE}YouTube URL daalein: ${NC}"
read url

echo ""
echo -e "${YELLOW}Download format chunein:${NC}"
echo -e "${GREEN}1.${NC} Video (MP4)"
echo -e "${GREEN}2.${NC} Audio (MP3)"
echo -ne "${BLUE}Option (1 ya 2): ${NC}"
read option

echo ""
echo -e "${CYAN}Download taiyaar ho raha hai...${NC}"

# Loading animation
spin() {
    spinner="/|\\-/|\\-"
    while :; do
        for i in $(seq 0 7); do
            echo -ne "\r${YELLOW}Please wait... ${spinner:$i:1}${NC}"
            sleep 0.1
        done
    done
}

spin &
SPIN_PID=$!
sleep 2
kill $SPIN_PID &>/dev/null
wait $SPIN_PID 2>/dev/null

echo ""
echo -e "${CYAN}Downloading shuru ho raha hai...${NC}"
echo ""

if [ "$option" == "1" ]; then
    yt-dlp --newline -P "$DOWNLOAD_DIR" "$url"
elif [ "$option" == "2" ]; then
    yt-dlp --newline -x --audio-format mp3 -P "$DOWNLOAD_DIR" "$url"
else
    echo -e "${RED}Galat option chuna gaya. Kripya 1 ya 2 chunein.${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Download Complete!${NC} ${YELLOW}Check your Download folder.${NC}"
