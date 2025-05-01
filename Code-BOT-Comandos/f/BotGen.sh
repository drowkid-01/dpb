#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#https://github.com/joao-lucas/ShellBot

CIDdir=/etc/ADM-db && [[ ! -d ${CIDdir} ]] && mkdir ${CIDdir}
CIDimg=/etc/tokenIMG && [[ ! -d ${CIDimg} ]] && mkdir ${CIDimg}
SRC="${CIDdir}/sources" && [[ ! -d ${SRC} ]] && mkdir ${SRC}
CIDRESS="${CIDdir}/RESSELLERS" && [[ ! -e ${CIDRESS} ]] &&  mkdir ${CIDRESS}
block="${CIDdir}/block"&&[[ ! -d $block ]] && mkdir -p $block
CID="${CIDdir}/User-ID"
keytxt="${CIDdir}/keys" && [[ ! -d ${keytxt} ]] && mkdir ${keytxt}
img="${CIDimg}/img" && [[ ! -d ${timg} ]] && mkdir ${timg}
[[ $(dpkg --get-selections|grep -w "jq"|head -1) ]] || apt-get install jq -y &>/dev/null
[[ ! -e "/bin/ShellBot.sh" ]] && wget -O /bin/ShellBot.sh https://raw.githubusercontent.com/NetVPS/Generador-BOT/main/Otros/ShellBot.sh &> /dev/null
[[ -e /etc/texto-bot ]] && rm /etc/texto-bot
LINE="   ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••"
line='============================='

fsub='subdomain.log'
txt[0]='Ingresa tu IP:'
txt[1]='Ingresa el subdominio:'
txt[2]='Ingresa tu reseller:'

source ShellBot.sh
source ${SRC}/menu
source ${SRC}/ayuda
source ${SRC}/cache
source ${SRC}/invalido
source ${SRC}/status
source ${SRC}/reinicio
source ${SRC}/myip
source ${SRC}/id
source ${SRC}/back_ID
source ${SRC}/link
source ${SRC}/listID
source ${SRC}/gerar_key
source ${SRC}/power
#source ${SRC}/comandos
source ${SRC}/update
source ${SRC}/donar
source ${SRC}/costes
source ${SRC}/extras

bot_token=$(cat ${CIDdir}/token)

ShellBot.init --token "$bot_token" --monitor --flush --return map
ShellBot.username

ban(){
bann=''
 [[ -z $1 ]] && {
	local bot_retorno='Ingrese un ID:'
	reply&&return $?
  }
case $1 in
 --idd) idd=${message_text[$id]}
	opcion="${idd}"&&TOKEN='6737010670:AAHLCAXetDPYy8Sqv1m_1c0wbJdDDYeEBcs'
	URL="https://api.telegram.org/bot$TOKEN/getChatMember"
	nombre=$(curl -s -X POST $URL -d chat_id="$opcion" -d user_id="$opcion" | jq -r .result.user.first_name)
	usuario=$(curl -s -X POST $URL -d chat_id="$opcion" -d user_id="$opcion" | jq -r .result.user.username)
	bot_retorno="$line\n      [•] INFORMACIÓN DEL USUARIO [•]\n${line}\n👤●⸺[ <b>${nombre}</b> ]\n"
	bot_retorno="🗣️●⸺[ <ins>${usuario}</ins> ]\n"
	bot_retorno="🆔●⸺[ <code>${idd}</code> ]\n$line\n"
	ShellBot.InlineKeyboardButton --button 'bann' --line 1 --text "❌ BANEAR ${idd} ❌" --callback_data "/banid --add ${idd}"
	ShellBot.InlineKeyboardButton --button 'bann' --line 2 --text "✅ DESBANEAR ${idd} ✅" --callback_data "/banid --del ${idd}"
	ShellBot.InlineKeyboardButton --button 'bann' --line 3 --text '<<< volver al menú anterior' --callback_data '/menu'
	menu_print 'bann'
 ;;
  --add | --del )id="$2"
	if [[ $1 == '--add' ]]; then
		echo "$id" >> ${block}/block-id&&txt='BLOQUEADO'
	else
		sed -i "/${id}/d" ${block}/block-id&&txt='DESBLOQUEADO'
	fi
	bot_retorno="$line\n✅ ID ${id} ${txt} EXITOSAMENTE ✅\n$line"
	msj_fun;;
esac
}

