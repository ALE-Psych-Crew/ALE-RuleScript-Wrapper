package ale.rulescript;

import rulescript.parsers.HxParser;
import rulescript.Tools;

import hscript.Expr;

using StringTools;

class ALEHxParser extends HxParser
{
	public var name:String = ALERuleScriptGlobal.SCRIPT_NAME;
	
	override public function new(name:String, ?mode:HxParserMode = DEFAULT)
	{
		super();

        allowAll();

		this.mode = mode;

		this.name = name.replace('.', '/') + ALERuleScriptGlobal.MODULE_EXTENSION;		
	}

	override public function parse(code:String):Expr
	{
		parser.line = 1;

		return mode == DEFAULT ? parser.parseString(code, name, 0) : Tools.moduleDeclsToExpr(parser.parseModule(code, name, 0));
	}

	override public function parseModule(code:String):Array<ModuleDecl>
	{
		parser.line = 1;

		return parser.parseModule(code, name, 0);
	}
}