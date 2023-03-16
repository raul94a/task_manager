Hacer un nuevo provider para guardar los datos de las lecturas del reloj
ejemplo

Cada vez que se actualiza el tiempo de una tarea (cada segundo)
El valor de esta tarea debe guardarse en ese provider

Cuando se para o pausea el reloj, el valor de este provider es utilizado para setear
la tarea en la lista de tareas del provider (si estuviese disponible) y para actualizar el tiempo en millisegundos en la base de datos

Así se evita actualizar la tarea en el Timer, evitando actualizar el estado

Otra cosa que puede hacer es copiar la Task recibida en el TimerTask e ir modificando el 
time in millis a medida que se vaya actualizando el tiempo