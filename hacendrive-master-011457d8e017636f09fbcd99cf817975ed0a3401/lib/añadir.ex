defmodule Anadir do

	@moduledoc"""
	Módulo que permite añadir datos al contenedor de información
	"""

	@doc"""
	Función que añade datos asociados a una clave
	
  	##Parámetros
  	datos: Datos a añadir al contenedor
  	clave: Clave asociada a los datos que se quieren añadir
	"""

	def añadir(datos, clave) do
		{n,list} = Utilidades.leer()
		list2 = Db.write(list ,clave, datos)
		Utilidades.escribir({n+1,list2})
		:ok
	end

end
