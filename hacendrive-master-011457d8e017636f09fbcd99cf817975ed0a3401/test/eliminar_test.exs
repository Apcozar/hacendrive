defmodule EliminarTest do
  use ExUnit.Case
  doctest Eliminar

  
  test "Eliminar un elemento asociado a una clave" do
  	Anadir.añadir("Hola", 1)
  	Anadir.añadir("Testeando", 2)
  	Anadir.añadir("Adios", 3)

    Eliminar.eliminar(1)
    Descargar.descargar_todo(self())

    receive do
      {_, datos} ->
        File.rm("info")
        assert datos == {4, [{2, "Testeando"}, {3, "Adios"}]}
    end

  end

  test "Eliminar el elemento más reciente asociado a una clave" do
  	Anadir.añadir("Hola", 1)
  	Anadir.añadir("Testeando", 2)
  	Anadir.añadir("Adios", 3)
  	Anadir.añadir("Nuevo", 2)

    Eliminar.eliminar(2)
    Descargar.descargar_todo(self())

    receive do
      {_, datos} ->
        File.rm("info")
        assert datos == {5, [{3, "Adios"}, {2, "Testeando"}, {1, "Hola"}]}
    end

  end

  test "Eliminar en un contenedor vacío" do
  	File.rm("info")
  	Eliminar.eliminar(1)
    Descargar.descargar_todo(self())

    receive do
      {_, datos} ->
        File.rm("info")
        assert datos == {1, []}
    end

  end



end
