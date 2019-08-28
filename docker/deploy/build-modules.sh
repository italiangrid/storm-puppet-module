#!/bin/bash
set -ex

cd /module
puppet module build
puppet module install ./pkg/mwdevel-storm-0.1.0.tar.gz

cd /
git clone https://github.com/cnaf/ci-puppet-modules.git
cd ci-puppet-modules/modules

cd mwdevel_egi_trust_anchors
puppet module build
puppet module install ./pkg/mwdevel-mwdevel_egi_trust_anchors-0.1.0.tar.gz
cd ..

cd mwdevel_umd_repo
puppet module build
puppet module install ./pkg/mwdevel-mwdevel_umd_repo-0.1.0.tar.gz
cd ..

cd mwdevel_voms
puppet module build
puppet module install ./pkg/mwdevel-mwdevel_voms-0.1.0.tar.gz
cd ..

cd mwdevel_test_vos
puppet module build
puppet module install ./pkg/mwdevel-mwdevel_test_vos-0.1.0.tar.gz
cd ..

cd mwdevel_test_ca
puppet module build
puppet module install ./pkg/mwdevel-mwdevel_test_ca-0.1.0.tar.gz
cd ..
