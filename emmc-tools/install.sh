#!/bin/bash
set -eu
ROOTFS_DIR=$1
CURRPATH=$PWD

APK_BIN=$TOP_DIR/friendlywrt/staging_dir/host/bin/apk
OPKG_BIN=$TOP_DIR/friendlywrt/staging_dir/host/bin/opkg

install_emmc_tools_pkg() {
    local pkg_base=$1
    if [ -f "$APK_BIN" ]; then
        # Build an offline rootfs; target hooks must not run on the host.
        "$APK_BIN" --root "$ROOTFS_DIR" add --no-network --no-scripts --force-overwrite \
            --allow-untrusted "./${pkg_base}.apk"
    elif [ -f "$OPKG_BIN" ]; then
        "$OPKG_BIN" --force-overwrite --offline-root "$ROOTFS_DIR" install \
            "./${pkg_base}.ipk"
    else
        echo "ERROR: neither apk nor opkg found" >&2
        exit 1
    fi
}

install_emmc_tools_pkg luci-app-emmc-tools
install_emmc_tools_pkg luci-i18n-emmc-tools-zh-cn
