package ale.rulescript;

import sys.FileSystem;
import sys.io.File;

import rulescript.types.ScriptedTypeUtil;

import hscript.Expr;

class ALERuleScriptGlobal
{
    public static function apply()
    {
        if (ScriptedTypeUtil.resolveModule != MODULE_RESOLVER)
            ScriptedTypeUtil.resolveModule = MODULE_RESOLVER;
    }

    // Global

    public static var FILE_CHECKER:String -> Bool = FileSystem.exists;
    public static var FILE_READER:String -> String = File.getContent;

    // Debug

    public static var SCRIPT_NAME:String = 'ale-rulescript.hx';

    // Modules

    public static var MODULE_EXTENSION:String = '.hx';
    public static var MODULE_PATH:String = 'scripts/classes/';
    public static var MODULE_RESOLVER:String -> Array<ModuleDecl> = ALERuleScriptPresets.MODULE_RESOLVER;
}