module Output
  def menu(label)
    frame(@main.handler.menu_options.map { |n, s| "%d. %s" % [n, s[0]] }.join("   |   "), label)
  end

  def frame(text, legend, width = nil)
    width ||= tty_width
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

  private
  def extract_line(text, width)
    line = text.split(/[\r\n]/)[0]
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