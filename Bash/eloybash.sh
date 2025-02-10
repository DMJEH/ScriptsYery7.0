#!/bin/bash

# === FUNCIONES DEL MENÚ ===

factorial() {
    # Calcula el factorial de un número
    
    factorial=1
    for (( i=1; i<=$1; i++ )); do
        factorial=$((factorial * i))
    done
     # Imprime el factorial calculado
    echo "El factorial de $1 es: $factorial"
    echo ""
    submenu
}

bisiesto() {
    # Determina si un año es bisiesto
    
    if (( "$1" % "4" == 0 )) && (( "$1" % "100" != 0 )) || (( "$1" % "400" == 0 )); then
        echo "El año $1 es bisiesto"
    else
        echo "El año $1 no es bisiesto"
    fi
    echo ""
    submenu
}

red() {
    # Configura la red del sistema
    # Borro la carpeta del netplan para evitar errores de ip
    rm -r /etc/netplan/*
    echo "
network:
  ethernets:
    enp0s3:
      dhcp4: false
      addresses: [$1$2]
      gateway4: $4
      nameservers:
        addresses: [$3]
  version: 2
" > /etc/netplan/50-cloud-init.yaml
    # Aplica la configuración
    ip addr flush "enp0s3"
    sleep 5
    netplan apply > /dev/null 2>&1
    sleep 5
    echo "Aplicando la nueva configuración..."
    ip a
    echo ""
    submenu
}

adivina() {
     # Juego para adivinar un número aleatorio
    if [ -z "$numero" ]; then
        numero=$(( RANDOM % 100 + 1 ))
        intentos=0
        echo "Adivina el numero aleatorio"
    fi
    (( intentos++ ))
    read -p "Prueba con un numero: " entrada
    # Prueba de entrada
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

    echo "Has hecho un total de $intentos intentos"
    echo ""
    unset numero intentos
    submenu
}

edad() {

    #comparamos la edad en función del rango que abarque

    if [ "$1" -lt "3" ]; then
	    echo "niñez"
    elif [ "$1" -le "10" ] && [ "$1" -ge "3" ]; then
	    echo "infancia"
    elif [ "$1" -lt "18" ] && [ "$1" -gt "10" ]; then
    	echo "adolescencia"
    elif [ "$1" -lt "40" ] && [ "$1" -ge "18" ]; then
    	echo "juventud"
    elif [ "$1" -lt "65" ] && [ "$1" -ge "40" ]; then
    	echo "madurez"
    else
    	echo "vejez"
    fi
#volvemos a ejecutar el menu
echo ""
submenu
}

fichero() {
    # Obtenemos información del fichero
    if [ -f "$1" ]; then
        tamano=$(stat --format "%s" "$1")
        tipo=$(stat --format "%F" "$1")
        montaje=$(stat --format "%m" "$1")
        inodo=$(stat --format "%i" "$1")
        echo "
Información sobre el archivo
$1
----------------------------
Tamaño: $tamano
Tipo de archivo: $tipo
Lugar de montaje: $montaje
Inodo: $inodo
----------------------------"
    else
        echo "El archivo no existe o no es un archivo regular"
    fi
    # Mostramos el fichero o avisamos de que no existe
    echo ""
    submenu
}

buscar() {
    
    # Buscamos el archivo en el sistema
    hay=$(find / -type f -name "$1" 2>/dev/null)
    if [ -n "$hay" ]; then
        echo "El archivo se encuentra en $hay"
        vocales=$(grep -o -i '[aeiou]' "$hay" | wc -l)
        echo "Tiene $vocales vocales"
    else
        echo "El archivo no existe"
    fi
    echo ""
    submenu
}

contar() {
    # Contamos los fichero dentro del directorio si existe
    if [ ! -d "$1" ]; then
        echo "no existe el directorio"
        contar
    fi
    ficheros=$(ls -l "$1" | grep "^-" | wc -l)
    echo "el numero de ficheros en $1 es de $ficheros"
    echo ""
    submenu
}

privilegios() {
    # Mostramos los privilegios del usuario actual con clausuras para root
    usuario=$(whoami)
    echo "$usuario"
    if [ "$usuario" = "root" ]; then
        echo "eres root, obvio que puedes"
    elif groups "$usuario" | grep -q sudo; then
        echo "El usuario $usuario tiene privilegios administrativos"
    else
        echo "El usuario $usuario no tiene privilegios"
    fi
    echo ""
    submenu
}

octal() {
    # Mostramos los permisos del fichero
    if [ -e "$1" ]; then
        permisos=$(stat -c "%a" "$1")
        echo "Los permisos del fichero son: $permisos"
    else
        echo "El archivo no existe"
    fi
    echo ""
    submenu
}

romano() {
    # Calculamos el numero romano con dos arrays de valores
    if [[ $1 -gt 200 || $1 -lt 1 ]]; then
        echo "Introduce un número entre 1 y 200"
    else
        valores=(1000 900 500 400 100 90 50 40 10 9 5 4 1)
        simbolos=("M" "CM" "D" "CD" "C" "XC" "L" "XL" "X" "IX" "V" "IV" "I")
        romano=""
        for (( i=0; i<${#valores[@]}; i++ )); do
            while (( $1 >= valores[i] )); do
                romano+="${simbolos[i]}"
                (( $1 -= valores[i] ))
            done
        done
        echo "$romano"
    fi
    echo ""
    submenu
}

automatizar() {
    # Automatizamos la creacion de usuarios
    if [ -d "/mnt/usuarios" ] && [ "$(ls -A /mnt/usuarios)" ]; then
        for i in $(ls /mnt/usuarios); do
            sudo useradd -m -s /bin/bash "$i"
            if [ -f "$i" ]; then
                while IFS= read -r z; do
                    sudo mkdir "/home/$i/$z"
                done < "$i"
            fi
            sudo passwd "$i"
            sudo rm "/mnt/usuarios/$i"
        done
    else
        echo "El directorio está vacío o no existe"
    fi
    echo ""
    submenu
}

crear() {
    # Creamos archivos
    #Valores por defecto
    nombre=${1:-fichero_vacio}
    tamano=${2:-1024}
    
    dd if=/dev/zero of="$nombre" bs=1K count="$tamano" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "Se ha creado el fichero '$nombre' con tamaño de ${tamano}K"
    else
        echo "Error al crear el fichero"
    fi
    echo ""
    submenu
}

crear2() {

    
    nombre=${1:-fichero_vacio}
    tamano=${2:-1024}
    
    crear_fichero() {
        local nombre=$1
        dd if=/dev/zero of="$nombre" bs=1K count="$tamano" 2>/dev/null
        echo "Se ha creado el fichero '$nombre' con tamaño de ${tamano}K"
    }
    
    if [ -f "$nombre" ]; then
        echo "El fichero $nombre ya existe"
        for i in {1..9}; do
            nuevo_nombre="${nombre}${i}"
            if [ ! -f "$nuevo_nombre" ]; then
                crear_fichero "$nuevo_nombre"
                break
            fi
            if [ $i -eq 9 ]; then
                echo "Ya existen archivos desde $nombre hasta ${nombre}9"
            fi
        done
    else
        crear_fichero "$nombre"
    fi
    echo ""
    submenu
}

reescribir() {
    # Devolvemos una frase o palabra sustituyendo valores
    if [ -z "$1" ]; then
        read -p "Dame una palabra: " palabra
    else
        palabra="$1"
    fi
    echo "$palabra" | sed 'y/aeiou/12345/'
    echo ""
    submenu
}

contusu() {
    # Contamos el número de usuarios conectados
    if [ ! -d "/home/copiaseguridad" ]; then
        sudo mkdir -p /home/copiaseguridad
    fi
    
    usuarios=($(ls /home | grep -v "copiaseguridad"))
    num_usuarios=${#usuarios[@]}
    
    echo "El sistema tiene $num_usuarios usuarios reales"
    echo "Lista de usuarios:"
    for ((i=0; i<${#usuarios[@]}; i++)); do
        echo "$((i+1))) ${usuarios[i]}"
    done
    
    read -p "Seleccione un usuario (1-$num_usuarios): " seleccion
    
    if [[ ! "$seleccion" =~ ^[0-9]+$ ]] || [ "$seleccion" -lt 1 ] || [ "$seleccion" -gt "$num_usuarios" ]; then
        echo "Error: Selección no válida"
        return 1
    fi
    
    usuario_seleccionado=${usuarios[$((seleccion-1))]}
    fecha_actual=$(date +%Y%m%d)
    directorio_backup="/home/copiaseguridad/${usuario_seleccionado}_${fecha_actual}"
    
    echo "Realizando copia de seguridad para $usuario_seleccionado..."
    if sudo cp -r "/home/$usuario_seleccionado" "$directorio_backup"; then
        echo "Copia de seguridad completada en: $directorio_backup"
    else
        echo "Error al realizar la copia de seguridad"
    fi
    echo ""
    submenu
}

alumnos() {
    # Introducimos el numero de estudiantes para calcular las notas
    aprobados=0
    suspensos=0
    suma_notas=0
    
    for ((i=1; i<=num_alumnos; i++)); do
        read -p "Introduce la nota del alumno $i: " nota
        if (( $(echo "$nota >= 5" | bc -l) )); then
            ((aprobados++))
        else
            ((suspensos++))
        fi
        suma_notas=$(echo "$suma_notas + $nota" | bc -l)
    done
    
    nota_media=$(echo "scale=2; $suma_notas / $num_alumnos" | bc -l)
    echo "Número de aprobados: $aprobados"
    echo "Número de suspensos: $suspensos"
    echo "Nota media: $nota_media"
    echo ""
    submenu
}

quita_blancos() {
    # Elimina espacios en blanco de un string
    for file in *; do
        if [[ "$file" == *" "* ]]; then
            new_name=$(echo "$file" | tr ' ' '_')
            mv "$file" "$new_name"
            echo "Renombrado: $file -> $new_name"
        fi
    done
    echo ""
    submenu
}

lineas() {
    # Contamos las lineas de un archivo    
    if [ "$2" -lt 1 ] || [ "$2" -gt 60 ]; then
        echo "La longitud debe estar entre 1 y 60."
        return 1
    fi
    
    if [ "$3" -lt 1 ] || [ "$3" -gt 10 ]; then
        echo "El número de líneas debe estar entre 1 y 10."
        return 1
    fi
    
    for ((i=1; i<=2; i++)); do
        for ((j=1; j<=$2; j++)); do
            echo -n "$1"
        done
        echo ""
    done
    echo ""
    submenu
}

analizar() {
    # Analizamos el contenido de un directorio
    if [ ! -d "$1" ]; then
        echo "El directorio $1 no existe."
        return 1
    fi
    
    if [ ${#extensiones[@]} -eq 0 ]; then
        echo "Analizando todos los archivos en $1..."
        find "$1" -type f | awk -F. '{if (NF>1) {print $NF}}' | sort | uniq -c
    else
        for ext in "${extensiones[@]}"; do
            echo "Analizando archivos .$ext en $1..."
            find "$1" -type f -name "*.$ext" | wc -l
        done
    fi
    echo ""
    submenu
}

# === FUNCIÓN DE SALIDA ===

salir() {
    echo "Saliendo del programa..."
    exit 0
}

# === MENÚ PRINCIPAL ===

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
    echo "8) Contar"
    echo "9) Privilegios"
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
        1) 
            read -p "Introduce el número para calcular el factorial: " num
            factorial "$num" 
            ;;
        2) 
            read -p "Introduce el año a comprobar: " year
            bisiesto "$year" 
            ;;
        3) 
            read -p "Introduce IP: " ip
            read -p "Introduce máscara: " mask
            read -p "Introduce DNS: " dns
            read -p "Introduce gateway: " gw
            red "$ip" "$mask" "$dns" "$gw"
            ;;
        4) 
            adivina 
            ;;
        5) 
            read -p "Introduce la edad a evaluar: " age
            edad "$age"
            ;;
        6) 
            read -p "Introduce la ruta absoluta del fichero: " path
            fichero "$path"
            ;;
        7) 
            read -p "Introduce el nombre del archivo a buscar: " fname
            buscar "$fname"
            ;;
        8) 
            read -p "Introduce la ruta a analizar: " dir
            contar "$dir"
            ;;
        9) privilegios ;;
        10) 
            read -p "Introduce la ruta del fichero: " fpath
            octal "$fpath"
            ;;
        11) 
            read -p "Introduce el número a convertir: " num
            romano "$num"
            ;;
        12) automatizar ;;
        13) 
            read -p "Nombre del archivo: " fname
            read -p "Tamaño en KB: " size
            crear "$fname" "$size"
            ;;
        14) 
            read -p "Nombre del archivo: " fname
            read -p "Tamaño en KB: " size
            crear2 "$fname" "$size"
            ;;
        15)
            read -p "Introduce la palabra a reescribir: " word
            reescribir "$word"
            ;;
        16) contusu ;;
        17)  
            read -p "Introduce el número de alumnos: " num_alumnos
            alumnos
            ;;
        18) quita_blancos ;;
        19) 
            read -p "Introduce carácter: " char
            read -p "Introduce longitud (1-60): " length
            read -p "Introduce número de líneas (1-10): " lines
            lineas "$char" "$length" "$lines"
            ;;
        20) 
            read -p "Introduce directorio: " dir
            read -p "Introduce extensiones (separadas por espacio): " -a exts
            analizar "$dir" "${exts[@]}"
            ;;
        *) 
            echo "Opción inválida, intenta de nuevo"
            submenu 
            ;;
    esac
}

# Iniciar el menú
submenu