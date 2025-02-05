# -*- coding: utf-8 -*-
"""SP 7.0 Scripting en Python.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1AfsMLifrDTtlb7Pptw04J4P9Po-Mbky6

1.   Dos motos viajan a diferentes velocidades (**vel1** y **vel2**) y están distanciados por una distancia **dis**. La moto que se encuentra detrás lleva una velocidad mayor que la primera. Se pide realizar un script en python que solicite al usuario la distancia entre las motos en km y las velocidades de las mismas y con ello devolver en cuanto tiempo la moto 2 alcanzará a la moto 1.
"""

#Pedimos los datos
velocidad1 = int(input("Velocidad de la primera moto?"))
velocidad2 = int(input("Velocidad de la segunda moto?"))
distancia = int(input("Distancia entre las motos"))

# Calculamos medidas de tiempo
tiempo = distancia / (velocidad2 - velocidad1)

horas = int(tiempo)
minutos = int((tiempo - horas) * 60)

 # Mostrar el resultado
print(f"La moto 2 alcanzará a la moto 1 en {horas} horas y {minutos} minutos")

"""2. El tutor de 2º ASIR esta organizando un viaje a Granada, y requiere determinar cuánto debe cobrar a cada alumne y cuánto debe pagar a la agencia de viajes. La forma de cobrar es la siguiente: si son 100 alumnos o más, el costo por cada alumno es de 65 euros; de 50 a 99 alumnos, el costo es de 70 euros, de 30 a 49, de 95 euros, y si son menos de 30, el costo de la guagua es de 4000 euros, sin importar el número de alumnos. Realice un script que permita determinar el pago a la compañía de guaguas y lo que debe pagar cada alumno por el viaje."""

#Ingresamos el numero de alumnos
alumnos = int(input("Ingrese la cantidad de alumnos: "))

# Hacemos el if, que irá pasando de uno a otro en función de los alumnos
if alumnos >= 100:
  print("Cada alumno deberá pagar 65€")
elif alumnos < 100 and alumnos >= 50:
  print(f"Cada alumno deberá pagar 70€")
elif alumnos < 50 and alumnos >=30:
  print("Cada alumno deberá pagar 95€")
else:
  print(f"El coste de la guagua es de 4000 euros y cada alumno debe pagar {4000/alumnos}€")

# Por último, se divide el coste entre el numero de alumnos

"""3. Crea un script que permita adivinar un número. La aplicación genera un número aleatorio del 1 al 100. A continuación va pidiendo números y va respondiendo si el número a adivinar es mayor o menor que el introducido, además de los intentos que te quedan (tienes 10 intentos para acertarlo).  El programa termina cuando se acierta el número (además te dice en cuantos  intentos lo has acertado), si se llega al limite de intentos te muestra el  número que había generado."""

# Usamos una librería para randomizar un número y ponemos el numero de
import random

numero_secreto = random.randint(1, 100)
intentos = 0

# Pedimos al usuario y número y creamos las posibilidades
print("Adivina el número entre 1 y 100. Tienes 10 intentos.")

# Creamos un bucle para que itere con el usuario el máximo numero de intentos
while intentos < 10:
    intentos = intentos + 1
    numero = int(input("Introduce un número: "))

    if numero == numero_secreto:
        print(f"¡Felicidades! Adivinaste el número en {intentos} intentos.")
        break
    elif numero < numero_secreto:
        print("El número secreto es mayor.")
    else:
        print("El número secreto es menor.")


# Si llega a 10 intentos el usuario pierde
if intentos == 10:
    print(f"Te quedaste sin intentos. El número era {numero_secreto}.")

"""4. Realizar un script que pida una String por teclado que contenga espacios y devuelva el número de palabrás que contenga"""

# Solicitar que ingrese una cadena de texto
cadena = input("Ingrese una cadena de texto que contenga espacios: ")

# Dividir la cadena en palabras
palabras = cadena.split()

# Contar número de palabras
numero_palabras = len(palabras)

# Mostrar numero de palabras
print(f"El número de palabras en la cadena es: {numero_palabras}")

