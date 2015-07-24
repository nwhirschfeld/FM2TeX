#!/usr/bin/env ruby
require 'xmlsimple'

=begin
This simple script creates the structure of an LaTex document based on a FreeMind mindmap.
Copyright (c) 2014 Niclas Hirschfeld
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end

$path = "content/"
$file = "gliederung.mm"

def get_icon node
	nil
	node["icon"].first["BUILTIN"] if node["icon"]
end

def printnode node, list
	node["node"].each do |name, chapter|
		stopit = false
		case get_icon chapter
		when nil
			puts "\\#{list.first}\{#{name}\}"
		when "edit"
			puts "\\#{list.first}\{#{name}\}"
			puts "  \\input{#{$path}/#{name.downcase.gsub(' ', '_')}.tex}"
		when "idea"
			puts "  \\begin{tcolorbox}[width=\\textwidth,colback={red},colupper=white]"
			puts "    #{name}"
			puts "  \\end{tcolorbox}"
		when "attach"
			stopit = true
		when "button_ok"
			stopit = true
		end
		if (chapter["node"] && !stopit)
			printnode chapter, list.drop(1)
		end
	end
end


config = XmlSimple.xml_in($file, { 'KeyAttr' => 'TEXT' })

printnode config["node"]["Gliederung"], ["chapter", "section", "subsection", "subsubsection"]