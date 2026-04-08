package ale.rulescript;

import sys.FileSystem;
import sys.io.File;

import rulescript.scriptedClass.RuleScriptedClassUtil;
import rulescript.RuleScript as OGRuleScript;
import rulescript.types.ScriptedTypeUtil;

import hscript.Expr;

class RuleScriptGlobal
{
    // Global

    public static var FILE_CHECKER:String -> Bool;
    public static var FILE_READER:String -> String;

    // Debug

    public static var SCRIPT_NAME:String;
    public static var ERROR_HANDLER:Dynamic -> Dynamic;

    // Modules

    public static var MODULE_EXTENSION:String;
    public static var MODULE_PATH:String;
    public static var MODULE_RESOLVER:String -> Array<ModuleDecl>;

    // Scripts
    
    public static var SCRIPT_PATH:String;
    public static var SCRIPT_EXTENSION:String;

    // Classes

    public static var BUILD_BRIDGE:String -> Dynamic -> OGRuleScript;

    // Utils

    @:unreflective static var initializedValues:Bool = false;

    public static function apply()
    {
        if (!initializedValues)
        {
            reset();

            initializedValues = true;
        }

        ScriptedTypeUtil.resolveModule = MODULE_RESOLVER;
    }

    public static function reset()
    {
        FILE_CHECKER = FileSystem.exists;
        FILE_READER = File.getContent;

        SCRIPT_NAME = 'ale-rulescript-module.hx';
        ERROR_HANDLER = RuleScriptPresets.ERROR_HANDLER;

        MODULE_EXTENSION = '.hx';
        MODULE_PATH = 'scripts/classes/';
        MODULE_RESOLVER = RuleScriptPresets.MODULE_RESOLVER;

        SCRIPT_PATH = 'scripts/';
        SCRIPT_EXTENSION = '.hx';

        BUILD_BRIDGE = RuleScriptPresets.BUILD_BRIDGE;
    }
}