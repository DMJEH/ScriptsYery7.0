#!/bin/bash

# Funciones que se llamarán desde el menú
factorial() {

    factorial=1
    read -p "Dame un numero para calcular su factorial: " numero

    for (( i=1; i<=numero; i++ )); do
        factorial=$((factorial * i))
    done

    echo "El factorial de $numero es: $factorial"
    echo ""
    submenu


}

bisiesto() {

    read -p "dime el año que quieras saber: " ano

    if (( "$ano" % "4" == 0 )) && (( "$ano" % "100" != 0 )) || (( "$ano" % "400" == 0 )); then
	echo "El año $ano es bisiesto"
    else
	echo "El año $ano no es bisiesto"
    fi


    echo ""
    submenu
}


red() {

    echo "Procederemos con la configuración de red"

    read -p "Dime la dirección IP que quieres asignar: (x.x.x.x) " ip
    read -p "Dime la máscara de red que usarás: (/x) " mascara
    read -p "Dime los DNS que usaremos (x.x.x.x, x.x.x.x): " dns
    read -p "Dime la gateway: (x.x.x.x): " gateway

rm -r /etc/netplan/*

echo "
network:
  ethernets:
    enp0s3:
      dhcp4: false
      addresses: [$ip$mascara]
      gateway4: $gateway
      nameservers:
        addresses: [$dns]
  version: 2
" > /etc/netplan/50-cloud-init.yaml

ip addr flush "enp0s3"
sleep 5
netplan apply > /dev/null 2>&1
# echo "nameserver $dns" > /etc/resolv.conf
sleep 5
echo "Aplicando la nueva configuración..."
ip a

echo ""
submenu

}

adivina() {
#comprobamos que el numero secreto no tiene valor, si tiene algun valor omite este if
if [ -z "$numero" ]; then
numero=$(( RANDOM % 100 + 1 ))
intentos=0
echo "Adivina el numero aleatorio"
fi
#suma intentos y pide un nuevo numero
(( intentos++ ))
read -p "Prueba con un numero: " entrada

#compara el numero ingresado
if [ "$entrada" -eq "$numero" ]; then
	echo "Ganaste, en numero secreto era: $numero"
elif [ "$entrada" -gt "$numero" ]; then
	echo "El numero ingresado es más grande que el secreto"
	adivina
elif [ "$entrada" -lt "$numero" ]; then
	echo "El numero ingresado es más pequeño que el secreto"
	adivina
else
	echo "Algo va mal"
fi

#fin del adivina
echo "Has hecho un total de $intentos intentos"
echo ""
unset numero intentos
submenu

}

edad() {
# obtenemos la edad
read -p "Dime tu edad: " edad
#comparamos la edad en función del rango que abarque

if [ "$edad" -lt "3" ]; then
	echo "niñez"
elif [ "$edad" -le "10" ] && [ "$edad" -ge "3" ]; then
	echo "infancia"
elif [ "$edad" -lt "18" ] && [ "$edad" -gt "10" ]; then
	echo "adolescencia"
elif [ "$edad" -lt "40" ] && [ "$edad" -ge "18" ]; then
	echo "juventud"
elif [ "$edad" -lt "65" ] && [ "$edad" -ge "40" ]; then
	echo "madurez"
else
	echo "vejez"
fi
#volvemos a ejecutar el menu
echo ""
submenu
}

fichero() {

read -p "Dame la ruta absoluta del fichero del que quieres obtener información: " fichero

tamano=$(stat --format "%s" $fichero)
tipo=$(stat --format "%F" $fichero)
montaje=$(stat --format "%m" $fichero)
inodo=$(stat --format "%i" $fichero)

echo "
Información sobre el archivo
$fichero
----------------------------
Tamaño: $tamano
Tipo de archivo: $tipo
Lugar de montaje: $montaje
Inodo: $inodo
----------------------------"

echo ""
submenu
}

buscar() {

read -p "Dime el fichero que quieres buscar: " archivo

hay=$(find / -type f -name $archivo 2>/dev/null)
if [ -e "$hay" ]; then
	echo "El archivo se encuentra en $hay"
	vocales=$(grep -o -i '[aeiou]' $archivo | wc -l)
	echo "Tiene $vocales vocales"
else
	echo "El archivo no existe"
fi

echo ""
submenu
}

contar() {

read -p "Dime la ruta de archivos que quieres contar: " ruta

if [ ! -d "$ruta" ]; then
	echo "no existe el directorio"
	contar
fi

ficheros=$( ls -l $ruta | grep "^-" | wc -l)
echo "el numero de ficheros en $ruta es de $ficheros"

echo ""
submenu
}

privilegios() {

usuario=$(whoami)
echo $usuario

if [ "$usuario" = "root" ]; then
	echo "eres root, obvio que puedes"
elif groups $usuario | grep -q sudo; then
	echo "El usuario $usuario tiene privilegios administrativos"
else
	echo "El usuario $usuario no tiene privilegios"
fi


echo ""
submenu
}

octal() {

read -p "Dime la ruta absoluta del fichero del que quieres obtener los permisos: " fichero

permisos=$(stat -c "%a" $fichero)

echo "Los permisos del fichero son: $permisos"

echo ""
submenu
}

romano() {

read -p "Introduce un número: " numero
   local romano=""
if [[ $numero -gt 200 || $numero -lt 1 ]]; then

   echo "Introduce un número entre 1 y 200"
else
   # Arrays de valores y símbolos romanos
   valores=(1000 900 500 400 100 90 50 40 10 9 5 4 1)
   simbolos=("M" "CM" "D" "CD" "C" "XC" "L" "XL" "X" "IX" "V" "IV" "I")

   for (( i=0; i<${#valores[@]}; i++ )); do
       while (( numero >= valores[i] )); do
           romano+="${simbolos[i]}"
           (( numero -= valores[i] ))
       done
   done

   echo "$romano"
fi

echo ""
submenu
}

automatizar() {

if [ $(ls /mnt/usuarios) ]; then

	for i in $(ls /mnt/usuarios); do
		sudo useradd -m -s /bin/bash $i
			for z in $(cat $i); do
				sudo mkdir /home/$i/$z
			done
		sudo passwd $i
		sudo rm /mnt/usuarios/$i
	done
else
	echo "El directorio esta vacío"
fi

echo ""
submenu
}

crear() {

# Establecer valores por defecto
nombre="fichero_vacio"
tamaño=1024

# Comprobar los parámetros pasados
if [ $# -ge 1 ]; then
    nombre=$1
fi

if [ $# -ge 2 ]; then
    tamaño=$2
fi

# Crear el fichero con el tamaño especificado
dd if=/dev/zero of=$nombre bs=1K count=$tamaño 2>/dev/null

# Verificar si se creó correctamente
if [ $? -eq 0 ]; then
    echo "Se ha creado el fichero '$nombre' con tamaño de ${tamaño}K"
else
    echo "Error al crear el fichero"
fi

echo ""
submenu
}

crear2() {

# Establecer valores por defecto
   local nombre="fichero_vacio"  # local para que la variable sea local a la función
   local tamaño=1024

   # Comprobar los parámetros pasados
   if [ $# -ge 1 ]; then
       nombre=$1
   fi

   if [ $# -ge 2 ]; then
       tamaño=$2
   fi

   # Función interna para crear el fichero
   crear_fichero() {
       local nombre=$1
       dd if=/dev/zero of=$nombre bs=1K count=$tamaño 2>/dev/null
       echo "Se ha creado el fichero '$nombre' con tamaño de ${tamaño}K"
   }

   # Comprobar si existe el fichero original
   if [ -f "$nombre" ]; then
       echo "El fichero $nombre ya existe"

       # Probar con números del 1 al 9
       for i in {1..9}; do
           local nuevo_nombre="${nombre}${i}"

           if [ ! -f "$nuevo_nombre" ]; then
               crear_fichero "$nuevo_nombre"
               return 0
           fi
       done

       echo "Ya existen archivos desde $nombre hasta ${nombre}9. No se creará ningún archivo."
   else
       crear_fichero "$nombre"
   fi

	echo ""
submenu
}

reescribir() {

echo "$1" | sed 'y/aeiou/12345/'

echo ""
submenu
}

contusu() {

# Comprobar si existe el directorio de copias de seguridad
    if [ ! -d "/home/copiaseguridad" ]; then
        sudo mkdir -p /home/copiaseguridad
    fi

    # Obtener lista de usuarios con directorio en /home
    usuarios=($(ls /home | grep -v "copiaseguridad"))
    num_usuarios=${#usuarios[@]}

    # Mostrar número de usuarios
    echo "El sistema tiene $num_usuarios usuarios reales"
    echo "Lista de usuarios:"

    # Mostrar lista numerada de usuarios
    for ((i=0; i<${#usuarios[@]}; i++)); do
        echo "$((i+1))) ${usuarios[i]}"
    done

    # Pedir selección de usuario
    read -p "Seleccione un usuario (1-$num_usuarios): " seleccion

    # Validar entrada
    if [[ ! "$seleccion" =~ ^[0-9]+$ ]] || [ "$seleccion" -lt 1 ] || [ "$seleccion" -gt "$num_usuarios" ]; then
        echo "Error: Selección no válida"
        return 1
    fi

    # Obtener usuario seleccionado
    usuario_seleccionado=${usuarios[$((seleccion-1))]}

    # Obtener fecha actual en formato YYYYMMDD
    fecha_actual=$(date +%Y%m%d)

    # Crear nombre del directorio de backup
    directorio_backup="/home/copiaseguridad/${usuario_seleccionado}_${fecha_actual}"

    # Realizar la copia de seguridad
    echo "Realizando copia de seguridad para $usuario_seleccionado..."
    if sudo cp -r /home/$usuario_seleccionado $directorio_backup; then
        echo "Copia de seguridad completada en: $directorio_backup"
    else
        echo "Error al realizar la copia de seguridad"
        return 1
    fi

echo ""
submenu
}

alumnos() {

# Pide el número de alumnos
read -p "Introduce el número de alumnos: " num_alumnos

# Inicializa variables
aprobados=0
suspensos=0
suma_notas=0

# Bucle para pedir las notas de cada alumno
for ((i=1; i<=num_alumnos; i++))
do
    read -p "Introduce la nota del alumno $i: " nota
    if (( $(echo "$nota >= 5" | bc -l) )); then
        aprobados=$((aprobados + 1))
    else
        suspensos=$((suspensos + 1))
    fi
    suma_notas=$(echo "$suma_notas + $nota" | bc -l)
done

# Calcula la nota media
nota_media=$(echo "scale=2; $suma_notas / $num_alumnos" | bc -l)

# Muestra los resultados
echo "Número de aprobados: $aprobados"
echo "Número de suspensos: $suspensos"
echo "Nota media: $nota_media"

echo ""
submenu
}

quita_blancos() {

# Recorre todos los archivos en el directorio actual
for file in *; do
    # Verifica si el nombre del archivo contiene espacios
    if [[ "$file" == *" "* ]]; then
        # Reemplaza los espacios por guiones bajos
        new_name=$(echo "$file" | tr ' ' '_')
        # Renombra el archivo
        mv "$file" "$new_name"
        echo "Renombrado: $file -> $new_name"
    fi
done

echo ""
submenu
}


lineas() {

# Verifica que se hayan pasado los tres parámetros
if [ $# -ne 3 ]; then
    echo "Uso: $0 <carácter> <número entre 1 y 60> <número entre 1 y 10>"
    exit 1
fi

# Asigna los parámetros a variables
caracter=$1
longitud=$2
lineas=$3

# Verifica que los números estén dentro de los límites
if [ $longitud -lt 1 ] || [ $longitud -gt 60 ]; then
    echo "El segundo parámetro debe estar entre 1 y 60."
    exit 1
fi

if [ $lineas -lt 1 ] || [ $lineas -gt 10 ]; then
    echo "El tercer parámetro debe estar entre 1 y 10."
    exit 1
fi

# Dibuja las líneas
for ((i=1; i<=lineas; i++))
do
    for ((j=1; j<=longitud; j++))
    do
        echo -n "$caracter"
    done
    echo ""
done

echo ""
submenu
}

analizar() {

# Verifica que se haya pasado al menos un parámetro (el directorio)
if [ $# -lt 1 ]; then
    echo "Uso: $0 <directorio> [extensiones...]"
    exit 1
fi

# Asigna el directorio a una variable
directorio=$1

# Verifica que el directorio exista
if [ ! -d "$directorio" ]; then
    echo "El directorio $directorio no existe."
    exit 1
fi

# Inicializa un array con las extensiones a analizar
extensiones=("${@:2}")

# Si no se pasaron extensiones, analiza todos los archivos
if [ ${#extensiones[@]} -eq 0 ]; then
    echo "Analizando todos los archivos en $directorio..."
    find "$directorio" -type f | awk -F. '{if (NF>1) {print $NF}}' | sort | uniq -c
else
    # Analiza solo las extensiones especificadas
    for ext in "${extensiones[@]}"; do
        echo "Analizando archivos .$ext en $directorio..."
        find "$directorio" -type f -name "*.$ext" | wc -l
    done
fi

echo ""
submenu
}


salir() {
    echo "Saliendo del programa..."
    exit 0
}

# Función del menú
submenu() {
    echo "---------------------------------"
    echo "        MENÚ PRINCIPAL"
    echo "---------------------------------"
    echo "0) Salir"
    echo "1) Factorial"
    echo "2) Bisiesto"
    echo "3) Configuración de red"
    echo "4) Adivina"
    echo "5) Edad"
    echo "6) Fichero"
    echo "7) Buscar"
    echo "8) contar"
    echo "9) privilegios"
    echo "10) Permiso en octal"
    echo "11) Romano"
    echo "12) Automatizar"
    echo "13) Crear"
    echo "14) Crear 2"
    echo "15) Reescribir"
    echo "16) Usuarios Reales"
    echo "17) Alumnos"
    echo "18) Quita Blancos"
    echo "19) Lineas"
    echo "20) Analizar"
    echo "---------------------------------"

    read -p "Selecciona una opción: " opcion

    case $opcion in
	0) salir ;;
        1) factorial ;;
        2) bisiesto ;;
        3) red ;;
	4) adivina ;;
	5) edad ;;
	6) fichero ;;
	7) buscar ;;
	8) contar ;;
	9) privilegios ;;
	10) octal ;;
	11) romano ;;
	12) automatizar ;;
	13) crear ;;
	14) crear2 ;;
	15)
		 read -p "Dame una palabra: " palabra
		 reescribir "$palabra"
		;;
	16) contusu ;;
	17) alumnos ;;
	18) quita_blancos ;;
	19) lineas ;;
	20) analizar ;;

        *) echo "Opción inválida, intenta de nuevo"; submenu ;;
    esac
}

# Llamar al menú por primera vez
submenu
