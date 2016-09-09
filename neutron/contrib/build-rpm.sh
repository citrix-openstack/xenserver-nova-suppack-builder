#!/usr/bin/env bash

set -eux

# THIS_DIR is directory of neutron repo that build-rpm.sh located
# neutron/neutron/plugins/ml2/drivers/openvswitch/agent/xenapi/contrib
THIS_DIR=$(dirname $(readlink -f "$0"))
VERSION=${1:-"2012.1"}
PACKAGE=openstack-neutron-xen-plugins
RPMBUILD_DIR=$THIS_DIR/rpmbuild

if [ ! -d $RPMBUILD_DIR ]; then
    echo $RPMBUILD_DIR is missing
    exit 1
fi

for dir in BUILD BUILDROOT SRPMS RPMS SOURCES; do
    rm -rf $RPMBUILD_DIR/$dir
    mkdir -p $RPMBUILD_DIR/$dir
done

rm -rf /tmp/$PACKAGE
mkdir /tmp/$PACKAGE
cp -r ../etc/xapi.d /tmp/$PACKAGE
tar czf $RPMBUILD_DIR/SOURCES/$PACKAGE.tar.gz -C /tmp $PACKAGE

rpmbuild -ba --nodeps --define "_topdir $RPMBUILD_DIR"  \
    --define "version $VERSION" \
    --define "_binary_filedigest_algorithm  1" \
    --define "_binary_payload 1" \
    $RPMBUILD_DIR/SPECS/$PACKAGE.spec
