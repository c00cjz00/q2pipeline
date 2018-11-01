#!/bin/bash
# Not getting caught out by that question again. 
 for i in {1..100}
 do
	if [ $(($i % 3)) = 0 ]; then
	echo -n "Fizz"
	fi
	if [ $(($i % 5)) = 0 ]; then
	echo -n "Buzz"
	fi
	if [ $(($i % 3)) != 0 ] && [ $(($i % 5)) != 0 ]; then
	echo -n "$i"
	fi
	echo
 done
