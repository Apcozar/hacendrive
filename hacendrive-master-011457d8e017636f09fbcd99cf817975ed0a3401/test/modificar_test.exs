defmodule ModificarTest do
	use ExUnit.Case
	doctest Modificar

	test "modificar un elemento existente" do
		Anadir.añadir("hola", 2)
		Modificar.modificar("adiós", 2)
		Descargar.descargar(2, self())
		elem = Utilidades.leer()
		File.rm("info")
		assert elem == {2,[{2,"adiós"}]}

	end

	test "modificar un elemento no existente" do
		File.rm("info")
		Modificar.modificar("adios", 1)
		elem = Utilidades.leer()
		File.rm("info")
		assert elem == {1,[]}

	end

	test "modificar varios elementos" do
		Anadir.añadir("hola1", 1)
		Modificar.modificar("adios1", 1)
		Anadir.añadir("hola2", 2)
		Modificar.modificar("adios2", 2)
		Anadir.añadir("hola3", 3)
		Modificar.modificar("adios3", 3)
		
		elem = Utilidades.leer()
		File.rm("info")
		assert elem == {6,[{3,"adios3"},{2,"adios2"},{1,"adios1"}]}
	end			

	
end
