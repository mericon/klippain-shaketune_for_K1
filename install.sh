#!/bin/sh

USER_CONFIG_PATH="/usr/data/printer_data/config"
KLIPPER_PATH="/usr/share/klipper"
K_SHAKETUNE_PATH="/usr/data/klippain_shaketune"

set -eu
export LC_ALL=C


function preflight_checks {
    if [ -d "${HOME}/klippain_config" ]; then
        if [ -f "${USER_CONFIG_PATH}/.VERSION" ]; then
            echo "[ERROR] Klippain full installation found! Nothing is needed in order to use the K-Shake&Tune module!"
            exit -1
        fi
    fi
}

function check_download {
    local shaketunedirname shaketunebasename
    shaketunedirname="$(dirname ${K_SHAKETUNE_PATH})"
    shaketunebasename="$(basename ${K_SHAKETUNE_PATH})"

    if [ ! -d "${K_SHAKETUNE_PATH}" ]; then
        echo "[DOWNLOAD] Downloading Klippain Shake&Tune module repository..."
        if git -C $shaketunedirname clone https://github.com/mericon/klippain-shaketune_for_K1.git $shaketunebasename; then
            chmod +x ${K_SHAKETUNE_PATH}/install.sh
            printf "[DOWNLOAD] Download complete!\n\n"
        else
            echo "[ERROR] Download of Klippain Shake&Tune module git repository failed!"
            exit -1
        fi
    else
        printf "[DOWNLOAD] Klippain Shake&Tune module repository already found locally. Continuing...\n\n"
    fi
}

function link_extension {
    echo "[INSTALL] Linking scripts to your config directory..."
    chmod +x ${K_SHAKETUNE_PATH}/K-ShakeTune ${USER_CONFIG_PATH}/K-ShakeTune/scripts
    ln -fsn ${K_SHAKETUNE_PATH}/K-ShakeTune ${USER_CONFIG_PATH}/K-ShakeTune
}

function link_gcodeshellcommandpy {
    if [ ! -f "${KLIPPER_PATH}/klippy/extras/gcode_shell_command.py" ]; then
        echo "[INSTALL] Downloading gcode_shell_command.py Klipper extension needed for this module"
        wget -P ${KLIPPER_PATH}/klippy/extras https://raw.githubusercontent.com/Frix-x/klippain/main/scripts/gcode_shell_command.py
    else
        printf "[INSTALL] gcode_shell_command.py Klipper extension is already installed. Continuing...\n\n"
    fi
}

function restart_klipper {
    echo "[POST-INSTALL] Please do an reboot"
}


printf "\n=============================================\n"
echo "- Klippain Shake&Tune module install script -"
printf "=============================================\n\n"


# Run steps
preflight_checks
check_download
link_extension
link_gcodeshellcommandpy
restart_klipper
