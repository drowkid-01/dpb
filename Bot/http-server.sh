#!/bin/bash
IVAR="/etc/http-instas"
onliCHECK=/var/www/html/eselkidpa
LIST="$(echo "NewVPS-" | rev)"
[[ -d /var/www/html/eselkidpa ]] || mkdir ${onliCHECK}
install_fun () {
apt-get install netcat -y
}
fun_ip () {
_hora=$(printf '%(%D-%H:%M:%S)T')
if [[ -e /usr/games/mip ]]; then
	IP=$(mip)
else
	touch /usr/games/mip&&chmod +x /usr/games/mip
	echo 'echo -e \"$(wget -qO- ifconfig.me)\"' > /usr/games/mip
	mip
fi
}

#OFUSCATE
ofus () {
unset txtofus
number=$(expr length $1)
for((i=1; i<$number+1; i++)); do
txt[$i]=$(echo "$1" | cut -b $i)
case ${txt[$i]} in
".")txt[$i]="x";;
"x")txt[$i]=".";;
"5")txt[$i]="s";;
"s")txt[$i]="5";;
"1")txt[$i]="@";;
"@")txt[$i]="1";;
"2")txt[$i]="?";;
"?")txt[$i]="2";;
"4")txt[$i]="0";;
"0")txt[$i]="4";;
"/")txt[$i]="K";;
"K")txt[$i]="/";;
esac
txtofus+="${txt[$i]}"
done
echo "$txtofus" | rev
}