"""5. Realiza un script que se le pasen 5 notas de un alumno por teclado (comprendidas entre 0 y 10). A continuación debe mostrar todas las notas, la nota media, la nota más alta que ha sacado y la menor.


"""

# Creamos una lista
notas = []

# Pedir 5 notas entre 0 y 10
for i in range(5):
    nota = int(input(f"Introduce la nota {i+1}: "))
    if 0 <= nota <= 10:
        notas.append(nota)
        break
    else:
        print("Error: La nota debe estar entre 0 y 10")

# Mostrar resultados
print("\nTodas las notas:", notas)
print("Nota media:", sum(notas)/len(notas))
print("Nota más alta:", max(notas))
print("Nota más baja:", min(notas))

"""\6. Realizar un script que cree una una tabla bidimensional de 5x5 y nombre 'diagonal'. La Componentes de la tabla en su diagonales deben de ser 1 y el resto 0. Se ha de mostrar el contenido de la tabla por pantalla."""

# Crear tabla 5x5
diagonal = []
for i in range(5):
    fila = []
    for j in range(5):
        if i == j:
            fila.append(1)
        else:
            fila.append(0)
    diagonal.append(fila)

# Mostrar la tabla
for fila in diagonal:
    print(fila)

"""7. Crea un script que pida un número y cree un diccionario cuyas claves sean desde el número 1 hasta el número indicado, y los valores sean los cuadrados de las claves.


"""

# Pedir un número al usuario
num = int(input("Introduce un número: "))

# Crear el diccionario con claves del 1 al num y valores como su cuadrado
diccionario = {i: i**2 for i in range(1, num + 1)}

# Mostrar el diccionario
print(diccionario)

"""8. Crea un script de una agenda en la que se guardan nombres y números de teléfono. En la agenda existirá un menú con las siguientes opciones:
 * **Añadir/modificar**: Nos pide un nombre. Si el nombre se encuentra en la agenda, debe mostrar el teléfono y, opcionalmente, permitir modificarlo si no es correcto. Si el nombre no se encuentra, debe permitir ingresar el teléfono correspondiente.
 * **Buscar**: Nos pide una cadena de caracteres, y nos muestras todos los contactos cuyos nombres comiencen por dicha cadena.
 * **Borrar**: Nos pide un nombre y si existe nos preguntará si queremos borrarlo de la agenda.
 * **Listar**: Nos muestra todos los contactos de la agenda.

  Implementar el script con un diccionario.
"""

# Definimos la agenda como un diccionario vacío para almacenar los contactos
agenda = {}

def mostrar_menu():
   # Función que muestra el menú principal con las opciones disponibles
   print("\n--- Agenda Telefónica ---")
   print("1. Añadir/Modificar contacto")
   print("2. Buscar contacto")
   print("3. Borrar contacto")
   print("4. Listar contactos")
   print("5. Salir")

def añadir_modificar_contacto():
   # Función para añadir un nuevo contacto o modificar uno existente
   nombre = input("Introduce el nombre del contacto: ")
   if nombre in agenda:  # Verifica si el contacto ya existe
       print(f"El número actual de {nombre} es: {agenda[nombre]}")
       modificar = input("¿Deseas modificarlo? (s/n): ").lower()
       if modificar == 's':  # Si desea modificar, actualiza el número
           telefono = input("Introduce el nuevo número de teléfono: ")
           agenda[nombre] = telefono
           print("Contacto modificado correctamente.")
   else:  # Si el contacto no existe, lo añade
       telefono = input("Introduce el número de teléfono: ")
       agenda[nombre] = telefono
       print("Contacto añadido correctamente.")

def buscar_contacto():
   # Función para buscar contactos que empiecen por una cadena específica
   cadena = input("Introduce la cadena de búsqueda: ")
   # Crea un diccionario con los contactos que coinciden con la búsqueda
   encontrados = {nombre: telefono for nombre, telefono in agenda.items() if nombre.startswith(cadena)}
   if encontrados:  # Si se encuentran contactos, los muestra
       print("\nContactos encontrados:")
       for nombre, telefono in encontrados.items():
           print(f"{nombre}: {telefono}")
   else:
       print("No se encontraron contactos que coincidan con la búsqueda.")

