
class GeradorNT
  def initialize(input)
    @input = input
    @state = [] # Stack = Pilha

    @output = []
  end

  def output_print(s)
    @output << s
  end

  def compile_output
    @output.join
  end

  def current_state
    @state.last
  end

  def push_state(new_state)
    @state << new_state
  end

  def pop_state
    @state.pop
  end

  def convert
    total_length = @input.length
    index = 0
    # @input.split('').each do |char| # CHARacter = caractere/letra

    while index < total_length
      char = @input[index]

      if current_state == nil
        push_state(:in_paragraph)
        output_print("<p>")
      end

      print_char = char

      # strong
      if char == '*'
        if current_state == :strong
          pop_state
          output_print("</strong>")
        else
          push_state(:strong)
          output_print("<strong>")
        end

        print_char = nil
      # italic
      elsif char == '_'
        if current_state == :italic
          pop_state
          output_print("</i>")
        else
          push_state(:italic)
          output_print("<i>")
        end

        print_char = nil

      elsif char == "\n"
        # end list item
        if current_state == :in_list_item
          output_print("</li>\n")
          pop_state
          print_char = nil

          if @input[index + 1] != "-"
            output_print("</ul>")
            pop_state
          end
        end

        if @input[index + 1] == "\n"
          # end paragraph
          output_print("</p>\n\n<p>")

          index += 1 while @input[index] == "\n"

          index -= 1
          print_char = nil
        end

      # list
      elsif char == "-" && @input[index + 1] == ' '
        if current_state != :in_list
          output_print("<ul>\n")
          push_state(:in_list)
        end

        push_state(:in_list_item)
        output_print("<li>")

        index += 1
        print_char = nil
      end

      output_print(print_char) if print_char
      index += 1
    end

    output_print("</p>\n")
  end
end

gerador = GeradorNT.new(File.read('artigo.nt'))
gerador.convert
