defmodule Modificar do
@moduledoc"""
Módulo que permite modificar los datos asociados a una clave en el repositorio
"""
  @doc"""
  Función que modifica los datos asociados a una clave
  ##Parámetros
  datos: Nuevos datos que se asociarán a la clave
  clave: Clave asociada a los datos que se quieren cambiar
  """

  def modificar(datos, clave) do
    {n,list} = Utilidades.leer()
    list = Db.modify(list, clave, datos)
    Utilidades.escribir({n+1,list})
    :ok
  end

end
