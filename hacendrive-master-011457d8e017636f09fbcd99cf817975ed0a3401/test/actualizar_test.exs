defmodule ActualizarTest do
  use ExUnit.Case
  doctest Actualizar

  test "actualizar info" do

    assert true == true
    #Si el fichero info existía antes del test lo borra
    if File.exists?("info") do
      File.rm("info")
    end

    #Añadimos un dato con una clave
    Anadir.añadir("dato","clave")

    #Recuperamos el numero de version de info y la lista
    {version,lista_original} = Utilidades.leer()

    #Metemos actualizamos el archivo info
    parametros = {version+1, [{"claveNueva", "datoNuevo"}]}
    Actualizar.actualizar(parametros)

    #Recuperamos la nueva version y la nueva lista
    {nueva_version, lista_actualizada} = Utilidades.leer()

    #Comprobamos
    refute version == nueva_version
    refute lista_original == lista_actualizada
    assert lista_original == [{"clave","dato"}]
    assert version == 1
    assert nueva_version == 2
    assert lista_actualizada == [{"claveNueva", "datoNuevo"}]

    #Si el fichero info se crea se borra de nuevo
    if File.exists?("info") do
      File.rm("info")
    end
  end
end
