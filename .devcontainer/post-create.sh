#!/usr/bin/env bash
set -euo pipefail

R_HOME="$(R RHOME)"
R_LIB_PATHS="${R_HOME}/lib:/usr/lib/R/lib"
RSERVER_CONF="/etc/rstudio/rserver.conf"

set_conf() {
  local key="$1"
  local value="$2"
  local file="$3"

  if grep -q "^${key}=" "$file"; then
    sed -i "s|^${key}=.*|${key}=${value}|" "$file"
  else
    printf '%s=%s\n' "$key" "$value" >> "$file"
  fi
}

# Clean up known bad edits from previous attempts.
if [ -f /etc/init.d/rstudio-server ]; then
  sed -i 's/texport LD_LIBRARY_PATH/export LD_LIBRARY_PATH/g' /etc/init.d/rstudio-server || true
fi

mkdir -p /etc/rstudio
touch "$RSERVER_CONF"

set_conf "rsession-ld-library-path" "$R_LIB_PATHS" "$RSERVER_CONF"
# auth-none can loop in proxied environments when the user is empty.
# Keep PAM auth enabled (pam_permit is configured by the feature).
set_conf "auth-none" "0" "$RSERVER_CONF"
set_conf "auth-validate-users" "1" "$RSERVER_CONF"
set_conf "auth-minimum-user-id" "0" "$RSERVER_CONF"
set_conf "server-user" "root" "$RSERVER_CONF"

# Ensure root can authenticate in PAM mode across environments.
if command -v chpasswd >/dev/null 2>&1; then
  echo "root:root" | chpasswd
fi
if command -v passwd >/dev/null 2>&1; then
  passwd -u root >/dev/null 2>&1 || true
fi

mkdir -p /etc/profile.d
cat > /etc/profile.d/rstudio-libs.sh <<PROFILE_EOF
#!/usr/bin/env bash
export LD_LIBRARY_PATH=${R_LIB_PATHS}:\${LD_LIBRARY_PATH:-}
PROFILE_EOF
chmod +x /etc/profile.d/rstudio-libs.sh

rstudio-server test-config
service rstudio-server restart
