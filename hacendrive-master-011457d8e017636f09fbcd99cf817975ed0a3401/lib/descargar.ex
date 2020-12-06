defmodule Descargar do

  @moduledoc"""
	Módulo que permite modificar datos del contenedor de información
  """

  @doc"""
	Función que devuelve los datos asociados a una clave

  	##Parámetros
    clave: Clave asociada a los datos que se quieren añadir
    pid: pid del cliente que quiere obtener los datos de la clave
  """

  def descargar(clave, pid) do
    {_,datos} = Utilidades.leer()
    {_, elemento} = Db.read(datos, clave)
    send pid, {:ok, elemento}
  end

  @doc"""
	Función que devuelve todo el contenido del almacén de información

  	##Parámetros
    pid: pid del cliente que quiere obtener los datos del contenedor de información
  """

  def descargar_todo(pid) do
    datos = Utilidades.leer()
    send pid, {:ok,datos}
  end

end
