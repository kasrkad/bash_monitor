#!/bin/bash
#Цвета для вывода в консоль
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
#Папка для поиска конфигов
PATH_TO_FOLDER=`echo $0 | sed -r 's/monitor_v4.+//'`
#Функция пинга, принимает на вход строку типа "ИМЯ АЙПИ", разбивает по пробелам, проверяет доступность и отображает, при недоступности
#пришет в log_down

function ping_states() {
  while read LINE; do
      NAME=`echo $LINE | cut -d ' ' -f1`
      IP_ADDR=`echo $LINE | cut -d ' ' -f2`
      if ping -c 1 -W 2 $IP_ADDR >/dev/null
      then
    	echo -e "${GREEN} $NAME ${NC}"
      else
      #echo -e "$date HOST $NAME down" >> ./log_down
    	echo -e " ${RED}$NAME ${NC}"
    fi
  done < $1
}
#Бесконечный цикл проверки новых конфигов (файлы *.cfg) в папке запуска,
# парсинга и запуска функции проверки доступности
while :
do
  FILES=`find $PATH_TO_FOLDER -name "*.conf"`
  date=$(date +"%T")
  echo "Последняя проверка   : $date"
  for PATH_TO_FILES in $FILES
    do
      echo -e "\n$PATH_TO_FILES"
      ping_states $PATH_TO_FILES
    done
sleep 30
clear
done
