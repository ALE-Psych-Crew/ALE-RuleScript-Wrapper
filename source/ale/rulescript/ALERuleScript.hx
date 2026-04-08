package ale.rulescript;

import rulescript.interps.RuleScriptInterp;
import rulescript.RuleScript;
import rulescript.Context;

using StringTools;

class ALERuleScript extends RuleScript
{
    public function new(scriptName:String, ?context:Context)
    {
        super(new RuleScriptInterp(), new ALEHxParser(scriptName), context);

        getInterp(RuleScriptInterp).scriptName = scriptName.replace('.', '/') + ALERuleScriptGlobal.SCRIPT_EXTENSION;

        this.errorHandler = ALERuleScriptGlobal.ERROR_HANDLER;
    }

    public function call(name:String, ?args:Array<Dynamic>):Dynamic
    {
        final func:Dynamic = variables.get(name);

        if (func != null && Reflect.isFunction(func))
        {
            try
            {
                return Reflect.callMethod(null, func, args ?? []);
            } catch(error:Exception) {
                ALERuleScriptGlobal.ERROR_HANDLER(error.details());
            }
        }

        return null;
    }

    public function set(name:String, value:Dynamic):Void
        variables.set(name, value);

	public function setClass(cls:Class<Dynamic>):Void
		set(Type.getClassName(cls).split('.').pop(), cls);
}