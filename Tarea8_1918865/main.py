from tkinter import *
from tkinter.ttk import *
from time import strftime

# Creamos una ventana con Tkinter
root = Tk()

# Titulo de la ventana
root.title('Reloj - Tarea 8 - 1918865')


# Creamos la funcion hora() para mostrar la hora en un label
def time():
	# Obtenemos la hora local
	datos = strftime('%I:%M:%S %p')

	# Pasamos la hora al label
	label.config(text = datos)

	# Hacemos un retardo de tiempo de 1 segundo, antes de ejecutar el reloj
	label.after(1000, time)

# Personalizo mi reloj
label = Label(root,
font = (
	'Arial', 60
	),
padding = '50',
background = 'black',
foreground = 'green'
)

# Expando el reloj en el centro de la ventana
label.pack(expand = True)

# Llamos a la funcion time()
time()

# Con el metodo mainloop() le decimos a Python que se detenga hasta aqui y no ejecute nada mas
mainloop()