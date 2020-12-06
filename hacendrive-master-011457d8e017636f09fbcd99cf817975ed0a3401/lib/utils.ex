defmodule Utilidades do

  @moduledoc  """
  Módulo en el cuál tenemos funciones útiles para otros métodos
  """


  @doc"""
  Función que permite escribir en la información en el fichero "info"

	##Parámetros
  List: Datos que queremos escribir

	"""
  def escribir(list) do
    {:ok,file}=File.open("info", [:write])
    list=:erlang.term_to_binary list
    IO.binwrite(file, list)
    File.close(file)
  end

  @doc"""
  Función que permite escribir los repositorios en el fichero "repositorios"

	##Parámetros
  List: Datos de los repositorios que queremos escribir


	"""
  def escribir_repositorios(list) do
    {:ok,file}=File.open("repositorios", [:write])
    list=:erlang.term_to_binary list
    IO.binwrite(file, list)
    File.close(file)
  end

  @doc"""
  Función que permite leer los repositorios del fichero "repositorios"

	##Parámetros
  <No hay parámetros>

	"""
  def leer_repositorios() do
		  {_,text}=File.read("repositorios")
    	if (text != :enoent) do
      		:erlang.binary_to_term(text)
    	else
       		[]
    	end
	end

  @doc"""
  Función que permite leer los datos del fichero "info"
	##Parámetros
  <No hay parámetros>
	##Ejemplos

	"""
  def leer() do

    {_,text}=File.read("info")
    if (text == :enoent || text == "") do
      {0,[]}
    else
      :erlang.binary_to_term(text)
    end

  end

end
