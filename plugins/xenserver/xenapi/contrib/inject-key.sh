#!/bin/bash
set -eux

SSH_PUBLIC_KEY_TO_BE_INJECTED="$1"

THIS_DIR=$(cd $(dirname $0) && pwd)
SPEC_FILE="$THIS_DIR/rpmbuild/SPECS/openstack-xen-plugins.spec"

(
sed -n '1,/ADDITIONAL_SSH_KEYS$/ p'  $SPEC_FILE
cat "$SSH_PUBLIC_KEY_TO_BE_INJECTED"
sed -n '/^ADDITIONAL_SSH_KEYS/,$ p'  $SPEC_FILE
) > "$SPEC_FILE.replaced"

rm -f "$SPEC_FILE"
mv "$SPEC_FILE.replaced" "$SPEC_FILE"
