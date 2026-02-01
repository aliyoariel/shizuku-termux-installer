#!/bin/bash

# --- TERMINAL COLOR DEFINITION ---
G='\033[0;32m' # Green
LG='\033[1;32m' # Light Green
W='\033[1;37m' # White
B='\033[0;34m' # Blue
R='\033[0;31m' # Red
Y='\033[1;33m' # Yellow
NC='\033[0m'    # No Color

# --- PATH CONFIGURATION ---
AERIXY_DIR="$HOME/storage/documents/aerixy"

draw_header() {
    clear
    printf "${G}========================================================${NC}\n"
    printf "${LG}  TERMUX SHIZUKU SYSTEM INTEGRATOR ${NC}\n"
    printf "${W}  Build: 2026.1-STABLE | Dev: Aliyo Ariel ${NC}\n"
    printf "${G}========================================================${NC}\n"
}

# --- PAGE 1: PREREQUISITES ---
draw_header
printf "\n${Y}[!] SYSTEM REQUIREMENTS:${NC}\n"
printf "${W}1. Shizuku App must be installed on your device.\n"
printf "2. Shizuku service must be ${G}RUNNING${W}.\n"
printf "3. Run ${G}termux-setup-storage${W} for file access.\n"
printf "4. Environment: ${B}Termux (Android)${NC}\n\n"
read -p "[PRESS ENTER TO START INITIALIZATION]" 

# --- PAGE 2: SOURCE SELECTION ---
draw_header
printf "${Y}[?] SELECT RISH BINARY SOURCE:${NC}\n"
printf "${G}--------------------------------------------------------${NC}\n"
printf "${W}1) LOCAL   : Extract from Shizuku Internal App${NC}\n"
printf "${W}2) CLOUD   : Download latest from GitHub Repo${NC}\n"
printf "${G}--------------------------------------------------------${NC}\n"
read -p "Selection [1/2]: " source_opt

# --- PAGE 3: LOGIC & TUTORIAL ---
draw_header
if [ "$source_opt" == "1" ]; then
    printf "${B}[INFO] LOCAL EXTRACTION TUTORIAL:${NC}\n"
    printf "${W}1. Open ${LG}Shizuku App${W}.\n"
    printf "2. Select ${LG}'Use Shizuku in terminal apps'${W}.\n"
    printf "3. Tap ${LG}'Export files'${W}.\n"
    printf "4. Save 'rish' & 'rish_shizuku.dex' to folder:\n"
    printf "   ${G}Internal Storage > Documents > aerixy${NC}\n\n"
    
    mkdir -p "$AERIXY_DIR"
    printf "${Y}[*] Monitoring $AERIXY_DIR...${NC}\n"
    read -p "[PRESS ENTER ONCE FILES ARE MOVED]"
    
    if [[ ! -f "$AERIXY_DIR/rish" ]]; then
        printf "\n${R}[ERROR] Binary not found in Documents/aerixy/${NC}\n"
        exit 1
    fi
    cp "$AERIXY_DIR/rish"* . && rm -f "$AERIXY_DIR/rish"* 2>/dev/null
elif [ "$source_opt" == "2" ]; then
    printf "${B}[*] Fetching binaries from remote server...${NC}\n"
    curl -L https://raw.githubusercontent.com/RikkaApps/Shizuku/master/scripts/rish -o rish
    curl -L https://github.com/RikkaApps/Shizuku/raw/master/project/shizuku-api/src/main/resources/rish_shizuku.dex -o rish_shizuku.dex
    mkdir -p "$AERIXY_DIR"
    printf "${G}[OK] Download complete.${NC}\n"
    sleep 1
else
    exit 1
fi

# --- PAGE 4: SYSTEM INJECTION ---
draw_header
printf "${LG}[⚡] INJECTING BINARIES TO SYSTEM...${NC}\n"

# Deployment to $PREFIX/bin
mv rish "$PREFIX/bin/rish"
mv rish_shizuku.dex "$PREFIX/bin/rish_shizuku.dex"
chmod +x "$PREFIX/bin/rish"

# Hard-patching rish script
# Removing BASEDIR and pointing DEX to absolute path
sed -i '/BASEDIR=/d' "$PREFIX/bin/rish"
sed -i "s|DEX=.*|DEX=\"$PREFIX/bin/rish_shizuku.dex\"|g" "$PREFIX/bin/rish"

printf "${W}Applying permissions... ${G}[DONE]${NC}\n"
printf "${W}Patching DEX variables... ${G}[DONE]${NC}\n"

# Termux Style Loading
printf "${G}Progress: ["
for i in {1..25}; do printf "#"; sleep 0.02; done
printf "] 100%%${NC}\n"

# --- PAGE 5: FINAL REPORT ---
draw_header
printf "${G}│${NC}   ${LG}SUCCESS: SHIZUKU INTEGRATED${NC}                      ${G}│${NC}\n"
printf "${G}│${NC}   ${W}Environment: $PREFIX/bin${NC}            ${G}│${NC}\n"
printf "${G}│${NC}   ${W}Command: ${Y}rish${NC}                                 ${G}│${NC}\n"
printf "${G}│${NC}   ${W}Variable Patching: Optimized (DEX path absolute)${NC}  ${G}│${NC}\n"
printf "${G}========================================================${NC}\n"

rm -f "rish"* 2>/dev/null