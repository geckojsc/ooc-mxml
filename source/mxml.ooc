use mxml

MXML_TAB: extern Int

MXML_NO_CALLBACK: extern Pointer
MXML_INTEGER_CALLBACK: extern Pointer
MXML_OPAQUE_CALLBACK: extern Pointer
MXML_REAL_CALLBACK: extern Pointer
MXML_TEXT_CALLBACK: extern Pointer
MXML_IGNORE_CALLBACK: extern Pointer

MXML_NO_PARENT: extern Int

MXML_DESCEND: extern Int
MXML_NO_DESCEND: extern Int
MXML_DESCEND_FIRST: extern Int

MXML_WS_BEFORE_OPEN: extern Int
MXML_WS_AFTER_OPEN: extern Int
MXML_WS_BEFORE_CLOSE: extern Int
MXML_WS_AFTER_CLOSE: extern Int

MXML_ADD_BEFORE: extern Int
MXML_ADD_AFTER: extern Int
MXML_ADD_TO_PARENT: extern Int

XmlSaxEvent: enum {
	cdata         : extern(MXML_SAX_CDATA)
	comment       : extern(MXML_SAX_COMMENT)
	data          : extern(MXML_SAX_DATA)
	directive     : extern(MXML_SAX_DIRECTIVE)
	element_close : extern(MXML_SAX_ELEMENT_CLOSE)
	element_open  : extern(MXML_SAX_ELEMENT_OPEN)
}

XmlNodeType: enum {
	ignore  : extern(MXML_IGNORE)
	element : extern(MXML_ELEMENT)
	integer : extern(MXML_INTEGER)
	opaque  : extern(MXML_OPAQUE)
	real    : extern(MXML_REAL)
	text    : extern(MXML_TEXT)
	custom  : extern(MXML_CUSTOM)
}

Xml: class {
	setErrorCallback: extern(mxmlSetErrorCallback) static func (cb:XmlErrorCallback)
	setCustomHandlers: extern(mxmlSetCustomHandlers) static func (load, save:XmlCustomSaveCallback)
	setWrapMargin: extern(mxmlSetWrapMargin) static func (column:Int)
}

XmlEntity: class {
	addCallback: extern(mxmlEntityAddCallback) static func (cb:XmlEntityCallback) -> Int
	_getName: extern(mxmlEntityGetName) static func (val:Int) -> CString
	getValue: extern(mxmlEntityGetValue) static func (name:CString) -> Int
	removeCallback: extern(mxmlEntityRemoveCallback) static func (cb:XmlEntityCallback)
}

XmlAttribute: cover from mxml_attr_t* {}
XmlElement: cover from mxml_element_t* {}
XmlText: cover from mxml_text_t* {}
XmlCustom: cover from mxml_custom_t* {}
XmlValue: cover from mxml_value_t* {}

