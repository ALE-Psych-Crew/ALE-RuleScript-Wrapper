package ale.rulescript;

import rulescript.scriptedClass.RuleScriptedClassUtil;
import rulescript.RuleScript as OGRuleScript;
import rulescript.types.ScriptedTypeUtil;
import rulescript.types.Abstracts;

import hscript.Expr;

using StringTools;

class RuleScriptGlobal
{
    // Global

    public static var FILE_CHECKER:String -> Bool;
    public static var FILE_READER:String -> String;

    // Import

    public static var IMPORTS:Array<Class<Dynamic>>;
    public static var ABSTRACTS:Array<String>;
    public static var TYPEDEFS:Map<String, Class<Dynamic>>;
    public static var VARIABLES:Map<String, Dynamic>;

    // Scripts
    
    public static var SCRIPT_PATH:String;
    public static var SCRIPT_EXTENSION:String;
    public static var SCRIPT_RESOLVER:String -> Dynamic;

    // Modules

    public static var MODULE_EXTENSION:String;
    public static var MODULE_PATH:String;
    public static var MODULE_RESOLVER:String -> Array<ModuleDecl>;

    // Classes

    public static var BUILD_BRIDGE:String -> Dynamic -> OGRuleScript;

    // Debug

    public static var SCRIPT_NAME:String;
    public static var ERROR_HANDLER:String -> Void;

    // Utils & Default Values

    public static function reset()
    {
        if (!initializedValues)
            initializedValues = true;

        FILE_CHECKER = RuleScriptPresets.FILE_CHECKER;
        FILE_READER = RuleScriptPresets.FILE_READER;

        IMPORTS = RuleScriptPresets.IMPORTS;
        ABSTRACTS = RuleScriptPresets.ABSTRACTS;
        TYPEDEFS = RuleScriptPresets.TYPEDEFS;
        VARIABLES = RuleScriptPresets.VARIABLES;

        SCRIPT_PATH = RuleScriptPresets.SCRIPT_PATH;
        SCRIPT_EXTENSION = RuleScriptPresets.SCRIPT_EXTENSION;
        SCRIPT_RESOLVER = RuleScriptPresets.SCRIPT_RESOLVER;

        MODULE_EXTENSION = RuleScriptPresets.MODULE_EXTENSION;
        MODULE_PATH = RuleScriptPresets.MODULE_PATH;
        MODULE_RESOLVER = RuleScriptPresets.MODULE_RESOLVER;

        BUILD_BRIDGE = RuleScriptPresets.BUILD_BRIDGE;

        SCRIPT_NAME = RuleScriptPresets.SCRIPT_NAME;
        ERROR_HANDLER = RuleScriptPresets.ERROR_HANDLER;
    }

    @:unreflective static var initializedValues:Bool = false;

    public static function apply()
    {
        if (!initializedValues)
            reset();

        ScriptedTypeUtil.resolveModule = MODULE_RESOLVER;
        ScriptedTypeUtil.resolveScript = SCRIPT_RESOLVER;

        RuleScriptedClassUtil.buildBridge = BUILD_BRIDGE;

        OGRuleScript.defaultImports[''] ??= new Map();
        OGRuleScript.defaultImports[''].clear();

        var rsImports:Map<String, Dynamic> = OGRuleScript.defaultImports[''];

        for (cls in IMPORTS)
			rsImports.set(Type.getClassName(cls).split('.').pop(), cls);

        for (abs in ABSTRACTS)
            rsImports.set(abs.trim().split('.').pop(), Abstracts.resolveAbstract(abs));

		for (def in TYPEDEFS.keys())
			rsImports.set(def, TYPEDEFS.get(def));
        
		for (def in VARIABLES.keys())
			rsImports.set(def, VARIABLES.get(def));
    }
}