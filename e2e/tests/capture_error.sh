#!/bin/bash
if result=$(kubectl wait --for=condition=ready pod --all-namespaces -l weirdopod=yup --timeout=30s 2>&1); then
    stdout=$result
else
    rc=$?
    stderr=$result
fi

echo "stdout error.sh: $stdout"
echo "stderr error.sh: $stderr"

stdout=
stderr=

if result=$(./success.sh 2>&1); then
    stdout=$result
else
    rc=$?
    stderr=$result
fi

echo "stdout success.sh: $stdout"
echo "stderr success.sh: $stderr"