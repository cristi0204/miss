#!/usr/bin/env bash
# Copyright (C) 2023 National Cyber and Information Security Agency of the Czech Republic
set -e

if [ -f "/etc/yum.repos.d/vector.repo" ]; then
    echo "vector repository is already enabled." >&2
    exit
fi

cat >/etc/yum.repos.d/vector.repo <<'EOL'
[vector]
name=Vector
baseurl=https://yum.vector.dev/stable/vector-0/$basearch/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/DATADOG_RPM_KEY_CURRENT.public
EOL

# https://keys.datadoghq.com/DATADOG_RPM_KEY_CURRENT.public
cat >/etc/pki/rpm-gpg/DATADOG_RPM_KEY_CURRENT.public <<'EOL'
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQINBGRBYawBEADCRpOTAA5HMhH2sSfdjl5jEn4gyx8fvgt1FQbl87rBLrxVnjSW
/MDxi3KCWhqBYM1t61j2wDZAglwGxuu5VZC//eW9XgkjHlmCOC/1ns5oILxGQZMw
l2nMcVoo5Kh7YkoGE0aO0NpeVEYfLc8tRjz4pWpF3QR6FhcTXifTxORf0ujb9B+W
UEkg8fj8BIu7GJPHD0C0K4u3UfA9RgceRAB7dwktumXTrUrWfpS3x5KcQqaYzpwf
f22u0MLTzvOvfrEXhhWPjB5aMEAvEZg639cv4pYQyrKlx4l0b3buV3RWUvuofl3K
Hki1bpf6WA73wHC0Fw1DMVo64kj1/vxYK9jrc/YUGO1CzkT92LarhtfAKk60OODh
Ox7BQTYujyFL9KqKcF4DGEuQaiA7LOpJ7xm8Fd8aHSCJ9Wkfot7/L56+BAUPcJ3Y
Yom/KZjAojBi0lTfehaxsBgFPHrzWxG70ln/4KCaHTALhmTym9q+uq3hHBGeLNlC
3vwfxmkhpGZMDf8pcFucZo57GsbxUacKL2QGcOVrtwCLnDKm9+lNnaDZnxvDuABU
TsObm/KfileMCqvnAw7oh3aDbcQ4S90K4shuB5ScnZEe3w8MxDm5TswndIHhPnxu
/jImrOn1As2qqDSuE5hw4C6SjQ79z0Tng3oiTUJkYZuhdXiulFr1IoLJBQARAQAB
tEtEYXRhZG9nLCBJbmMuIFJQTSBrZXkgKDIwMjMtMDQtMjApIChSUE0ga2V5KSA8
cGFja2FnZStycG1rZXlAZGF0YWRvZ2hxLmNvbT6JAlQEEwEKAD4WIQR0CL/Va8W/
DDYaquhdiO6jsBCC0wUCZEFhrAIbAwUJCWYBgAULCQgHAgYVCgkICwIEFgIDAQIe
AQIXgAAKCRBdiO6jsBCC05rjD/0Ud/emeCdcJbAZK3zMjS1TqVODyZcay74Ba9As
jNfUZ1Rau9Uf6uj5emW8CaHG9kDy1ncoqcjMoF7B+dbZmCBaKcHqTOOuh+gVGPcf
WHgDC1cOj3ib78mBACYsgj74YPRYPsYU+8B1mRlzo8uQj7APskUv/+BIWPlwdfgi
2lWhLL/HZtBplqHcCbJQwzNVLXenAUSlcmI6nmx20bB8XDIgpAMhm4L616rM/f6M
XaPLzLSC7iUm39rGizHd1X+ZJ2gm4CJn8R/oBWb84//sXnpB2WOrdJxjY0UEaOZl
ViiK/sZT1uKJR/q9JSkuJtbpYQ7Bqlh5KjwK1fsL8TYihDRXPRHVWhNooH6Xf/Gg
IQpXITjO5bgUsJVzM+RKjckwL80SI31noABY/d4LSfCD7jeBhNBJ6N0RK2/jFjjK
eIhQsNr3pwXywNHZPu9Gw+G+IScFA2RVLYUOQme+heEXBvyhp5lb3gW7lztOR14r
niIxF1PtP8JszmwrH/FEBe3SRw3WYGJsPXyILJgzjMYEf0wHGC+2XWJmDOCp2n1X
uuFqKOIIzPhCD4fVWPGAtVyzf5uvTMWswE++kUhFxqIkElkexmffJ8Rf7XS4eArw
y7Nb2QMeDFC0ysz3VilWOAlBT2nEhHq6f+2XFwPYkb/WMmt469kb1m+rdu4FtqRJ
Q2zcdw==
=v956
-----END PGP PUBLIC KEY BLOCK-----
EOL