ress(){
[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
ressm=''
	[[ -z $1 ]] && {
		bot_retorno="${txt[2]}"
		reply
		return $?
	} || {
		case $1 in
		 --verify)
		echo "$2" > ${CIDRESS}/${chatuser}.conf
		datauser
		bot_retorno+="✅RESELLER MODIFICADO CORRECTAMENTE ✅\n$line\n"
		menu_print 'atras';;
		 --change)
			bot_retorno="$line\n 👤 RESELLER: <b>${message_text[$id]}</b>\n$line\n"
			bot_retorno+="<b>¿guardar <tg-spoiler><ins>${message_text[$id]}</ins></tg-spoiler> como reseller?:</b>\n"
			ShellBot.InlineKeyboardButton --button 'ressm' --line 1 --text "✅ SI, GUARDAR ${message_text[$id]} COMO RESS ✅" --callback_data "/cres --verify ${message_text[$id]}"
			ShellBot.InlineKeyboardButton --button 'ressm' --line 2 --text "❌ME EQUIVOQUÉ AL INGRESAR MI RESS ❌" --callback_data "/ress"
			ShellBot.InlineKeyboardButton --button 'ressm' --line 3 --text '<<<volver al menú anterior' --callback_data '/menu'
			ShellBot.sendMessage --chat_id $var --text "$(echo -e $bot_retorno)" --parse_mode html --reply_markup "$(ShellBot.InlineKeyboardMarkup -b 'ressm')";;
		esac
	}
}

datauser(){
[[ -z "${message_from_first_name[$id]}" ]] && name="${callback_query_from_first_name}" || name="${message_from_first_name[$id]}"
[[ ! -z "${message_from_username[$id]}" ]] && username="${message_from_username[$id]}" || username="${callback_query_from_username[$id]}"
[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}

if [[ "$permited" != "$chatuser" ]]; then
	if [[ $(cat ${CIDdir}/User-ID|grep "$chatuser") == "" ]]; then
		usr=0
	else
		usr=1
	fi
else
	usr=2
fi
check=( [0]='❌SIN ACCESO❌' [1]='✅CON ACCESO✅' [2]='⚡patoAdmin⚡' )

[[ -e ${CIDRESS}/${chatuser}.conf ]] && {
	name=$(cat ${CIDRESS}/${chatuser}.conf)
}

bot_retorno="$line\n⠀ ⠀⠀⠀⠀⠀◍ ᴅᴏɴᴘᴀᴛᴏʙᴏᴛ ◍\n$line\n"
bot_retorno+="👤●⸺[ <tg-spoiler>$name</tg-spoiler> ]\n"
bot_retorno+=" 🗣️●⸺[ <b>@$username</b> ]\n"
bot_retorno+="🆔●⸺[ <code>$var</code> ]\n"
bot_retorno+="📡●⸺[ <ins>${check[$usr]}</ins> ]\n"
bot_retorno+="$line\n"

}

reply () {
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}

 	 ShellBot.sendMessage	--chat_id  $var \
				--text "$(echo -e "${bot_retorno:=$comando}")" \
					--parse_mode html --reply_markup "$(ShellBot.ForceReply)"
}
repply() {
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}

 	 ShellBot.sendMessage	--chat_id  $var \
				--text "$(echo -e "$comando")" \
					--parse_mode html --reply_markup "$(ShellBot.ForceReply)"
}

menu_(){
[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}

ShellBot.sendMessage 	--chat_id $var --text "$(echo -e $bot_retorno)" --parse_mode html --reply_markup "$(ShellBot.InlineKeyboardMarkup -b "$1")"
return $?
}


