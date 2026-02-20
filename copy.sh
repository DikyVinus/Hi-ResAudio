cat <<'EOF' > copy.sh
#!/system/bin/sh

[ -z "$MODPATH" ] && MODPATH=${0%/*}

copy_policy_file() {
  mkdir -p "$(dirname "$2")"
  cp -af "$1" "$2"
}

# canonical path = /system/vendor/*
AUD='audio_policy.conf -o -name audio_policy_configuration.xml'

# remove old copies
find "$MODPATH/system/vendor" -type f \( -name audio_policy.conf -o -name audio_policy_configuration.xml \) -delete 2>/dev/null

# copy from real vendor → module mirror
find /vendor -type f \( -name audio_policy.conf -o -name audio_policy_configuration.xml \) | while read -r FILE; do
  MODFILE="$MODPATH/system$FILE"
  copy_policy_file "$FILE" "$MODFILE"
done


copy_param_file() {
  mkdir -p "$(dirname "$2")"
  cp -af "$1" "$2"
}

PARAM="Playback_ParamTreeView.xml"

# remove old param copies
find "$MODPATH/system/vendor" -type f -name "$PARAM" -delete 2>/dev/null

# copy params into canonical mirror
find /vendor -type f -name "$PARAM" | while read -r FILE; do
  MODFILE="$MODPATH/system$FILE"
  copy_param_file "$FILE" "$MODFILE"
done

EOF
