#!/usr/bin/env bash
set -euo pipefail

user="${1:-}"
if [[ -z "${user}" ]]; then
  echo "missing username" >&2
  exit 2
fi

# Fail if username is not valid Linux username.
if ! [[ "${user}" =~ ^[a-z_][a-z0-9_-]{0,30}$ ]]; then
  echo "invalid username: ${user}" >&2
  exit 2
fi

home="/data/home/${user}"
key_dir="/data/ssh/users/${user}"
key_path="${key_dir}/id_ed25519"
pub_path="${key_path}.pub"

ensure_user_local() {
  if ! id -u "${user}" >/dev/null 2>&1; then
    mkdir -p "${home}"
    useradd -m -d "${home}" -s /bin/bash "${user}"
  fi

  mkdir -p "${home}/.ssh"
  chmod 700 "${home}/.ssh"
  touch "${home}/.ssh/authorized_keys"
  chmod 600 "${home}/.ssh/authorized_keys"
  chown -R "${user}:${user}" "${home}"
}

ensure_user_keypair() {
  mkdir -p "${key_dir}"
  chmod 700 "${key_dir}"
  if [[ ! -f "${key_path}" ]]; then
    ssh-keygen -t ed25519 -N '' -f "${key_path}" >/dev/null 2>&1
  fi
  chmod 600 "${key_path}"
  chmod 644 "${pub_path}"
}

install_user_key_local() {
  cp -f "${key_path}" "${home}/.ssh/id_ed25519"
  cp -f "${pub_path}" "${home}/.ssh/id_ed25519.pub"
  chmod 600 "${home}/.ssh/id_ed25519"
  chmod 644 "${home}/.ssh/id_ed25519.pub"

  cat > "${home}/.ssh/config" <<EOF
Host c1 c2 c3 c4
  User ${user}
  IdentityFile ${home}/.ssh/id_ed25519
EOF
  chmod 600 "${home}/.ssh/config"
  chown -R "${user}:${user}" "${home}/.ssh"
}

ensure_user_remote_node() {
  local node="$1"
  ssh -o StrictHostKeyChecking=accept-new root@"${node}" bash -lc "set -e
u='${user}'
home='/data/home/${user}'
if ! id -u \"\$u\" >/dev/null 2>&1; then
  mkdir -p \"\$home\"
  useradd -m -d \"\$home\" -s /bin/bash \"\$u\" || true
fi
mkdir -p \"\$home/.ssh\"
chmod 700 \"\$home/.ssh\"
touch \"\$home/.ssh/authorized_keys\"
chmod 600 \"\$home/.ssh/authorized_keys\"
grep -qF \"$(cat "${pub_path}")\" \"\$home/.ssh/authorized_keys\" || echo \"$(cat "${pub_path}")\" >> \"\$home/.ssh/authorized_keys\"
chown -R \"\$u:\$u\" \"\$home\"" >/dev/null 2>&1
}

ensure_user_local
ensure_user_keypair
install_user_key_local

if [[ "$(hostname)" = "slurmctld" ]]; then
  for n in c1 c2 c3 c4; do
    ensure_user_remote_node "${n}"
  done
fi