XmlNode: cover from mxml_node_t* {
	new: static func~default -> XmlNode {
		new(null)
	}
	new: extern(mxmlNewXML) static func (version:CString) -> XmlNode
	
	add: extern(mxmlAdd) func (where:Int, child, node:XmlNode)
	delete: extern(mxmlDelete) func
	deleteAttr: extern(mxmlElementDeleteAttr) func (name:CString)
	getAttr: func (name:String) -> String { s := _getAttr(name); return s ? s toString() : null }
	setAttr: extern(mxmlElementSetAttr) func (name, value:CString)
	setAttrf: extern(mxmlElementSetAttrf) func (name, format:CString, ...)
	
	findElement: extern(mxmlFindElement) func (top:XmlNode, name, attr, value:CString, descend:Int) -> XmlNode
	findElement: func~name (name:String) -> XmlNode { findElement(this, name, null, null, MXML_DESCEND) }
	findElement: func~props (name, attr, val:String) -> XmlNode { findElement(this, name, attr, val, MXML_DESCEND) }
	findElement: func~nameAndTop (top:XmlNode, name:String) -> XmlNode { findElement(top, name, null, null, MXML_DESCEND) }
	findElement: func~descend (top:XmlNode, name, attr, val:CString) -> XmlNode { findElement(top, name, attr, val, MXML_DESCEND) }
	
	findPath: extern(mxmlFindPath) func (path:CString) -> XmlNode
	getCDATA: func -> String { s := _getCDATA(); return s ? s toString() : null }
	getCustom: extern(mxmlGetCustom) func -> Pointer
	getElement: func -> String { s := _getElement(); return s ? s toString() : null }
	getFirstChild: extern(mxmlGetFirstChild) func -> XmlNode
	getInteger: extern(mxmlGetInteger) func -> Int
	getLastChild: extern(mxmlGetLastChild) func -> XmlNode
	getNextSibling: extern(mxmlGetNextSibling) func -> XmlNode
	getOpaque: func -> String { s := _getOpaque(); return s ? s toString() : null }
	getParent: extern(mxmlGetParent) func -> XmlNode
	getPrevSibling: extern(mxmlGetPrevSibling) func -> XmlNode
	getReal: extern(mxmlGetReal) func -> Double
	getRefCount: extern(mxmlGetRefCount) func -> Int
	getText: func (whitespace:Int*) -> String { s := _getText(whitespace); return s ? s toString() : null }
	getType: extern(mxmlGetType) func -> XmlNodeType
	getUserData: extern(mxmlGetUserData) func -> Pointer
	
	loadFd: extern(mxmlLoadFd) func (fd:Int, cb:Pointer/*Func(XmlNode)->XmlNodeType*/) -> XmlNode
	loadFile: extern(mxmlLoadFile) func (fp:FStream, cb:Pointer/*Func(XmlNode)->XmlNodeType*/) -> XmlNode
	loadString: extern(mxmlLoadString) func (s:CString, cb:Pointer/*Func(XmlNode)->XmlNodeType*/) -> XmlNode
	newCDATA: extern(mxmlNewCDATA) func (string:CString) -> XmlNode
	newCustom: extern(mxmlNewCustom) func (data:Pointer, destroy:XmlCustomDestroyCallback) -> XmlNode
	newElement: extern(mxmlNewElement) func (name:CString) -> XmlNode
	newInteger: extern(mxmlNewInteger) func (integer:Int) -> XmlNode
	newOpaque: extern(mxmlNewOpaque) func (opaque:CString) -> XmlNode
	newReal: extern(mxmlNewReal) func (real:Double) -> XmlNode
	newText: extern(mxmlNewText) func (whitespace:Int, string:CString) -> XmlNode
	newTextf: extern(mxmlNewTextf) func (whitespace:Int, format:CString, ...) -> XmlNode
	
	release: extern(mxmlRelease) func -> Int
	remove: extern(mxmlRemove) func
	retain: extern(mxmlRetain) func -> Int
	saveAllocString: func (cb:XmlSaveCallback) -> String { s := _saveAllocString(cb); return s ? s toString() : null }
	saveFd: extern(mxmlSaveFd) func (fd:Int, cb:XmlSaveCallback) -> Int
	saveFile: extern(mxmlSaveFile) func (fp:FStream, cb:XmlSaveCallback) -> Int
	saveString: extern(mxmlSaveString) func (buffer:CString, bufsize:Int, cb:XmlSaveCallback) -> Int
	
	saxLoadFd: extern(mxmlSAXLoadFd) func (fd:Int, cb:Pointer/*Func(XmlNode)->XmlNodeType*/, sax:XmlSaxCallback, sax_data:Pointer) -> XmlNode
	saxLoadFile: extern(mxmlSAXLoadFile) func (fp:FStream, cb:Pointer/*Func(XmlNode)->XmlNodeType*/, sax:XmlSaxCallback, sax_data:Pointer) -> XmlNode
	saxLoadString: extern(mxmlSAXLoadString) func (s:CString, cb:Pointer/*Func(XmlNode)->XmlNodeType*/, sax:XmlSaxCallback, sax_data:Pointer) -> XmlNode
	
	setCDATA: extern(mxmlSetCDATA) func (data:CString) -> Int
	setCustom: extern(mxmlSetCustom) func (data:Pointer, destroy:XmlCustomDestroyCallback) -> Int
	setElement: extern(mxmlSetElement) func (name:CString) -> Int
	setInteger: extern(mxmlSetInteger) func (integer:Int) -> Int
	setOpaque: extern(mxmlSetOpaque) func (opaque:CString) -> Int
	setReal: extern(mxmlSetReal) func (real:Double) -> Int
	setText: extern(mxmlSetText) func (whitespace:Int, string:CString) -> Int
	setTextf: extern(mxmlSetTextf) func (whitespace:Int, format:CString, ...) -> Int
	
	setUserData: extern(mxmlSetUserData) func (data:Pointer) -> Int
	walkNext: extern(mxmlWalkNext) func (top:XmlNode, descend:Int) -> XmlNode
	walkPrev: extern(mxmlWalkPrev) func (top:XmlNode, descend:Int) -> XmlNode
	
	// higher level utilities:
	
	/**
	 * call a function for each child element
	 */
	eachChildElement: func (callback: Func(XmlNode)) {
	    node := getFirstChild()
	    while (node != null) {
	        if (node getType() == XmlNodeType element) {
	            callback(node)
	        }
	        node = node getNextSibling()
	    }
	}

	/** 
	 * get an attribute with a default value 
	 * (may be obsolete one day, if a null-coalescing operator is introduced to the language)
	 */
	getAttrDefault: func (name, def: String) -> String {
		val := getAttr(name)
		return val ? val : def
	}
	
	// Functions that return CStrings
	_getAttr: extern(mxmlElementGetAttr) func (name:CString) -> CString
	_getCDATA: extern(mxmlGetCDATA) func -> CString
	_getElement: extern(mxmlGetElement) func -> CString
	_getOpaque: extern(mxmlGetOpaque) func -> CString
	_getText: extern(mxmlGetText) func (whitespace:Int*) -> CString
	_saveAllocString: extern(mxmlSaveAllocString) func (cb:XmlSaveCallback) -> CString
}

XmlIndex: cover from mxml_index_t* {
	new: extern(mxmlIndexNew) static func (node:XmlNode, element, attr:CString) -> XmlIndex
	delete: extern(mxmlIndexDelete) func
	enumerate: extern(mxmlIndexEnum) func -> XmlNode
	find: extern(mxmlIndexFind) func (element, value:CString) -> XmlNode
	getCount: extern(mxmlIndexGetCount) func -> Int
	reset: extern(mxmlIndexReset) func -> XmlNode
}

XmlErrorCallback: cover from Pointer // Func (CString)
XmlCustomDestroyCallback: cover from Pointer // Func
XmlCustomLoadCallback: cover from Pointer // Func (XmlNode) -> Int
XmlCustomSaveCallback: cover from Pointer // Func (XmlNode) -> CString
XmlEntityCallback: cover from Pointer // Func (CString) -> Int
XmlLoadCallback: cover from Pointer // Func (XmlNode) -> XmlType
XmlSaveCallback: cover from Pointer // Func (XmlNode, Int) -> CString
XmlSaxCallback: cover from Pointer // Func (XmlSaxEvent)
