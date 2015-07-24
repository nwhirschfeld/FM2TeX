#!/usr/bin/env ruby
require 'xmlsimple'

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