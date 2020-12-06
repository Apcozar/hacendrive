defmodule AnadirTest do
	use ExUnit.Case
	doctest Anadir

	test "añadir un elemento a la BD vacia" do
		File.rm("info")
		Anadir.añadir("prueba", 1)
		Descargar.descargar(1, self())

		receive do
		{_, elemento} ->
			assert elemento == "prueba"
		end
		File.rm("info")
  	end
	
	test "añadir un dato a la BD con elementos" do
		File.rm("info")
		Anadir.añadir("prueba2", 2)
		Anadir.añadir("prueba3", 3)
		Descargar.descargar(3, self())

		receive do
		{_, elemento} ->
			assert elemento == "prueba3"
		end
		File.rm("info")
	end

	test "version añadir"do
		File.rm("info")
		Anadir.añadir("prueba4", 4)
		Anadir.añadir("prueba5", 5)
		Descargar.descargar_todo(self())

		receive do
      		{_, datos} ->
        	assert datos == {2,[{5,"prueba5"}, {4,"prueba4"}]}
    	end
		File.rm("info")
	end
	
end