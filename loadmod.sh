#!/bin/bash
TARGET=192.168.3.139
BASE="`pwd`"
MODULE="snull"
SOURCE="$BASE/snull.c"

do_setup()
{
    cat ~/.ssh/id_dsa.pub | ssh root@$TARGET "cat >> .ssh/authorized_keys && chmod 644 .ssh/authorized_keys"
    if [ $? -eq 0 ]; then 
        touch $BASE/.setup
        echo $TARGET >> $BASE/.setup
    fi
}

do_check_setup()
{
    if [ -f $BASE/.setup ]; then
        echo "check connection with target ..... done "
    else
        "no connection to Target, must run setup:  $0 setup"
        exit 
    fi
}

do_make()
{
    make clean && make
    if [ $? -ne 0 ]; then
        echo "Error compiling, aborting !!"
        exit
    else 
        echo "Making Module $MODULE ..... done "
    fi

}

do_loadmod()
{
    if [ -f $MODULE.ko ]; then
        scp $MODULE.ko root@$TARGET:
        ssh root@$TARGET "rmmod $MODULE ; insmod $MODULE.ko "
        adresse=$(ssh  root@$TARGET "cat /proc/modules | grep $MODULE")
        echo "loading $MODULE into target ..... done "
        REPLY=$adresse
    else
        echo "The $Module is not found it me be not generated"
        exit
    fi
}

do_gdb()
{
  echo "loading adressin into gdb"
  
}

case "$1" in
  "setup")
    do_setup
    ;;
  "loadmod")
    do_loadmod
    ;;
  "make")
    do_make
    ;;
  "loadgdb")
    do_gdb
    ;;
  "")
    do_check_setup
    do_make
    do_loadmod
    do_gdb
    ;;
  *)
    ;;
esac    
