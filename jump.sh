
# args
JUMPER_HOME=`echo $JUMPER_HOME`

USER_NAME=""
PASSWD=""
IP=""
PORT=""

#functions
HANDLE_VAGUE_INPUT=""
function handle_vague_app(){
	row=`grep $HANDLE_VAGUE_INPUT $JUMPER_HOME/env.setting |wc -l`
	if [ $row -eq 0 ];
	then
		echo "[$HANDLE_VAGUE_INPUT] is not a correct app_name, please try again."
	else
		echo "More than 1 result found, Did you mean one of these?"	
		for app_name in `grep $HANDLE_VAGUE_INPUT $JUMPER_HOME/env.setting |awk '{print $1}'`
			do
				echo "	$app_name"
#cat $app_name |awk -F ' ' '{print $1}'
			done
	fi
		
	exit 1
}

function do_nothing(){
	echo " "
}

function syntax_hint(){
	echo "use follow syntax:"
	echo "		jump \${app_name}"
	echo "		eg: jump orderdish-shop-web"
}

#check input, eg: jump orderdish-shop-web 
if [ $# -ne 1 ];
then
	echo "wrong input!";
	syntax_hint
	exit 1;
fi


#get user_name, passwd, ip, port
JUMPER_HOME=`pwd`
if [ -f $JUMPER_HOME/env.setting ];
then
	do_nothing
else
	echo "$JUMPER_HOME/env.setting not exists!"
	exit 1;
fi

rows=`grep $1 $JUMPER_HOME/env.setting |wc -l`
if [ $rows -ne 1 ];
then
	HANDLE_VAGUE_INPUT=$1
	handle_vague_app
fi

#awk and filling
USER_NAME=`grep $1 $JUMPER_HOME/env.setting |awk -F ' ' '{print $3}'`
PASSWD=`grep $1 $JUMPER_HOME/env.setting |awk -F ' ' '{print $4}'`
IP=`grep $1 $JUMPER_HOME/env.setting |awk -F ' ' '{print $2}'`
PORT=`grep $1 $JUMPER_HOME/env.setting |awk -F ' ' '{print $5}'`

CMD="spawn ssh $USER_NAME@$IP -p $PORT"

#build expect file
echo "#!/usr/bin/expect" > $JUMPER_HOME/expect.sh
echo "set timeout 30" >> $JUMPER_HOME/expect.sh
echo "set passwd $PASSWD" >> $JUMPER_HOME/expect.sh
echo "$CMD" >> $JUMPER_HOME/expect.sh
echo "expect {" >> $JUMPER_HOME/expect.sh
echo "\"yes/no\" {send \"yes\r\"; exp_continue}" >> $JUMPER_HOME/expect.sh
echo "\"password\" {send \"\$passwd\r\"}" >> $JUMPER_HOME/expect.sh
echo "}" >> $JUMPER_HOME/expect.sh
echo "interact" >> $JUMPER_HOME/expect.sh

chmod +x $JUMPER_HOME/expect.sh

#do exec
/usr/bin/expect  $JUMPER_HOME/expect.sh
