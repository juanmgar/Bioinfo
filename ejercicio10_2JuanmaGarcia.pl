#!/usr/bin/perl

#indicamos las librerías que vamos a usar
use strict;
use warnings;
use Bio::SeqIO;
use Getopt::Long;

#inicializamos las variables
my $izquierda;
my $derecha;
my $fichero;

#indicamos los argumentos de la llamada
GetOptions(
	"cinco=i"=>\$izquierda,
	"tres=i"=>\$derecha,
	"fichero=s"=>\$fichero
);

#Controlamos e informamos los argumentos pasados
if($izquierda<0 || $derecha<0){
	print "\n¡¡¡El número de nucleótidos en los extremos debe ser mayor que cero!!!\n";
	print "Llama al programa así: perl programa.pl -cinco n -tres m -fichero xxx.fa\n";
	exit;
}elsif($izquierda == ""){
	print "\n¡¡¡Debes de informar un número de nuecleotidos a recortar a cada extremo!!!\n";
	print "Llama al programa así: perl programa.pl -cinco n -tres m -fichero xxx.fa\n";
	exit;
}elsif($fichero eq ""){
	print "\n¡¡¡Debes aportar un nombre de fichero!!!\n";
	print "Llama al programa así: perl programa.pl -cinco n -tres m -fichero xxx.fa\n";
	exit;
}

#abrimos la conexión con el fichero de salida
open(SALIDA,">resultados.fa") || die "No puedo crear el fichero resultados.fa";

#leemos nuestro fichero fasta de entrada con Bioperl
my $seqio = Bio::SeqIO->new(-format=>"fasta", -file=>$fichero);

#Vamos recorriendo el fichero imprimiendo por consola y en el fichero de salida
while(my $seq = $seqio->next_seq) {
  	print "Gen con ID ".$seq->display_id() ."\n";
  	print SALIDA ">".$seq->display_id()."\n";
  	my $secuencia=$seq->seq();
  	my $inicial=length($secuencia);
  	print "Tamaño antes de recortar: ".length($secuencia)."\n";

  	#eliminamos los nuecleotidos indicados por la izquierda
  	for(my $i=0; $i <= $izquierda-1; $i++){
		if(substr($secuencia,0,1)eq"N"){
			$secuencia=substr($secuencia,1,length($secuencia));
		}
	}

  	#eliminamos los nuecleotidos indicados por la derecha
	for(my $i=$derecha-1; $i >= 0; $i--){
		if(substr($secuencia,length($secuencia)-1,1)eq"N"){
			$secuencia=substr($secuencia,0,-1);
		}
	}
	print SALIDA $secuencia."\n";
	my $final=length($secuencia);

	#pintamos los datos indicados en el enunciado
	my $diferencia=$inicial-$final;
	print "Tamaño después de recortar: ".length($secuencia)."\n";
	print "La diferencia es de $diferencia\n";

}

print "Las secuencias resultantes se han guardado en el fichero resultados.fa\n";

#cerramos la conexión
close(SALIDA);
