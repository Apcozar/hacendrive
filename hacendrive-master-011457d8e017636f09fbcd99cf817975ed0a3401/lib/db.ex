defmodule Db do

    @moduledoc"""
    Módulo que permite crear, manipular y destruir un almacén de datos.
    """

    @doc"""
    Crea un nuevo almacén de datos.

	"""
    def new(), do: []

    @doc"""
    Inserta un nuevo elemento en el almacén `db_ref`.

    ##Parámetros
    db_ref : Almacén de datos
    key : Clave
    element : Valor

    """
    def write(db_ref, key, element) do
        [{key, element} | db_ref]
    end

    @doc"""
    Une dos listas.

	##Parámetros
    Lista 1
    Lista 2

	"""
    def append([], l2), do: l2
    def append([h|tl], l2), do: [h | append(tl,l2)]

    @doc"""
    Elimina la primera ocurrencia de la clave `key` en el almacén `db_ref`.

	##Parámetros
    db_ref : Almacén de datos
    key : Clave

	"""
    def aux_delete([], _, aux), do: aux
    def aux_delete([{k,_} | tl], key, aux) when k == key do
        append(aux,tl)
    end
    def aux_delete([{k,e}|tl], key, aux), do: aux_delete(tl,key,[{k,e}|aux])
    def delete(db_ref, key), do: aux_delete(db_ref,key, [])

    @doc"""
    Recupera la primera ocurrencia de la clave `key` en el almacén `db_ref`, o un valor de error si no existe.

	##Parámetros
    db_ref : Almacén de datos
    key : Clave

	"""
    def read([], _), do: {:error, :not_found}
    def read([{k,e} |_], key) when k == key do
        {:ok, e}
    end
    def read([{_,_}| tl], key), do: read(tl, key)

    @doc"""
    Invierte una lista.

	##Parámetros
    list : Lista

	"""
    def aux_reverse([],s),do: s
    def aux_reverse([h|tl], s),do: aux_reverse(tl,[h | s])
    def reverse(list),do: aux_reverse(list,[])

    @doc"""
    Recupera todas las claves que contienen que contienen el valor `element`.

	##Parámetros
    db_ref : Almacén de datos
    element : Valor

	"""
    def aux_match([], _, aux), do: aux
    def aux_match([{k,e}| tl], element, aux) when e == element do
        aux_match(tl,element,[k|aux])
    end
    def aux_match([{_,_}| tl], element, aux), do: aux_match(tl,element,aux)
    def match(db_ref, element), do: reverse(aux_match(db_ref,element,[]))

    @doc"""
    Elimina el almacén `db_ref`

	##Parámetros
    db_ref : Almacén de datos

	"""
    def destroy([]),do: :ok
    def destroy([_|t]),do: destroy(t)

    @doc"""
    Modifica el valor asociado a la clave `key`.

	##Parámetros
    list : Lista
    clave : Clave
    valor : Nuevo valor

	"""
    def aux_modify([], _, _, aux), do: reverse(aux)
    def aux_modify([{k, _} | tl], clave, valor, aux) when k == clave do
        reverse(aux) ++ [{k, valor}| tl]
    end
    def aux_modify([hd | tl], clave, valor, aux) do
        aux_modify(tl, clave, valor, [hd |aux])
    end
    def modify(list, clave, valor) do
        aux_modify(list, clave, valor, [])
    end

end
