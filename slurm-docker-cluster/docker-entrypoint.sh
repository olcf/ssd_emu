#!/bin/bash
set -e

start_sshd() {
    mkdir -p /var/run/sshd
    if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
        ssh-keygen -A >/dev/null 2>&1 || true
    fi

    # Avoid nologin blocking unprivileged SSH sessions in containers.
    rm -f /run/nologin /var/run/nologin >/dev/null 2>&1 || true

    # Create a shared "login key" once, and use it for passwordless SSH.
    # We use /data because it's already a shared volume across the cluster.
    mkdir -p /data/ssh
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh

    if [ "$(hostname)" = "slurmctld" ]; then
        if [ ! -f /data/ssh/login_ed25519 ]; then
            ssh-keygen -t ed25519 -N '' -f /data/ssh/login_ed25519 >/dev/null 2>&1
        fi
        cp -f /data/ssh/login_ed25519 /root/.ssh/id_ed25519
        cp -f /data/ssh/login_ed25519.pub /root/.ssh/id_ed25519.pub
        chmod 600 /root/.ssh/id_ed25519
        chmod 644 /root/.ssh/id_ed25519.pub

        # For`ssh root@c1` to use the key automatically.
        cat > /root/.ssh/config <<'EOF'
Host c1 c2 c3 c4
  User root
  IdentityFile /root/.ssh/id_ed25519
EOF
        chmod 600 /root/.ssh/config
    fi

    # Trust the login public key for root on every node (including slurmctld).
    if [ -f /data/ssh/login_ed25519.pub ]; then
        touch /root/.ssh/authorized_keys
        chmod 600 /root/.ssh/authorized_keys
        if ! grep -qF "$(cat /data/ssh/login_ed25519.pub)" /root/.ssh/authorized_keys; then
            cat /data/ssh/login_ed25519.pub >> /root/.ssh/authorized_keys
        fi
    fi

    cat > /etc/ssh/sshd_config <<'EOF'
Port 22
Protocol 2

HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

PermitRootLogin yes
PasswordAuthentication no
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

UsePAM no
PrintMotd no
Subsystem sftp /usr/libexec/openssh/sftp-server
EOF

    if ! pgrep -x sshd >/dev/null 2>&1; then
        /usr/sbin/sshd -E /var/log/sshd.log
    fi
}

if [ "$1" = "slurmdbd" ]
then
    echo "---> Starting the MUNGE Authentication service (munged) ..."
    gosu munge /usr/sbin/munged

    echo "---> Starting the Slurm Database Daemon (slurmdbd) ..."

    {
        . /etc/slurm/slurmdbd.conf
        until echo "SELECT 1" | mysql -h $StorageHost -u$StorageUser -p$StoragePass 2>&1 > /dev/null
        do
            echo "-- Waiting for database to become active ..."
            sleep 2
        done
    }
    echo "-- Database is now active ..."

    exec gosu slurm /usr/sbin/slurmdbd -Dvvv
fi

if [ "$1" = "slurmctld" ]
then
    echo "---> Starting SSH service ..."
    start_sshd

    echo "---> Starting the MUNGE Authentication service (munged) ..."
    gosu munge /usr/sbin/munged

    echo "---> Waiting for slurmdbd to become active before starting slurmctld ..."

    until 2>/dev/null >/dev/tcp/slurmdbd/6819
    do
        echo "-- slurmdbd is not available.  Sleeping ..."
        sleep 2
    done
    echo "-- slurmdbd is now active ..."

    echo "---> Starting the Slurm Controller Daemon (slurmctld) ..."
    if /usr/sbin/slurmctld -V | grep -q '17.02' ; then
        exec gosu slurm /usr/sbin/slurmctld -Dvvv
    else
        exec gosu slurm /usr/sbin/slurmctld -i -Dvvv
    fi
fi

if [ "$1" = "slurmd" ]
then
    start_sshd

    echo "---> Starting the MUNGE Authentication service (munged) ..."
    gosu munge /usr/sbin/munged

    echo "---> Waiting for slurmctld to become active before starting slurmd..."

    until 2>/dev/null >/dev/tcp/slurmctld/6817
    do
        echo "-- slurmctld is not available.  Sleeping ..."
        sleep 2
    done
    echo "-- slurmctld is now active ..."

    echo "---> Starting the Slurm Node Daemon (slurmd) ..."
    exec /usr/sbin/slurmd -Dvvv
fi

exec "$@"
