defmodule HacendriveTest do
    use ExUnit.Case
    doctest Utilidades

    defp eliminarFicheroInfo() do
        File.rm("info")
    end

    defp eliminarFicheroRepositorios() do
        File.rm("repositorios")
    end

    test "escribir y leer info" do
        Utilidades.escribir({0,[1,2,3,4]})
        elem = Utilidades.leer()
        assert  elem == {0,[1,2,3,4]}
        Utilidades.escribir({1,[1,5,3,4]})
        elem = Utilidades.leer()
        eliminarFicheroInfo()
        assert elem == {1,[1,5,3,4]}
    end

    test "leer vacío info" do
        elem = Utilidades.leer()
        eliminarFicheroInfo()
        assert  elem == {0,[]}
    end

    test "escribir y leer repositorios" do
        Utilidades.escribir_repositorios(["yo@localhost","antonio@localhost","antonino@localhost"])
        elem = Utilidades.leer_repositorios()
        eliminarFicheroRepositorios()
        assert elem == ["yo@localhost","antonio@localhost","antonino@localhost"]
    end


    test "leer vacío repositorios" do
        elem = Utilidades.leer_repositorios()
        eliminarFicheroRepositorios()
        assert  elem == []
    end


end
