use mxml
import io/File

main: func {
	
	// load our XML file, using opaque mode to preserve all whitespace in string values
	file := File new("test.xml")
	tree := XmlNode new()
	tree loadString(file read(), MXML_OPAQUE_CALLBACK)
	
	// find a node and access some attributes
	dog := tree findElement(tree, "dog")
	dog getAttr("name") println()
	dog getAttr("age") println()
	
	// find a node and get its contents
	message := tree findElement(tree, "message")
	message getOpaque() println()
	
	// recursively free everything
	tree delete()
}