def borrar_contacto():
   # Función para eliminar un contacto de la agenda
   nombre = input("Introduce el nombre del contacto a borrar: ")
   if nombre in agenda:  # Verifica si el contacto existe
       confirmar = input(f"¿Estás seguro de borrar a {nombre}? (s/n): ").lower()
       if confirmar == 's':  # Confirma antes de borrar
           del agenda[nombre]
           print("Contacto borrado correctamente.")
   else:
       print("El contacto no existe en la agenda.")

def listar_contactos():
   # Función para mostrar todos los contactos de la agenda
   if agenda:  # Verifica si hay contactos en la agenda
       print("\nLista de contactos:")
       for nombre, telefono in agenda.items():
           print(f"{nombre}: {telefono}")
   else:
       print("La agenda está vacía.")

def main():
   # Función principal que ejecuta el programa
   opcion = 0
   while opcion != 5:
       mostrar_menu()
       opcion = input("Selecciona una opción (1-5): ")

       # Maneja la selección del usuario
       if opcion == '1':
           añadir_modificar_contacto()
       elif opcion == '2':
           buscar_contacto()
       elif opcion == '3':
           borrar_contacto()
       elif opcion == '4':
           listar_contactos()
       elif opcion == '5':
           print("Saliendo de la agenda...")
           break  # Sale del bucle y termina el programa
       else:
           print("Opción no válida. Inténtalo de nuevo.")

# Verifica si el script se está ejecutando directamente
if __name__ == "__main__":
   main()  # Inicia el programa

"""9. Crear un script que al introducir una fecha nos diga a que día juliano corresponde. El día juliano correspondiente a una fecha es un número entero que indica los días que han transcurrido desde el 1 de enero.Para ello debes de hacer las siguientes funciones:
 * **LeerFecha**: Lee por teclado el día, mes y el año.
 * **DiasDelMes**: Recibe un mes y un año y devuelve el número de días
 * **EsBisiesto**: Recibido un año nos dice si es bisiesto o no.
 * **Calcular_Dia_Juliano**: Recibe una fecha y nos devuelve el día juliano.
"""

def leer_fecha():
    """Lee el día, mes y año desde el teclado."""
    dia = int(input("Introduce el día: "))
    mes = int(input("Introduce el mes: "))
    año = int(input("Introduce el año: "))
    return dia, mes, año

def dias_del_mes(mes, año):
    """Devuelve el número de días de un mes en un año dado."""
    if mes in [4, 6, 9, 11]:  # Abril, junio, septiembre, noviembre
        return 30
    elif mes == 2:  # Febrero
        return 29 if es_bisiesto(año) else 28
    else:  # Enero, marzo, mayo, julio, agosto, octubre, diciembre
        return 31

def es_bisiesto(año):
    """Determina si un año es bisiesto."""
    return (año % 4 == 0 and año % 100 != 0) or (año % 400 == 0)

def calcular_dia_juliano(dia, mes, año):
    """Calcula el día juliano de una fecha dada."""
    dia_juliano = sum(dias_del_mes(m, año) for m in range(1, mes)) + dia
    return dia_juliano

# Programa principal
dia, mes, año = leer_fecha()
dia_juliano = calcular_dia_juliano(dia, mes, año)

print(f"El día juliano de la fecha {dia}/{mes}/{año} es: {dia_juliano}")

"""
10. Función CalcularMCD: Recibe dos números y devuelve el MCD utilizando el método de Euclides.
El método de Euclides es el siguiente:
 * Se divide el número mayor entre el menor.
 * Si la división es exacta, el divisor es el MCD.
 * Si la división no es exacta, dividimos el divisor entre el resto obtenido y se continúa de esta forma hasta obtener una división exacta, siendo el último divisor el MCD.
"""

def CalcularMCD(a, b):
    """Calcula el MCD usando el método de Euclides."""
    while b != 0:
        a, b = b, a % b
    return a

# Pedir dos números al usuario
num1 = int(input("Introduce el primer número: "))
num2 = int(input("Introduce el segundo número: "))

# Calcular y mostrar el MCD
print(f"El MCD de {num1} y {num2} es: {CalcularMCD(num1, num2)}")