# LISTEN
listen_fun () {
PORTA="8888"
PROGRAMA="/root/server.sh"
while true; do
 nc.traditional -l -p "$PORTA" -e "$PROGRAMA"
done
}
# SERVER
server_fun () {
fun_ip
PORTA="8888"
DIR="/etc/http-shell"
unset ENV_ARQ
if [[ ! -d $DIR ]]; then
mkdir $DIR
fi
read URL
KEY$(echo $URL|cut -d ' ' -f2|awk -F "-" '{print $2 $3 }') &&[[ ! $KEY ]] && KEY="ERRO"
ARQ=$(echo $URL|awk -F "-" '{print $1}') && [[ ! $ARQ ]] && ARQ="ERRO"
USRIP='ERRO'
FILE2="${DIR}/${KEY}"
FILE="${DIR}/${KEY}/$ARQ"
if [[ -e ${FILE} ]]; then
STATUS_NUMBER="200"
STATUS_NAME="Found"
ENV_ARQ="True"
 if [[ -e ${FILE2}/GERADOR ]]; then
   if [[ ${USRIP} != "ERRO" ]]; then
    FILE="${DIR}/ERROR-KEY"
    echo "GERADOR KEY!" > ${FILE}
    ENV_ARQ="False"
   fi
 else
   if [[ ${USRIP} = "ERRO" ]]; then
    FILE="${DIR}/ERROR-KEY"
    echo "KEY DE @drowkid01!" > ${FILE}
    ENV_ARQ="False"
   fi
 fi
else
FILE="${DIR}/ERROR-KEY"
echo "KEY INVALIDA!" > ${FILE} 
STATUS_NUMBER="200"
STATUS_NAME="Found"
ENV_ARQ="False"
fi
cat << EOF
HTTP/1.1 $STATUS_NUMBER - $STATUS_NAME
Date: $(date)
Server: ShellHTTP
Content-Length: $(wc --bytes "$FILE" | cut -d " " -f1)
Connection: close
Content-Type: text/html; charset=utf-8

$(cat "$FILE")
EOF
if [[ $ENV_ARQ = "True" ]]; then
(
mkdir /var/www/html/$KEY
mkdir /var/www/$KEY
TIME="20+"
  for arqs in `cat $FILE`; do
  cp ${FILE2}/$arqs /var/www/html/$KEY/
  cp ${FILE2}/$arqs /var/www/$KEY/
  TIME+="1+"
  done
_key="$(ofus ${IP}:${PORTA}/${KEY}/${LIST})"
echo "$(cat ${FILE2}.name) | $USRIP | ${_key} | $_hora" > /var/www/html/$KEY/checkIP.log
echo "$(cat ${FILE2}.name) | $USRIP | ${_key} | $_hora" > /var/www/$KEY/checkIP.log
RESELL="$(cat /var/www/$KEY/menu_credito)"
TIME=$(echo "${TIME}0"|bc)
sleep ${TIME}s
rm -rf /var/www/html/$KEY
rm -rf /var/www/$KEY
log="/etc/gerar-sh-log"
_hora=$(printf '%(%D-%H:%M:%S)T') 
if [[ -d $FILE2 ]]; then
PERM="${DIR}/${KEY}/keyfixa" 
if [[ -e $PERM ]]; then
  if [[ $(cat $PERM) != "$USRIP" ]]; then
  log="/etc/gerar-sh-log"
  echo "$(cat ${FILE2}.name) | IP-FIJA:$USRIP | ${_key} | $_hora" >> $log
  echo "$(cat ${FILE2}.name) | IP-FIJA:$USRIP | ${_key} | $_hora" >> ${onliCHECK}/checkIP.log && chmod +x ${onliCHECK}/checkIP.log
  #cat /etc/gerar-sh-log > ${onliCHECK}/checkIP.log
  rm -rf $FILE2
  rm -f ${FILE2}.name
  fi
else
echo "$(cat ${FILE2}.name) | $USRIP | ${_key} | $_hora" >> $log
echo "$(cat ${FILE2}.name) | $USRIP | ${_key} | $_hora" >> ${onliCHECK}/checkIP.log && chmod +x ${onliCHECK}/checkIP.log
#[[ -e /etc/ADM-db/token ]] && {
data=($(curl -sSL https://gitea.com/drowkid01/scriptdk1/raw/branch/main/Control/token.sh|awk '{print $1,$2}'))
[[ ! -z ${data[0]} ]] && {
ID="$(cat ${FILE2}.name)" && ID="$(echo $ID | awk '{print $1}' | sed -e 's/[^0-9]//ig')"
[[ ${ID} -lt '999' ]] && ID="${data[1]}"
TOKEN="${data[0]}"
urlBOT="https://api.telegram.org/bot$TOKEN/sendMessage"
MENSAJE="  =======================================\n"
MENSAJE+=" ========📩𝙈𝙀𝙉𝙎𝘼𝙅𝙀 𝙍𝙀𝘾𝙄𝘽𝙄𝘿𝙊📩========\n"
MENSAJE+=" =======================================\n"
MENSAJE+=" ${_key}\n"
MENSAJE+=" =========== ☝️ USADA ☝ ============\n"
#MENSAJE+="            ☝️ USADA ☝️ \n"
MENSAJE+=" API/KEY : ${RESELL}\n"
MENSAJE+=" ID/API: ${ID} ✅ NOTIFICADO \n"
MENSAJE+=" =======================================\n"
MENSAJE+=" IP : $USRIP <-> HORA : $_hora\n"
MENSAJE+=" =======================================\n"
MENSAJE+='       🔰 Bot generador de key 🔰\n'
MENSAJE+='           ⚜ By @drowkid01 ⚜ \n'
MENSAJE+=" =======================================\n"
#curl -s -X POST $urlBOT -d chat_id=$ID -d text="$(echo -e "$MENSAJE")" &>/dev/null
curl -s --max-time 10 -d "chat_id=$ID&disable_web_page_preview=1&text=$(echo -e "$MENSAJE")" $urlBOT &>/dev/null
}
rm -rf $FILE2
rm -f ${FILE2}.name
fi
num=$(cat ${IVAR})
 if [[ $num = "" ]]; then
 num=0
 fi
let num++
echo $num > $IVAR
fi
) & > /dev/null
fi
}

[[ $1 = @(-[Ss]tart|-[Ss]|-[Ii]niciar) ]] && listen_fun && exit
[[ $1 = @(-[Ii]stall|-[Ii]|-[Ii]stalar) ]] && listen_fun && exit
server_fun
