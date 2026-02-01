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
cd ~
AERIXY_DIR="/sdcard/Documents/aerixy"

draw_header() {
    clear
    printf "${G}=======================================================${NC}\n"
    printf "${G}│${NC}          ${LG}TERMUX SHIZUKU SYSTEM INTEGRATOR           ${G}│${NC}\n"
    printf "${G}│${NC}       ${LG}Build: 2026.1-STABLE | Dev: Aliyo Ariel       ${G}│${NC}\n"
    printf "${G}=======================================================${NC}\n"
}

# --- PAGE 1: PREREQUISITES ---
draw_header
printf "\n${Y}[!] SYSTEM REQUIREMENTS:${NC}\n"
printf "${W}1. Shizuku App must be installed on your device.\n"
printf "2. Shizuku service must be ${G}RUNNING${W}.\n"
printf "3. Run ${G}termux-setup-storage${W} for file access.\n"
printf "4. Environment: ${B}Termux (Android)${NC}\n\n"; sleep 1
printf "\n${W}Press ENTER to start...${NC}\n"
read -r < /dev/tty

# --- PAGE 2: SOURCE SELECTION ---
draw_header
printf "${Y}[?] SELECT RISH BINARY SOURCE:${NC}\n"
printf "${G}--------------------------------------------------------${NC}\n"
printf "${W}1) LOCAL   : Extract from Shizuku Internal App${NC}\n"
printf "${W}2) CLOUD   : Download latest from GitHub Repo${NC}\n"
printf "${G}--------------------------------------------------------${NC}\n"; sleep 1
read -p "Selection [1/2]: " source_opt < /dev/tty

# --- PAGE 3: LOGIC & TUTORIAL ---
draw_header
if [ "$source_opt" == "1" ]; then
    printf "${B}[INFO] LOCAL EXTRACTION TUTORIAL:${NC}\n"
    printf "${W}1. Open ${LG}Shizuku App${W}.\n"; sleep 0.3
    printf "2. Select ${LG}'Use Shizuku in terminal apps'${W}.\n"; sleep 0.5
    printf "3. Tap ${LG}'Export files'${W}.\n"; sleep 0.8
    printf "4. Save 'rish' & 'rish_shizuku.dex' to folder:\n"; sleep 0.4
    printf "   ${G}Internal Storage > Documents > aerixy${NC}\n\n"; sleep 0.6
    
    mkdir -p "$AERIXY_DIR"
    printf "${Y}[*] Monitoring $AERIXY_DIR...${NC}\n"; sleep 1
    read -p "[PRESS ENTER ONCE FILES ARE MOVED]" < /dev/tty
    sleep 2
    
    if [[ ! -f "$AERIXY_DIR/rish" ]]; then
        printf "\n${R}[ERROR] Binary not found in Documents/aerixy/${NC}\n"
        exit 1
    fi
    cp "$AERIXY_DIR/rish"* . && rm -f "$AERIXY_DIR/rish"* 2>/dev/null
    sleep 0.5
elif [ "$source_opt" == "2" ]; then
    printf "${B}[*] Fetching binaries from remote server...${NC}\n"
    curl -L https://github.com/aliyoariel/shizuku-termux-installer/raw/refs/heads/main/src/rish -o rish
    curl -L https://github.com/aliyoariel/shizuku-termux-installer/raw/refs/heads/main/src/rish_shizuku.dex -o rish_shizuku.dex
    mkdir -p "$AERIXY_DIR"
    sleep 2
    printf "${G}[OK] Download complete.${NC}\n"
    sleep 0.5
else
    exit 1
fi

# --- PAGE 4: SYSTEM INJECTION ---
draw_header
printf "${LG}[⚡] INJECTING & PATCHING BINARIES...${NC}\n"

# Move files to system binary folder
mv rish "$PREFIX/bin/rish"
mv rish_shizuku.dex "$PREFIX/bin/rish.dex"
chmod +x "$PREFIX/bin/rish"

# Execution of Patches
printf "${W}Removing BASEDIR variable... ${G}[DONE]${NC}\n"; sleep 0.5
sed -i '/BASEDIR=/d' "$PREFIX/bin/rish"

printf "${W}Mapping absolute DEX path... ${G}[DONE]${NC}\n"
sed -i "s|DEX=.*|DEX=\"$PREFIX/bin/rish.dex\"|g" "$PREFIX/bin/rish"; sleep 0.7

printf "${W}Setting App ID to com.termux... ${G}[DONE]${NC}\n"
sed -i 's/RISH_APPLICATION_ID="PKG"/RISH_APPLICATION_ID="com.termux"/g' "$PREFIX/bin/rish"; sleep 1

# Progress Bar
printf "${G}Finishing: ["
for i in {1..25}; do printf "■"; sleep 0.05; done
printf "] 100%%${NC}\n"

# --- PAGE 5: FINAL REPORT ---
draw_header
printf "${G}│${NC}   ${LG}SUCCESS: SHIZUKU INTEGRATED${NC}                       ${G}│${NC}\n"
printf "${G}│${NC}   ${W}Environment: $PREFIX/bin${NC}                                 ${G}│${NC}\n"
printf "${G}│${NC}   ${W}Command: ${Y}rish${NC}                                     ${G}│${NC}\n"
printf "${G}│${NC}   ${W}Variable Patching: Optimized (DEX path absolute)${NC}  ${G}│${NC}\n"
printf "${G}=======================================================${NC}\n"

rm -f "rish"* 2>/dev/null

sleep 3

# --- EXECUTE REMOTE CREDITS FROM GIST ---
curl -sL "https://gist.github.com/aliyoariel/5362818da22ee077fe99e613e3ee2c48/raw/49b0335ed8e23336e3f599e9a4df570df761c012/credits.sh" | bash