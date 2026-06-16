#!/bin/bash
set -e

BASE="/home/abc"

mkdir -p "$BASE"
mkdir -p "$BASE/.ssh"

cat > "$BASE/.gitconfig" <<'EOF'
[user]
    name = XianshuWang
    email = microindole@gmail.com

[credential]
    helper = store --file=/home/abc/.git-credentials

[http]
    sslVerify = false

[safe]
    directory = *
EOF

cat > "$BASE/.bashrc" <<'EOF'
export HOME=/home/abc
export GIT_CONFIG_GLOBAL=/home/abc/.gitconfig
export GIT_CONFIG_NOSYSTEM=1

export PS1='[abc-DEV] root@\h:\w# '

alias ll='ls -alF'
alias la='ls -la'
alias l='ls -CF'
EOF

cat > "$BASE/enter_abc.sh" <<'EOF'
#!/bin/bash
export HOME=/home/abc
cd /home/abc || exit 1
exec bash --rcfile /home/abc/.bashrc
EOF

chmod +x "$BASE/enter_abc.sh"
chmod 700 "$BASE/.ssh"

if [ -f "$BASE/.git-credentials" ]; then
    chmod 600 "$BASE/.git-credentials"
fi

echo "Done."
echo "Enter environment with:"
echo "  /home/abc/enter_abc.sh"