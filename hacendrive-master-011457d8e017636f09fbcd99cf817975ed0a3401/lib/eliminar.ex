defmodule Eliminar do

  @moduledoc"""
	Módulo que permite eliminar datos al contenedor de información
	"""

	@doc"""
	Función que elimina los datos asociados a una clave
	
  	##Parámetros
  	clave: Clave asociada a los datos que se quieren eliminar
	"""
  def eliminar(clave) do
    {n,list}= Utilidades.leer()
		list2 = Db.delete(list ,clave)
		Utilidades.escribir({n+1,list2})
    :ok
  end

end
