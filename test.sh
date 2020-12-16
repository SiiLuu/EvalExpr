#!/bin/bash

# COMPILATION
make re

## if echo 'pd'; then
##     echo "Mounts found"
## else
##     echo "Not mounts"
## fi

echo 'input: 2+2 = 4'
./funEvalExpr "2+2"
if [ $? == 0 ]; then
    echo "SUCCESS"
else
    echo "ERROR"
fi

echo 'input: 2-2 = 0'
./funEvalExpr "2-2"
if [ $? == 0 ]; then
    echo "SUCCESS"
else
    echo "ERROR"
fi

echo 'input: 2^2 = 4'
./funEvalExpr "2^2"
if [ $? == 0 ]; then
    echo "SUCCESS"
else
    echo "ERROR"
fi

echo 'input: 2*2 = 4'
./funEvalExpr "2*2"
if [ $? == 0 ]; then
    echo "SUCCESS"
else
    echo "ERROR"
fi

echo 'input: 2/2 = 1'
./funEvalExpr "2/2"
if [ $? == 0 ]; then
    echo "SUCCESS"
else
    echo "ERROR"
fi

echo 'input: 2.45+2.55 = 5'
./funEvalExpr "2.45+2.55"
if [ $? == 0 ]; then
    echo "SUCCESS"
else
    echo "ERROR"
fi

echo 'input: 2.45-2.55 = 0.10'
./funEvalExpr "2.45-2.55"
if [ $? == 0 ]; then
    echo "SUCCESS"
else
    echo "ERROR"
fi

echo 'input: 2.45^2.55 = 9.82'
./funEvalExpr "2.45^2.55"
if [ $? == 0 ]; then
    echo "SUCCESS"
else
    echo "ERROR"
fi

echo 'input: 2.45*2.55 = '
./funEvalExpr "2.45*2.55"
if [ $? == 0 ]; then
    echo "SUCCESS"
else
    echo "ERROR"
fi

echo 'input: 2.45/2.55 = 6.24'
./funEvalExpr "2.45/2.55"
if [ $? == 0 ]; then
    echo "SUCCESS"
else
    echo "ERROR"
fi

echo 'input: 2/0'
./funEvalExpr "2/0"
if [ $? == 84 ]; then
    echo "SUCCESS"
else
    echo "ERROR"
fi
