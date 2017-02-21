
# args
JUMPER_HOME=`echo $JUMPER_HOME`

USER_NAME=""
PASSWD=""
IP=""
PORT=""

#functions
HANDLE_VAGUE_INPUT=""
function handle_vague_app(){
	echo "$HANDLE_VAGUE_INPUT is not correct, please try again."
	exit 1
}

function do_nothing(){
	echo " "
}

#check input, eg: jump orderdish-shop-web 
if [ $# -ne 1 ];
then
	echo "wrong input!";
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
echo "expect password" >> $JUMPER_HOME/expect.sh
echo "send \"\$passwd\\r\"" >> $JUMPER_HOME/expect.sh
echo "interact" >> $JUMPER_HOME/expect.sh

chmod +x $JUMPER_HOME/expect.sh

#do exec
/usr/bin/expect  $JUMPER_HOME/expect.sh