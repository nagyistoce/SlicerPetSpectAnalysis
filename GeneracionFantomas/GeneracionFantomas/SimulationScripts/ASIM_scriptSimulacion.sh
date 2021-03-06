SIMUL_DIR=/home/nayru/Programas/ASIM_development/Simul/bin
NOISE_DIR=/home/nayru/Programas/ASIM_development/Noise/bin
NORM_DIR=/home/nayru/Programas/ASIM_development/Normalize/bin
STIR_DIR=/usr/local/bin

DIR_CARPETA=`pwd`

while read LINE;
	do

   	 frame=$(echo $LINE | cut -d ',' -f 1)
   	 trues=$(echo $LINE | cut -d ',' -f 2)

    echo frame $frame trues $trues

#Output Directory#
OUTPUT_DIR=OutputN$frame
FILE_NAME=vascFantom$frame.yaff
echo File name $FILE_NAME
ActivityMap=vascFantom$frame
Rec_NAME=Frame$frame
mkdir $OUTPUT_DIR

echo $OUTPUT_DIR was created

cp 962 $OUTPUT_DIR
cp header.yhdr $OUTPUT_DIR
cp $FILE_NAME $OUTPUT_DIR
cp hdr_E_m962.hs $OUTPUT_DIR
cp FBP2D_962.par $OUTPUT_DIR
cp FBP3D.par $OUTPUT_DIR

cd $OUTPUT_DIR

sed -e s#ACTIVITY_FILE_NAME#${FILE_NAME}# \
       < header.yhdr > ${ActivityMap}.yhdr

sed -e s#RECSALIDA#${Rec_NAME}# \
       < FBP2D_962.par > FBP2D_962_M.par

sed -e s#RECSALIDA#${Rec_NAME}# \
       < FBP3D.par > FBP3D_M.par

#Simulate & reconstruct
$SIMUL_DIR/Simul -i $FILE_NAME -o EmSin.yaff -a -E -m 962 -k -p 6,6,g,0 -h -d 3
$SIMUL_DIR/Simul -i $FILE_NAME -o NormSin.yaff -N -m 962 -k -h
$NOISE_DIR/Noise -i EmSin.yaff -t $trues -o EmSin_n.yaff
$NORM_DIR/Normalize -i EmSin_n.yaff -n NormSin.yaff -k -o EmSin_n_norm.yaff
$STIR_DIR/FBP2D FBP2D_962_M.par

cd ../

done  < "TrueCounts_list";
