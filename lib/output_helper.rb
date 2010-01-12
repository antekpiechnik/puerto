module Puerto::OutputHelper
  ##
  # Frame helper wraps `text` with a nice text frame and labels it. Newlines are
  # handled -- if one occurs the text begins with new paragraph.
  #
  # @param [String] text text that will be wrapped
  # @param [String] legend label legend
  # @param [Integer] width frame width (if nil, current terminal width applies)
  # @return [String] frame with `text` inside
  def frame(text, legend = nil, width = nil)
    width ||= tty_width
    legend ||= self.title
    str = ""
    str << "+ --[ %s%s%s ] " % ["\033[00;32m", legend, "\033[00;37m"]
    str << "-" * (width - legend.length - 8)
    str << "+\n"
    while text
      text, line = extract_line(text, width)
      str << "| %s |\n" % [line.ljust(width - 2)]
    end
    str << "+"
    str << "-" * width
    str << "+\n"
    str
  end

  ##
  # Clears terminal screen so that we can display smooth.
  #
  # @return [void]
  def clear
    system("clear")
  end

  ##
  # Reads input and modifies it so that no end--line characters occur. Also
  # displays prompt.
  #
  # @return [String, nil] text input or nil if no input occured (ctrl+d or
  #   enter)
  def read_input
    print "Your choice: "
    input = gets
    if input.nil? or input.chomp.empty?
      self.flash = "Empty input"
      return nil
    else
      input.chomp!
    end
    input
  end

  ##
  # Flash setter for handlers. It will display as a frame on top of game window
  # until next input.
  #
  # @return [void]
  def flash=(msg)
    self.main.flash = msg
  end

  private
  def extract_line(text, width)
    line = text.split(/[\r\n]/)[0] || ""
    if line.length > width - 2
      size = width - 2
      line = line.split(" ")
      while line.join(" ").length > width - 2
        line = line[0 .. -2]
      end
      line = line.join(" ")
      cut = line.length
    else
      cut = line.length + 1
    end
    [text[cut .. -1], line]
  end

  def tty_width
    `stty size`.split(" ").last.to_i - 5 rescue 80
  end
end
