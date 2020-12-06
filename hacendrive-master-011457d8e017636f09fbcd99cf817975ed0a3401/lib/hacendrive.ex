defmodule Hacendrive do

	@moduledoc"""
	Módulo que añade la lógica de negocio a la aplicación.

	"""

	@doc"""
	Conecta los nodos que componen la lista pasada por parámetro.

	##Parámetros
	Lista de nodos.

	"""
	defp conectarNodos([]), do: :ok
	defp conectarNodos([nodo | tl]) do
		try do
			Node.connect(nodo)
			conectarNodos(tl)
		catch
			_ -> conectarNodos(tl)
		end
	end

	@doc"""
	Cliente que consta de una serie de funciones como, leer los repositorios
	disponibles, conectar dichos repositorios, actualizar la lista de repositorios
	y leer las peticiones pasadas por pantalla.

	"""
	def cliente() do
		Node.set_cookie(:hacendrive)
		list = Utilidades.leer_repositorios()
		conectarNodos(list)
		actualizar(Node.list,[])
		leerPeticiones()
	end

	@doc"""
	Función que manda un proceso síncrono que actualiza los repositorios
	con los nuevos datos.

	##Parámetros
	Lista de nodosy lista de tuplas con los repositorios y sus correspondientes
	versiones.

	"""
	defp actualizar([],list) do
		obtenerActualizada(list,[])
	end
	defp actualizar([node|tl],list) do
		Node.spawn(node, Descargar, :descargar_todo, [self()])
		receive do
			{:ok, elem} -> actualizar(tl,[elem|list])
			{:error, _} -> actualizar(tl,list)
		end
	end

	@doc"""
	Funcion que permite obtener la versión mas reciente de el elemento solicitado.

	##Parámetros
	Lista con las tuplas que contienen las versiones y sus correspondientes nodos y
	una lista auxiliar donde se almacenara el elemento que mas recientemente se haya
	actualizado.
	"""
	defp obtenerActualizada([],elem) do
		enviarCambios(elem, Node.list)
	end
	defp obtenerActualizada([h|list],[]) do
		obtenerActualizada(list,h)
	end
	defp obtenerActualizada([{n1,elem1}|list],{n2,elem2}) do
		if n1>n2 do
			obtenerActualizada(list,{n1,elem1})
		else
			obtenerActualizada(list,{n2,elem2})
		end
	end

	@doc"""
	Función que manda un proceso síncrono que envía los cambios a realizar en
	todos los repositorios de la lista.

	##Parámetros
  Nuevo elemento y lista de repositorios.

	"""
	defp enviarCambios(_, []), do: :ok
	defp enviarCambios(elem, [h|list]) do
		Node.spawn(h,Actualizar, :actualizar, [elem])
		enviarCambios(elem, list)
	end

	@doc"""
	Función que añade los datos con la clave en el primer nodo disponible
	de la lista.

	##Parámetros
	Lista de nodos, los datos a añadir y la clave.

	"""
	defp añadir([], _, _) do
		:ok
	end
	defp añadir([n | tl], datos, clave) do
		try do
			Node.spawn(n, Anadir, :añadir, [datos, clave])
			añadir(tl, datos , clave)
		catch
			_ -> añadir(tl, datos , clave)
		end
	end

	@doc"""
	Función que elimina el primer elemento disponicle del repositorio por clave.

	##Parámetros
	Lista de nodos y la clave.

	"""
	defp eliminar([], _) do
		:ok
	end
	defp eliminar([n | tl], clave) do
		try do
			Node.spawn(n, Eliminar, :eliminar, [clave])
			eliminar(tl, clave)
		catch
			_ -> eliminar(tl , clave)
		end
	end

	@doc"""
	Función que muestra por pantalla los datos, si la clave asociada es válida.
	En caso contrario mostrará un mensaje de error por pantalla.

	##Parámetros
	Lista de nodos y la clave.

	"""
	defp descargar([], _), do: :error
	defp descargar([n | tl], clave) do
		try do
			Node.spawn(n, Descargar, :descargar, [clave, self()])
			receive do
				{:ok, elem} -> IO.puts(elem)
				{:error, _} -> :error
			end
		catch
			_ -> descargar(tl, clave)
		end
	end

	@doc"""
	Función que modifica los datos asociados a una determinada clave.

	##Parámetros
	Lista de nodos, los datos a añadir y la clave.

	"""
	defp modificar([], _, _) do
		:ok
	end
	defp modificar([n | tl], datos, clave) do
		try do
			Node.spawn(n,Modificar, :modificar, [datos, clave])
			modificar(tl, datos, clave)
		catch
			_ -> modificar(tl, datos, clave)
		end
	end

	@doc"""
	Función recursiva que gestiona las operaciones de la aplicación, y permite
	al usuario introducir los datos por pantalla.

	"""
	def leerPeticiones() do
		flecha = IO.gets("-> ")
		peticion =	String.slice(flecha, 0..String.length(flecha)-2)
		parametros_list = String.split(peticion, " ")
		case (Enum.at(parametros_list, 0)) do
			"add" ->
				añadir(Node.list, Enum.at(parametros_list, 2), Enum.at(parametros_list, 1))
				leerPeticiones()
			"delete" ->
				eliminar(Node.list, Enum.at(parametros_list, 1))
				leerPeticiones()
			"modify" ->
				modificar(Node.list, Enum.at(parametros_list, 2), Enum.at(parametros_list, 1))
				leerPeticiones()
			"download" ->
				descargar(Node.list, Enum.at(parametros_list, 1))
				leerPeticiones()
			"exit" ->
				:bye
			_ ->
				IO.puts("Invalid command")
				leerPeticiones()
		end
	end

	@doc"""
	Función que añade un repositorio a la lista de repositorios.

	##Parámetros
	Repositorio a añadir.

	"""
	defp añadir_repositorio(repositorio) do
		repositorio=String.to_atom(repositorio)
		repositorio_list = Utilidades.leer_repositorios()
		Utilidades.escribir_repositorios([repositorio | repositorio_list])
  	end

	@doc"""
	Función que elimina un repositorio de la lista de repositorios.

	##Parámetros
	Repositorio a eliminar.

	"""
	defp eliminar_repositorio(repositorio) do
		repositorio=String.to_atom(repositorio)
		repositorio_list = Utilidades.leer_repositorios()
		new_repositorio_list = List.delete(repositorio_list,repositorio)
		Utilidades.escribir_repositorios(new_repositorio_list)

	end

	@doc"""
	Función recursiva que nos permite gestionar las operaciones tanto de añadir como
	eliminar repositorios.

	"""
	def listaRepositorios() do
		flecha = IO.gets("->")
		param_repository = String.slice(flecha, 0..String.length(flecha)-2)
		repositorio = String.split(param_repository, " ")
		case (Enum.at(repositorio, 0)) do
			"add" ->
				añadir_repositorio(Enum.at(repositorio, 1))
				listaRepositorios()

			"delete" ->
				eliminar_repositorio(Enum.at(repositorio, 1))
				listaRepositorios()

			"exit" ->
				:bye

			_ -> IO.puts("Invalid command")
			listaRepositorios()
		end

	end

end
