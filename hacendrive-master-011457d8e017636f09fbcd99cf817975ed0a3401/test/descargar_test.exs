defmodule DescargarTest do
  use ExUnit.Case
  doctest Descargar

  test "descargar un elemento que existe en la BD" do
    Anadir.añadir("hola", 3)
    Descargar.descargar(3, self())

    receive do
      {_, elemento} ->
        File.rm("info")
        assert elemento == "hola"
    end

  end

  test "descargar un elemento que no existe en la BD" do
    File.rm("info")
    Descargar.descargar(1, self())

    receive do
      {_, elemento} ->
        assert elemento == :not_found
    end

  end

  test "descargar contenido BD no vacía" do
    Anadir.añadir("hola", 3)
    Anadir.añadir("adios", 2)
    Anadir.añadir("chao", 5)
    Descargar.descargar_todo(self())

    receive do
      {_, datos} ->
        File.rm("info")
        assert datos == {3,[{5,"chao"}, {2,"adios"}, {3,"hola"}]}
    end

  end

  test "descargar contenido BD vacía" do
    File.rm("info")
    Descargar.descargar_todo(self())

    receive do
      {_, datos} ->
        assert datos == {0,[]}
    end

  end

end
