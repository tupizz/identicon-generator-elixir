defmodule Identicon do
  def main(input) do
    input
      |> hash_input
      |> create_struct
      |> pick_color
      |> build_grid
      |> filter_odd_squares
      # |> build_pixel_map
  end

  defp hash_input(input) do
    :crypto.hash(:md5, input)
      |> :binary.bin_to_list
  end

  defp create_struct(hex) do 
    %Identicon.Image{list_of_hex: hex} 
  end

  # image é uma struct do tipo Identicon Image e tem uma proprieade
  # list_of_hex que é um array e eu me interesso nos três primeiros items
  defp pick_color(%Identicon.Image{ list_of_hex: [ r, g, b | _tail ] } = image) do
    %Identicon.Image{ image | color: {r, g, b} } # we use tuples because it has some meaning unlike an array
  end

  # defp mirror_rows_by_reference(row) do
  #   [first, second | _tail ] = row
  #   row ++ [ second, first ]
  # end

  defp mirror_rows(array) do
    array
      |> Enum.map(fn [item1, item2, item3] -> [item1, item2, item3, item2, item1] end)
  end

  defp build_grid(%Identicon.Image{ list_of_hex: list_of_hex } = image) do
    grid_image = 
      list_of_hex
        |> Enum.chunk_every(3)
        |> Enum.filter(fn (array) -> length(array) > 1 end)
        |> mirror_rows
        # |> &mirror_rows_by_reference/1 # forma como poderia chamar a referencia da funcao que esta criada no escopo
        |> List.flatten
        |> Enum.with_index

    %Identicon.Image{image | grid_image: grid_image}
  end

  defp filter_odd_squares(%Identicon.Image{ grid_image: grid_image } = image) do
    new_grid_with_odd = Enum.filter grid_image, fn({code, _index}) -> 
      rem(code, 2) === 0
    end

    %Identicon.Image{image | grid_image: new_grid_with_odd}
  end

  # defp build_pixel_map(%Identicon.Image{ grid_image: grid_image } = image) do 
  # end
  
end