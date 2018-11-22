#!/usr/bin/perl

#indicamos las librerías que vamos a usar
use strict;
use warnings;
use Getopt::Long;

#inicializamos las variables
my $fichero;
my $contadorProteinas=0;
my $sumatorioAA=0;
my $linea;
my @datos;
my $sumaCuadrados = 0;

#indicamos los argumentos de la llamada
GetOptions(
	"fichero=s"=>\$fichero,
);

#Llamamos a la función recuperando los dos valores de interés
my($mean,$desviacion)=calcularMedia();

#Imprimimos por pantalla los valores
print "La media de aa por proteína es ".sprintf("%.2f", $mean)." \n";
print "La desviacion estandar es ".sprintf("%.2f", $desviacion)." \n";

#Definimos la función del cálculo de la media
sub calcularMedia{
	open(INFILE,$fichero) || die "No encuentro el fichero proteinas.txt";

	while($linea=<INFILE>){
		chomp $linea;
		@datos=split(/\t/,$linea);
		$sumatorioAA=$sumatorioAA+$datos[1];
		$contadorProteinas++;
	}
	my $media = $sumatorioAA/$contadorProteinas;
	#Llamamos a una función anidada
	my $desviacion = calcularDesviacion($media,$contadorProteinas,$fichero);
	return ($media,$desviacion);
}

#Definimos la función del cálculo de la desviación estándar
sub calcularDesviacion{
	open(INFILE,$_[2]) || die "No encuentro el fichero proteinas.txt";
	while($linea=<INFILE>){
		chomp $linea;
		@datos=split(/\t/,$linea);
		$sumaCuadrados += ($_[0]-$datos[1]) ** 2;
	}
	my $desviacionEstandar = ($sumaCuadrados / ($_[1]-1)) ** 0.5;
	return $desviacionEstandar;
}








