#!/bin/bash

MEMORY_VARIABLE=memory
BITS=32
FILE_READ_FROM=code.hex
FILE_TO_PRINT=forpaste.txt
LINES=$(wc -l ${FILE_READ_FROM})
i=0

rm -f ${FILE_TO_PRINT}

while read line
do
	printf "${MEMORY_VARIABLE}[${i}] = ${BITS}'h${line};\r\n" >> ${FILE_TO_PRINT}
	i=$(expr ${i} + 1)
done < ${FILE_READ_FROM}

