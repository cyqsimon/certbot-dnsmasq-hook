# certbot-dnsmasq-hook

Certbot hooks to transiently add DNS challenge records to a running dnsmasq instance.

Note that you should have a publicly facing instance of dnsmasq already running
under systemd (i.e. `dnsmasq.service`) to use these hooks. If instead, you wish
the hooks spin up a new transient dnsmasq instance instead of piggy-backing on
an existing one, consider using
[NotTheRealJoe/certbot-dnsmasq](https://github.com/NotTheRealJoe/certbot-dnsmasq).

## Usage

When requesting your certificate with `certbot run`, do it like so:

```bash
certbot run \
  -d your.domain -d your.other.domain \
  --agree-tos --preferred-challenges=dns --manual \
  --manual-auth-hook=/path/to/certbot-dnsmasq-hook/auth.sh \
  --manual-cleanup-hook=/path/to/certbot-dnsmasq-hook/cleanup.sh
```

This will set up `/etc/letsencrypt/renewal/your.domain.conf` to look something like this:

```ini
# renew_before_expiry = 30 days
version = 2.6.0
archive_dir = /etc/letsencrypt/archive/your.domain
cert = /etc/letsencrypt/live/your.domain/cert.pem
privkey = /etc/letsencrypt/live/your.domain/privkey.pem
chain = /etc/letsencrypt/live/your.domain/chain.pem
fullchain = /etc/letsencrypt/live/your.domain/fullchain.pem

# Options used in the renewal process
[renewalparams]
account = <YOUR_ACCOUNT_ID>
pref_challs = dns-01,
authenticator = manual
manual_auth_hook = /path/to/certbot-dnsmasq-hook/auth.sh
manual_cleanup_hook = /path/to/certbot-dnsmasq-hook/cleanup.sh
server = https://acme-v02.api.letsencrypt.org/directory
key_type = ecdsa
```

After verifying that your certificate has been correctly obtained, enable
automatic renewal:

```bash
systemctl enable --now certbot-renew.timer
```
