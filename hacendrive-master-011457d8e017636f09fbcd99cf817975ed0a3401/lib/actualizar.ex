defmodule Actualizar do

	@moduledoc"""
	Módulo que permite mantener el estado de la aplicación, mediante la actualización del contenedor de información
	"""

	@doc"""
	Funciona que permite actualizar la información del contenedor de información
	##Parámetros
	Recibe una tupla {n,list} donde n es el número de versión y list es la información guardada mediante un estructura clave-valor
	"""
	def actualizar(list) do
		Utilidades.escribir(list)
	end

end
