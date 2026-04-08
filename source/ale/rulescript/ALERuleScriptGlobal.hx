package ale.rulescript;

import sys.FileSystem;
import sys.io.File;

import rulescript.scriptedClass.RuleScriptedClassUtil;
import rulescript.types.ScriptedTypeUtil;
import rulescript.RuleScript;

import hscript.Expr;

class ALERuleScriptGlobal
{
    // Global

    public static var FILE_CHECKER:String -> Bool;
    public static var FILE_READER:String -> String;

    // Debug

    public static var SCRIPT_NAME:String;
    public static var ERROR_HANDLER:String -> Void;

    // Modules

    public static var MODULE_EXTENSION:String;
    public static var MODULE_PATH:String;
    public static var MODULE_RESOLVER:String -> Array<ModuleDecl>;

    // Scripts
    
    public static var SCRIPT_PATH:String;
    public static var SCRIPT_EXTENSION:String;

    // Classes

    public static var BUILD_BRIDGE:String -> Dynamic -> RuleScript;

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

        MODULE_EXTENSION = '.hx';
        MODULE_PATH = 'scripts/classes/';
        MODULE_RESOLVER = ALERuleScriptPresets.MODULE_RESOLVER;

        BUILD_BRIDGE = ALERuleScriptPresets.BUILD_BRIDGE;

        SCRIPT_EXTENSION = '.hx';
    }
}