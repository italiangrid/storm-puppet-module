#!/bin/bash
# copy .pem file from /etc/grid-security/certificates to /etc/pki/ca-trust/source/anchors
for file in $(find /etc/grid-security/certificates/ -type f -name '*.pem')
	do cp -f $file /etc/pki/ca-trust/source/anchors/
done
# create bundle
update-ca-trust

## Update ca trust does not include trust anchors that can sign client-auth certs,
## which looks like a bug
DEST=/etc/pki/ca-trust/extracted

/usr/bin/p11-kit extract --comment --format=pem-bundle --filter=ca-anchors --overwrite --purpose client-auth $DEST/pem/tls-ca-bundle-client.pem
cat $DEST/pem/tls-ca-bundle.pem $DEST/pem/tls-ca-bundle-client.pem >> $DEST/pem/tls-ca-bundle-all.pem

# reload nginx
systemctl reload nginx