menu_print () {
[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
	ShellBot.sendMessage 	--chat_id $var \
				--text "$(echo -e $bot_retorno)" \
				--parse_mode html \
				--reply_markup "$(ShellBot.InlineKeyboardMarkup -b "$1")"
}

menu_printSN () {
[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}

	if [[ $(echo $permited|grep "${chatuser}") = "" ]]; then
				ShellBot.sendMessage 	--chat_id $var \
				--text "<b>$(echo -e $bot_retorno)</b>" \
				--parse_mode html \
				--reply_markup "$(ShellBot.InlineKeyboardMarkup -b 'botao_send_id')"
	fi
}

download_file () {
# shellbot.sh editado linea 3986
user=User-ID
[[ -e ${CID} ]] && rm ${CID}
local file_id
          ShellBot.getFile --file_id ${message_document_file_id[$id]}
          ShellBot.downloadFile --file_path "${return[file_path]}" --dir "${CIDdir}"
		  [[ -e ${return[file_path]} ]] && mv ${return[file_path]} ${CID}
local bot_retorno="ID user botgen\n"
		bot_retorno+="$line\n"
		bot_retorno+="Se restauro con exito!!\n"
		bot_retorno+="$line\n"
		bot_retorno+=" FILE ${return[file_path]} \n"
		bot_retorno+="$line"
			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<b>$(echo -e $bot_retorno)</b>" \
									--parse_mode html
return 0
}


msj_add () {
	      ShellBot.sendMessage --chat_id ${1} \
							--text "<b>$(echo -e $bot_retor)</b>" \
							--parse_mode html
}

upfile_fun () {
        [[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
          ShellBot.sendDocument --chat_id $var  \
                             --document @${1} \
                             --caption  "$(echo -e "$bot_retorno")" \
                             --parse_mode html \
                             --reply_markup "$(ShellBot.InlineKeyboardMarkup -b "$2")"
}
invalido_fun () {
MSG_id=$((${message_message_id} + 1 ))
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
	local bot_retorno="  🎊 𝙱𝚒𝚎𝚗𝚟𝚎𝚗𝚒𝚍𝚘  𝚊𝚕  𝙱𝚘𝚝𝙶𝚎𝚗  𝙰𝙳𝙼  🎊\n"
		bot_retorno+="$line\n"
        bot_retorno+=" COMANDO NO PERMITIDO !!\n Quizas debes usar este /keygen \n O Posiblemente no estas Autorizado, clic aqui /prices o \n Contacta a $(cat < /etc/ADM-db/resell) y adquiere una subscripcion \n Toca aqui para ayuda /ayuda \n"
        bot_retorno+="$line\n"
	    ShellBot.sendMessage --chat_id $var \
							--text "<b>$(echo -e $bot_retorno)</b>" \
							--parse_mode html
		sleep 5s
		msj_del ${message_message_id}
		msj_del ${MSG_id}
							return 0	
}


send_admin(){

	local bot_retorno2="$line\n"
	bot_retorno2+="🔰 Solicitud de autorizacion 🔰\n"
	bot_retorno2+="$line\n"
	bot_retorno2+="<u>Nombre</u>: ${callback_query_from_first_name}\n"
	[[ ! -z ${callback_query_from_username} ]] && bot_retorno2+="<u>Alias</u>: @${callback_query_from_username}\n"
	bot_retorno2+="<u>ID</u>: <code>${callback_query_from_id}</code>\n"
	bot_retorno2+="$line"

	bot_retorno="$line\n"
	bot_retorno+="     🔰 Bot generador de key 🔰\n"
	bot_retorno+="           ⚜ by @drowkid01 ⚜\n"
	bot_retorno+="$line\n"
	bot_retorno+="      ✅ ID enviado al admin ✅\n"
	bot_retorno+="$line"
	comand_boton "atras"

	saveID "${callback_query_from_id}"
	var=$(cat < ${CIDdir}/Admin-ID)
	ShellBot.sendMessage 	--chat_id $var \
							--text "$(echo -e "$bot_retorno2")" \
							--parse_mode html \
							--reply_markup "$(ShellBot.InlineKeyboardMarkup -b 'botao_save_id')"

	return 0
}


msj_fun () {
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
		      ShellBot.sendMessage --chat_id $var \
							--text "<b>$(echo -e "$bot_retorno")</b>" \
							--parse_mode html
	return 0
}

msj_del () {
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
		      ShellBot.deleteMessage --chat_id $var --message_id $1 			  
	return 0
}

msj_img () {
#${timg}/id_${usrLOP}.png
local file_id
          ShellBot.getFile --file_id "$1"
          #ShellBot.downloadFile --file_path "${return[file_path]}" --dir "${timg}/id_${usrLOP}.png"
		  #[[ -e ${return[file_path]} ]] && mv ${return[file_path]} "${timg}/id_${usrLOP}.png1"

	#[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
		      #ShellBot.sendPhoto --chat_id $var --photo @${timg}/id_${usrLOP}.png
			  #ShellBot.deleteMessage --chat_id $var --message_id $1
			  upimg_fun
local bot_retorno="ID user botgen\n"
		bot_retorno+="$line\n"
		bot_retorno+="Se restauro con exito!!\n"
		bot_retorno+="$line\n"
		bot_retorno+=" FILE ${return[file_path]} \n"
		bot_retorno+="$line"
			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<b>$(echo -e $bot_retorno)</b>" \
									--parse_mode html	
	
	return 0
}

soporte(){
datauser
case $1 in
 --botlat)
	bot_retorno+="<b>Sólo los usuarios con acceso pueden recibir soporte!</b>\n<ins>Si no tienes acceso, pídele soporte a @drowkid01</ins>\n$line\n"
	soporte=''
	ShellBot.InlineKeyboardButton --button 'soporte' --line 1 --text '⚡ chatear con el desarrollador ⚡' --callback_data '1' --url 'https://t.me/drowkid01'
	ShellBot.InlineKeyboardButton --button 'soporte' --line 2 --text '<<< volver al menú anterior' --callback_data '/oka'
	menu_print 'soporte'
	;;
esac
}



msj_chat () {
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
		      ShellBot.sendChatAction --chat_id $var --action typing
			  #ShellBot.deleteMessage --chat_id $var --message_id $1 
	return 0
}


msj_donar () {
	[[ ! -z ${callback_query_message_chat_id[$id]} ]] && var=${callback_query_message_chat_id[$id]} || var=${message_chat_id[$id]}
	      ShellBot.sendMessage --chat_id $var \
							--text "<b>$(echo -e "$bot_retorno")</b>" \
							--parse_mode html \
							--reply_markup "$(ShellBot.InlineKeyboardMarkup -b 'botao_donar')"
	return 0
}


saveID(){
	unset botao_save_id
	botao_save_id=''
	ShellBot.InlineKeyboardButton 	--button 'botao_save_id' --line 1 --text "Autorizar ID" --callback_data "/saveid $1"
}

keycheck(){
local ksy=''
	datauser
	bot_retorno+="<b>seleccione el script:</b>\n$line\n"
	ShellBot.InlineKeyboardButton --button 'ksy' --line 1 --text 'chukk' --callback_data '/checkchukk'
	ShellBot.InlineKeyboardButton --button 'ksy' --line 2 --text 'latam' --callback_data '/checK -k'
	ShellBot.InlineKeyboardButton --button 'ksy' --line 3 --text 'vpsmx' --callback_data '/checK -k'
	menu_print 'ksy'
}
botao_conf=''
botao_user=''
botao_donar=''
unset botao_send_id
atras=''&&domain=''&&keys=''
botao_send_id=''
ShellBot.InlineKeyboardButton --button 'botao_send_id' --line 1 --text "ENVIAR al ADM" --callback_data '/sendid'
ShellBot.InlineKeyboardButton --button 'botao_send_id' --line 1 --text "menu" --callback_data '/menu'

ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'NEW ID' --callback_data '/add'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'QUITAR 🗑' --callback_data '/del'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text 'LISTAR 📋' --callback_data '/list'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 1 --text ' 🔎 ID' --callback_data '/buscar'

ShellBot.InlineKeyboardButton --button 'botao_conf' --line 2 --text ' ✅ | ❌ ' --callback_data '/power'
ShellBot.InlineKeyboardButton --button 'botao_conf' --line 2 --text 'MENU' --callback_data '/menu'

ShellBot.InlineKeyboardButton --button 'botao_conf' --line 3 --text '🔑 GENERAR KEY 🔑' --callback_data '/chukk'
ShellBot.InlineKeyboardButton --button 'botao_user' --line 1 --text '🔑 GENERAR KEY 🔑' --callback_data '/chukk'
ShellBot.InlineKeyboardButton --button 'botao_user' --line 2 --text '👤MODIFICAR RESS 👤' --callback_data '/ress'
ShellBot.InlineKeyboardButton --button 'botao_user' --line 3 --text '⚙️ SOPORTE ⚙️' --callback_data '1' --url 'https://t.me/drowkid01'
ShellBot.InlineKeyboardButton --button 'botao_user' --line 3 --text '🚀 GRUPO OFICIAL 🚀' --callback_data '1' --url 'https://t.me/botlatmx'
#ShellBot.InlineKeyboardButton --button 'botao_user' --line 4 --text '⚡ TOOLS ⚡' --callback_data '/tools'

ShellBot.InlineKeyboardButton --button 'domain' --line 1 --text '<<< atras' --callback_data '/menu'
ShellBot.InlineKeyboardButton --button 'domain' --line 2 --text 'ENLAZAR SUBDOMINIO A UNA IP' --callback_data '/ippp'

ShellBot.InlineKeyboardButton --button 'keys' --line 1 --text 'verificar keys' --callback_data '/checkey'

#ShellBot.InlineKeyboardButton --button 'botao_user' --line 2 --text ' 🧿 Ban|IP 📲' --callback_data '/banIP' # '1' --url "https://t.me/$(cat < /etc/ADM-db/resell)"
#ShellBot.InlineKeyboardButton --button 'botao_user' --line 2 --text ' 🛒 CATALOGO 📝 ' --callback_data  '1' --url "$(cat < /etc/urlCT)"
#ShellBot.InlineKeyboardButton --button 'botao_user' --line 3 --text '💰 DONAR 💰' --callback_data  '1' --url "$(cat < /etc/urlDN)"
#ShellBot.InlineKeyboardButton --button 'botao_user' --line 3 --text ' 🪀 WTS 📲' --callback_data  '1' --url "https://wa.me/$(cat < /etc/numctc)"
#ShellBot.InlineKeyboardButton --button 'botao_user' --line 3 --text ' MENU ' --callback_data '/menu'

#ShellBot.InlineKeyboardButton --button 'botao_user' --line 2 --text ' Contacto 📲' --callback_data  '1' --url 'https://wa.me/593987072611?text=Hola!,%20ℂ𝕙𝕦𝕞𝕠𝔾ℍ%20Me%20interesa%20Conocer%20más%20sobre%20el%20ADM.'
ShellBot.InlineKeyboardButton --button 'atras' --line 1 --text '<<< volver al menú anterior' --callback_data '/menu'
#ShellBot.InlineKeyboardButton --button 'botao_donar' --line 2 --text 'ACCEDER WHATSAPP' --callback_data '1' --url "https://wa.me/$(cat < /etc/numctc)"

txt[0]='Ingresa tu IP: '
txt[1]='Ingresa el subdominio:'
txt[2]='Ingresa tu reseller:'

nws(){
unset bot_retorno
bot_retorno="$comando"
reply
}

# Ejecutando escucha del bot
while true; do
    ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
    for id in $(ShellBot.ListUpdates); do
	    chatuser="$(echo ${message_chat_id[$id]}|cut -d'-' -f2)"
	    [[ -z $chatuser ]] && chatuser="$(echo ${callback_query_from_id[$id]}|cut -d'-' -f2)"
	    echo $chatuser >&2
	    comando=(${message_text[$id]})
	    [[ -z $comando ]] && comando=(${callback_query_data[$id]})
	    #echo "comando $comando"
	    [[ "${chatuser}" == @('6234530051'|'6409531191') ]] && {
		permited="${chatuser}"
	    }
	   [[ -z $permited ]] && permited=$(cat ${CIDdir}/Admin-ID)

	if [[ $(echo $permited|grep "${chatuser}") = "" ]]; then
		 if [[ $(cat ${CIDdir}/User-ID|grep "${chatuser}") = "" ]]; then
			 case ${comando[0]} in
				 /[Ii]d|/[Ii]D)myid_src &;;
				 /[Mm]enu|[Mm]enu|/[Ss]tart|[Ss]tart|[Cc]omensar|/[Cc]omensar)menu_src &;;
				 /[Aa]yuda|[Aa]yuda|[Hh]elp|/[Hh]elp)ayuda_src &;;
				 /[Dd]onar|[Dd]onar)donar &;;
				 #/[Pp]rice|[Pp]price|[Pp]rices|/[Pp]rices)prices_on &;;
				 /sendid)send_ID;;
				 /chekid)send_ID;;
				 /upmake)dupdate2;;
				# /*|*)invalido_fun &;;
			 esac
		else

		    	if [[ ${message_reply_to_message_message_id[$id]} || ${message_reply_to_message_text[$id]} ]]; then
				case "${message_reply_to_message_text[$id]}" in
					#'Ingresa tu IP:'|"${txt[0]}")domain-IP "${txt[0]}" "${message_text[$id]}";;
					'Ingresa tu reseller:')ress --change ;;
					#'Ingrese su key:')checkey -p ;;
					#'Ingresa el subdominio:'|'Ingresa otro subdominio:')domain-IP "${txt[1]}";;
				esac



		 	elif [[ ${message_text[$id]} || ${callback_query_data[$id]} ]]; then
			 case ${comando[0]} in
				 /[Mm]enu|[Mm]enu|/[Ss]tart|[Ss]tart|[Cc]omensar|/[Cc]omensar)menu_src &;;
				 /[Aa]yuda|[Aa]yuda|[Hh]elp|/[Hh]elp)ayuda_src &;;
				 /[Kk]eylat|.[Kk]eylat|[.!?#*+/@][Kk]eylat)keyygen --latam &;;
				/[Dd]omain|[.@/+-_!?][Dd]omain)domain-IP&;;
				/createsubd)createsubd "${comando[1]}" "${comando[2]}" &;;
					/cres)ress "${comando[1]}" "${comando[2]}" &;;
					 /[Rr]ess|[Rr]ess)ress &;;
				/ippp)domain-IP -ip&;;
				 /[Ii]d|/[Ii]D)myid_src &;;
				 /[Ii]nstal)link_src &;;
				 /[Cc]hukk|.[Cc]hukk|[@!?!*.+-$]chukk)gerar_key &;;
			 esac
			fi
			sleep 5 
			[[ -e "/etc/donar_active.txt" ]] && donar
		 fi
	else

		    	if [[ ${message_reply_to_message_message_id[$id]} || ${message_reply_to_message_text[$id]} ]]; then
				case "${message_reply_to_message_text[$id]}" in
					'/del')deleteID_reply;; 
					'/add')addID_reply;; 
					'/addrev')addID_REV;; 
					'/buscar')searchID_reply;; 
					'/banIP')killIP_reply;;
					'Ingresa tu reseller:')ress --change ;;
					'Ingresa tu IP:'|"${txt[0]}")domain-IP "${txt[0]}" "${message_text[$id]}";;
					'Ingrese el id que desea eliminar:')delete-idd "${message_text[$id]}" ;;
					'Ingrese el id:')addrev "${message_text[$id]}";;
					'Ingrese su key:')checkey -p ;;
					'Ingresa el subdominio:'|'Ingresa otro subdominio:')domain-IP "${txt[1]}";;
				esac

			elif [[ ${message_document_file_id[$id]} ]]; then
					 download_file

		    	elif [[ ${message_text[$id]} || ${callback_query_data[$id]} ]]; then

		 		case ${comando[0]} in
					 /[Mm]enu|[Mm]enu|/[Ss]tart|[Ss]tart|[Cc]omensar|/[Cc]omensar)menu_src &;;					 /[Aa]yuda|[Aa]yuda|[Hh]elp|/[Hh]elp)ayuda_src &;;
					 /[Ii]d|/[Ii]D)myid_src &;;
					 /[Bb]an)ban &;;
					 /[Bb]anid)ban ${comando[1]} ${comando[2]} &;;
					 /[Kk]illid|[Kk]illid) dropID &;;
					 /[Cc]hat|[Ch]hat)msj_chat &;;
					 /[Ii]mg|[Ii]mg)reply &;;
					 /[Dd]el|/[Aa]dd)repply &;;
					/delete)delete-idd &;;
					 /[Aa]ddrev)repply&;;
					 /[Bb]uscar|[Bb]uscar)reply &;;
					 /[Rr]ess|[Rr]ess)ress &;;
					 /[Bb]anIP|[Bb]anIP)reply &;;
					 /[Cc]atip|[Cc]atip)list_IP &;;
					 /[Pp]ower)start_gen &;;
					 /[Cc]hukk|.[Cc]hukk|[.!?#*+/@][Cc]hukk)gerar_key &;;
					/cres)ress "${comando[1]}" "${comando[2]}" &;;
					/checK)checkey -k &;;
					/checkchukk)checkey -k &;;
					 #/[Kk]eygen)gerar_key &;;
					/[Dd]omain)domain-IP&;;
					/createsubd)createsubd "${comando[1]}" "${comando[2]}" &;;
					/ippp)domain-IP -ip &;;
			 		 /[Ll]ist)listID_src &;;
			 		 /[Ii]nfosys)infosys_src &;;
			 		 /[Ii]dgen|[Ii]dgen)listID_GEN &;;
					/[Ll]atam|/vpsmx)keyygen "$(echo ${comando[0]}|tr A-Z a-z|sed 's;/;--;g')" &;;
					 /[Tt]ools|[!+*-@?~¿][Tt]ools)tools &;;
					 /[Rr]eboot)reboot_src &;;
			 		 /[Ii]nstal)link_src &;;
					 /[Ll]og|[!?+-*@]log)keylog &;;
					 /checkey)keycheck &;;
			 		 /[Cc]ache)cache_src &;;
					 /[Uu]pdate|/[Aa]ctualizar)update &;;
					 /[Dd]onar|[Dd]onar)donar_OnOff &;;
					 /[Pp]rice|[Pp]price|[Pp]rices|/[Pp]rices)prices_on &;;
					 /upmake)dupdate2;;
			 		 #/*|*)invalido_fun &;;
				esac

			fi
	fi
    done
done
