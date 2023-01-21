#!/usr/bin/env bash

echo "
                      .   *        .       .
       *      -0-
          .                .  *       - )-
       .      *       o       .       *
 o                |
           .     -O-
.                 |        *      .     -0-
       *  o     .    '       *      .        o
              .         .        |      *
   *             *              -O-          .
         .             *         |     ,
                .           o
        .---.
  =   _/__~0_\_     .  *            o       '
 = = (_________)             .
                 .                        *
       *               - ) -       *
              .               ."

month=`date +%B`
day=`date +%d`
time=`date +"%I:%M %p"`
echo -e " \033[0;34m $month $day, $time \033[0;35m | \"Experience is the teacher of all things.\" \033[0;33m - Julius Caesar"

