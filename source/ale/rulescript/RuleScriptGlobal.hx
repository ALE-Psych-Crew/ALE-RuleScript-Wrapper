package ale.rulescript;

import sys.FileSystem;
import sys.io.File;

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

    // Modules

    public static var MODULE_EXTENSION:String;
    public static var MODULE_PATH:String;
    public static var MODULE_RESOLVER:String -> Array<ModuleDecl>;

    // Scripts
    
    public static var SCRIPT_PATH:String;
    public static var SCRIPT_EXTENSION:String;
    public static var SCRIPT_RESOLVER:String -> Dynamic;

    // Classes

    public static var BUILD_BRIDGE:String -> Dynamic -> OGRuleScript;

    // Debug

    public static var SCRIPT_NAME:String;
    public static var ERROR_HANDLER:Dynamic -> Dynamic;

    // Utils & Default Values

    public static function reset()
    {
        FILE_CHECKER = FileSystem.exists;
        FILE_READER = File.getContent;

        IMPORTS = RuleScriptPresets.IMPORTS;
        ABSTRACTS = RuleScriptPresets.ABSTRACTS;
        TYPEDEFS = RuleScriptPresets.TYPEDEFS;

        SCRIPT_NAME = 'ale-rulescript-module.hx';
        ERROR_HANDLER = RuleScriptPresets.ERROR_HANDLER;

        MODULE_EXTENSION = '.hx';
        MODULE_PATH = 'scripts/classes/';
        MODULE_RESOLVER = RuleScriptPresets.MODULE_RESOLVER;

        SCRIPT_PATH = 'scripts/';
        SCRIPT_EXTENSION = '.hx';
        SCRIPT_RESOLVER = RuleScriptPresets.SCRIPT_RESOLVER;

        BUILD_BRIDGE = RuleScriptPresets.BUILD_BRIDGE;
    }

    @:unreflective static var initializedValues:Bool = false;

    public static function apply()
    {
        if (!initializedValues)
        {
            reset();

            initializedValues = true;
        }

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
    }
}