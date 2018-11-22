#!/usr/bin/perl
#Abrimos la conexión con el fichero de entrada y creamos el fichero de salida. 
open(INFILE,"proteinas.txt") || die "No encuentro el fichero proteinas.txt";
open(SALIDA,">resultado_proteinas.txt") || die "No puedo crear el fichero resultado_proteinas.txt";

#Iniciamos algunas de las variables que nos hacen falta como flags o contadores
$contadorProteinas=0;
$contadorProteinasMenores=0;
$concatenarAminoacidos=false;
$contadorAminoacidos=0;
@proteinas;


#Bucle que lee cada linea del fichero
while($linea=<INFILE>){
	chomp $linea;

	#Vamos guardando los IDs de las proteínas en una lista. 
	if($linea=~/^ID/){
		@datos=split(/\b/,$linea);
		push @proteinas, $datos[2];
		$contadorProteinas++;
		$contadorAminoacidos=0;
	}

	#Vamos sacando las secuencias de aminoacidos
	if($linea=~/^\s/){
		$concatenarAminoacidos=true;
		#Quitamos los espacios de las secuencias
		$linea =~ s/\s+//g;
		$contadorAminoacidos+=length($linea);
	}elsif($linea=~/^\/\//){
		#Cuando terminamos de evaluar una secuencia, si es menor o igual de 50aa, metemos la cantidad de aa en un hash con clave
		#la posición del array de los IDs +1
		if($contadorAminoacidos<=50){
			$proteinasMenores{$contadorProteinas}=$contadorAminoacidos;
			$contadorProteinasMenores++;
		}
		$concatenarAminoacidos=false;
		$contadorAminoacidos=0;
	}
}

#Rellenamos el archivo de salida
foreach my $llave (keys %proteinasMenores){
print SALIDA "$proteinas[$llave-1]\t$proteinasMenores{$llave}\n";
} 

#Sacamos por las salidas indicadas en el enunciado los datos solicitados
print STDERR "El archivo contiene un total de $contadorProteinas proteínas\n";
print STDOUT "De las cuales $contadorProteinasMenores tienen 50 o menos aminoacidos\n";

#Cerramos las conexiones
close INFILE;
close SALIDA;