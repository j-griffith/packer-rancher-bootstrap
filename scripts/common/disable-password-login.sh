sed -E -i 's/^(#)?PasswordAuthentication.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -E -i 's/^(#)?PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config